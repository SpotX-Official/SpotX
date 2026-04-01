(() => {
  if (window.oneTime) return;
  window.oneTime = true;

  const REPORT_BASE_URL = "https://spotify-ingest-admin.amd64fox1.workers.dev";

  const SOURCE_LABELS = {
    REMOTE: "latest.json",
    LOCAL: "window",
    FIXED: "fixed-version"
  };

  const PLATFORMS = [
    {
      code: "Win32_x86_64",
      os: "win",
      arch: "x64",
      assetPrefix: "spotify_installer",
      assetSuffix: "x64",
      extension: ".exe",
      systemInfo: "Windows 10 (10.0.19045; x64)"
    },
    {
      code: "Win32_ARM64",
      os: "win",
      arch: "arm64",
      assetPrefix: "spotify_installer",
      assetSuffix: "arm64",
      extension: ".exe",
      systemInfo: "Windows 11 (10.0.22631; arm64)"
    },
    {
      code: "OSX",
      os: "mac",
      arch: "intel",
      assetPrefix: "spotify-autoupdate",
      assetSuffix: "x86_64",
      extension: ".tbz",
      systemInfo: "macOS 15.3 (macOS 15.3; x86_64)"
    },
    {
      code: "OSX_ARM64",
      os: "mac",
      arch: "arm64",
      assetPrefix: "spotify-autoupdate",
      assetSuffix: "arm64",
      extension: ".tbz",
      systemInfo: "macOS 15.3 (macOS 15.3; arm64)"
    }
  ];

  const PLATFORM_CODES = PLATFORMS.map((platform) => platform.code);
  const SUCCESS_REPORT_STORAGE_KEY = "spotify_ingest:last_successful_report_v1";
  const ERROR_MESSAGES = {
    token_missing: "Authorization token not captured",
    version_unavailable: "Spotify version unavailable. Update check stopped",
    all_platform_requests_failed: "All desktop-update platform requests failed",
    incomplete_platform_set: "Incomplete update link set.",
    inconsistent_target_version: "Inconsistent target version across platform links",
    empty_response: "No update link in response"
  };

  const CONFIG = {
    fixedShortVersion: "",
    latestUrls: Array.isArray(window.__spotifyLatestUrls)
      ? window.__spotifyLatestUrls.filter((url) => typeof url === "string" && url.trim()).map((url) => url.trim())
      : window.__spotifyLatestUrl
        ? [String(window.__spotifyLatestUrl).trim()]
        : [
          "https://raw.githubusercontent.com/LoaderSpot/table/refs/heads/main/latest.json",
          "https://raw.githack.com/LoaderSpot/table/main/latest.json"
        ],
    updateUrl: "https://spclient.wg.spotify.com/desktop-update/v2/update",
    reportEndpoint: `${REPORT_BASE_URL}/api/client/report`,
    errorEndpoint: `${REPORT_BASE_URL}/api/client/error`,
    reportTimeoutMs: 15000,
    versionTimeoutMs: 10000
  };

  const originalFetch = window.fetch;
  let runStarted = false;

  const SPOTIFY_VERSION_RE = /Spotify\/(\d+\.\d+\.\d+\.\d+)/;

  function nowIso() {
    return new Date().toISOString();
  }

  function extractShortVersion(value) {
    return String(value || "").match(/(\d+\.\d+\.\d+\.\d+)/)?.[1] || "";
  }

  function getLocalSpotifyVersion() {
    const sources = [
      window.clientInformation?.appVersion,
      navigator.userAgent,
      window.navigator?.appVersion
    ];

    for (const source of sources) {
      const version = String(source || "").match(SPOTIFY_VERSION_RE)?.[1];
      if (version) {
        return version;
      }
    }

    return "";
  }

  function readClientVersionSources() {
    const clientInformationAppVersion = String(window.clientInformation?.appVersion || "");
    const userAgent = String(navigator.userAgent || "");
    const navigatorAppVersion = String(window.navigator?.appVersion || "");

    return {
      clientInformationAppVersion,
      userAgent,
      navigatorAppVersion,
      realVersion:
        userAgent.match(SPOTIFY_VERSION_RE)?.[1] ||
        navigatorAppVersion.match(SPOTIFY_VERSION_RE)?.[1] ||
        "undefined"
    };
  }

  function buildSpotifyAppVersion(shortVersion, sourceLabel) {
    if (!shortVersion) {
      console.warn(`Spotify version not found (${sourceLabel}).`);
      return "";
    }

    const parts = shortVersion.split(".");
    if (parts.length !== 4) {
      console.warn(`Invalid Spotify version format (${sourceLabel}):`, shortVersion);
      return "";
    }

    const [major, minor, patch, build] = parts;
    return major + minor + patch + "0".repeat(Math.max(0, 7 - patch.length - build.length)) + build;
  }

  async function fetchJsonWithTimeout(url, timeoutMs) {
    const controller = new AbortController();
    const timeoutId = setTimeout(() => controller.abort(), timeoutMs);

    try {
      const response = await originalFetch(url, {
        method: "GET",
        cache: "no-store",
        signal: controller.signal
      });

      if (!response.ok) {
        throw new Error(`HTTP error: ${response.status}`);
      }

      return response.json();
    } finally {
      clearTimeout(timeoutId);
    }
  }

  async function resolveQueryVersion() {
    const fixedShortVersion = String(CONFIG.fixedShortVersion || "").trim();
    if (fixedShortVersion) {
      return {
        shortVersion: fixedShortVersion,
        fullVersion: "",
        spotifyAppVersion: buildSpotifyAppVersion(fixedShortVersion, SOURCE_LABELS.FIXED),
        sourceLabel: SOURCE_LABELS.FIXED,
        remoteVersionFailed: false,
        remoteShortVersion: "",
        remoteFullVersion: ""
      };
    }

    let lastError = null;
    for (const latestUrl of CONFIG.latestUrls) {
      try {
        const data = await fetchJsonWithTimeout(latestUrl, CONFIG.versionTimeoutMs);
        const shortVersion = String(data?.version || "").trim();
        const fullVersion = String(data?.fullversion || "").trim();

        if (!shortVersion) {
          throw new Error("version field is missing or empty.");
        }

        return {
          shortVersion,
          fullVersion,
          spotifyAppVersion: buildSpotifyAppVersion(shortVersion, SOURCE_LABELS.REMOTE),
          sourceLabel: SOURCE_LABELS.REMOTE,
          remoteVersionFailed: false,
          remoteShortVersion: shortVersion,
          remoteFullVersion: fullVersion
        };
      } catch (error) {
        lastError = error;
        console.warn(`Failed to fetch latest.json version from ${latestUrl}: ${error?.message || error}`);
      }
    }

    const localVersion = getLocalSpotifyVersion();
    return {
      shortVersion: localVersion,
      fullVersion: "",
      spotifyAppVersion: buildSpotifyAppVersion(localVersion, SOURCE_LABELS.LOCAL),
      sourceLabel: SOURCE_LABELS.LOCAL,
      remoteVersionFailed: true,
      remoteShortVersion: "",
      remoteFullVersion: ""
    };
  }

  function createState(token) {
    return {
      token,
      startedAtMs: Date.now(),
      versionSources: readClientVersionSources(),
      spotifyAppVersion: "",
      sourceLabel: "",
      queryShortVersion: "",
      queryFullVersion: "",
      remoteVersionFailed: false,
      remoteShortVersion: "",
      remoteFullVersion: "",
      targetShortVersion: "",
      targetFullVersion: "",
      platforms: {},
      failures: []
    };
  }

  function readClientContext(state) {
    const nav = window.navigator || {};
    return {
      userAgent: state.versionSources.userAgent || nav.userAgent || "",
      platform: nav.platform || "",
      language: nav.language || "",
      languages: Array.isArray(nav.languages) ? nav.languages.slice(0, 5) : [],
      clientInformationAppVersion: state.versionSources.clientInformationAppVersion,
      navigatorAppVersion: state.versionSources.navigatorAppVersion,
      "real-version": state.versionSources.realVersion,
      spotifyAppVersion: state.spotifyAppVersion,
      sourceLabel: state.sourceLabel,
      latestJsonVersion: state.sourceLabel === SOURCE_LABELS.REMOTE ? state.remoteShortVersion : "",
      latestJsonFullVersion: state.sourceLabel === SOURCE_LABELS.REMOTE ? state.remoteFullVersion : ""
    };
  }

  function readRequestMeta(state, extra = {}) {
    return {
      source: "spotify-client-script",
      timestamp: nowIso(),
      hasAuthorization: Boolean(state.token),
      headers: { "spotify-app-version": state.spotifyAppVersion },
      ...extra
    };
  }

  function readDiagnostics(state, result, extra = {}) {
    return {
      result,
      remoteVersionUsed: state.sourceLabel === SOURCE_LABELS.REMOTE,
      remoteVersionFailed: state.remoteVersionFailed,
      remoteVersion: state.remoteShortVersion || null,
      remoteFullVersion: state.remoteFullVersion || null,
      queryShortVersion: state.queryShortVersion || null,
      queryFullVersion: state.queryFullVersion || null,
      detectedShortVersion: state.targetShortVersion || null,
      detectedFullVersion: state.targetFullVersion || null,
      requestDurationMs: Math.max(0, Date.now() - state.startedAtMs),
      checkedPlatforms: PLATFORM_CODES,
      failures: state.failures,
      ...extra
    };
  }

  function getPayloadVersions(state) {
    return {
      shortVersion: state.targetShortVersion || state.queryShortVersion,
      fullVersion: state.targetFullVersion || state.queryFullVersion
    };
  }

  function buildNormalizedAssetName(platform, fullVersion) {
    return `${platform.assetPrefix}-${fullVersion}-${platform.assetSuffix}${platform.extension}`;
  }

  function parseUpgradeAsset(platform, sourceUrl) {
    let normalizedUrl;
    try {
      normalizedUrl = new URL(sourceUrl);
    } catch {
      throw new Error(`Invalid upgrade link URL for ${platform.code}.`);
    }

    const assetName = decodeURIComponent(normalizedUrl.pathname.split("/").pop() || "");
    const pattern = platform.extension === ".exe"
      ? /^spotify_installer-(.+?)-(?:\d+|x86|x64|arm64)\.exe$/i
      : /^spotify-autoupdate-(.+?)-(?:\d+|x86_64|arm64)\.tbz$/i;
    const fullVersion = assetName.match(pattern)?.[1]?.trim() || "";
    const shortVersion = extractShortVersion(fullVersion);

    if (!fullVersion || !shortVersion) {
      throw new Error(`Unsupported upgrade asset name for ${platform.code}: ${assetName}`);
    }

    return {
      url: normalizedUrl.toString(),
      shortVersion,
      fullVersion,
      normalizedAssetName: buildNormalizedAssetName(platform, fullVersion)
    };
  }

  function finalizeDetectedVersions(state) {
    const assets = Object.values(state.platforms);
    const shortVersions = [...new Set(assets.map((asset) => asset.shortVersion).filter(Boolean))];
    const fullVersions = [...new Set(assets.map((asset) => asset.fullVersion).filter(Boolean))];

    if (shortVersions.length > 1 || fullVersions.length > 1) {
      return false;
    }

    state.targetShortVersion = shortVersions[0] || "";
    state.targetFullVersion = fullVersions[0] || "";
    return true;
  }

  function buildPlatformPayload(platforms) {
    const payload = {};
    for (const [code, asset] of Object.entries(platforms)) {
      if (!asset) continue;
      payload[code] = {
        url: asset.url,
        shortVersion: asset.shortVersion,
        fullVersion: asset.fullVersion,
        normalizedAssetName: asset.normalizedAssetName
      };
    }
    return payload;
  }

  function getSuccessReportStorage() {
    try {
      return window.localStorage || null;
    } catch {
      return null;
    }
  }

  function clearStoredSuccessReport(storage = getSuccessReportStorage()) {
    if (!storage) {
      return;
    }
    try {
      storage.removeItem(SUCCESS_REPORT_STORAGE_KEY);
    } catch {
      // ignore storage cleanup failures
    }
  }

  function readStoredSuccessReport() {
    const storage = getSuccessReportStorage();
    if (!storage) {
      return null;
    }

    let rawValue = "";
    try {
      rawValue = String(storage.getItem(SUCCESS_REPORT_STORAGE_KEY) || "");
    } catch {
      return null;
    }

    if (!rawValue) {
      return null;
    }

    try {
      const parsed = JSON.parse(rawValue);
      const shortVersion = String(parsed?.shortVersion || "").trim();
      const fullVersion = String(parsed?.fullVersion || "").trim();
      const reportedAt = String(parsed?.reportedAt || "").trim();

      if (!fullVersion) {
        clearStoredSuccessReport(storage);
        return null;
      }

      return {
        shortVersion,
        fullVersion,
        reportedAt
      };
    } catch {
      clearStoredSuccessReport(storage);
      return null;
    }
  }

  function isAlreadyReported(fullVersion) {
    const normalizedFullVersion = String(fullVersion || "").trim();
    if (!normalizedFullVersion) {
      return false;
    }
    return readStoredSuccessReport()?.fullVersion === normalizedFullVersion;
  }

  function writeStoredSuccessReport(state) {
    const storage = getSuccessReportStorage();
    if (!storage) {
      return false;
    }

    const payload = {
      shortVersion: state.targetShortVersion || state.queryShortVersion || "",
      fullVersion: state.targetFullVersion || state.queryFullVersion || "",
      reportedAt: nowIso()
    };
    if (!payload.fullVersion) {
      return false;
    }

    try {
      storage.setItem(SUCCESS_REPORT_STORAGE_KEY, JSON.stringify(payload));
      return true;
    } catch {
      return false;
    }
  }

  function sendBestEffortPayload(endpoint, payload) {
    if (!endpoint) {
      return;
    }

    const body = JSON.stringify(payload);

    try {
      if (navigator.sendBeacon && navigator.sendBeacon(endpoint, body)) {
        return;
      }
    } catch {
      // ignore beacon failure and fall back to fetch
    }

    const controller = new AbortController();
    const timeoutId = setTimeout(() => controller.abort(), CONFIG.reportTimeoutMs);

    void originalFetch(endpoint, {
      method: "POST",
      headers: { "Content-Type": "text/plain;charset=UTF-8" },
      body,
      cache: "no-store",
      keepalive: true,
      signal: controller.signal
    }).catch((error) => {
      console.warn("Failed to send report:", error?.message || error);
    }).finally(() => {
      clearTimeout(timeoutId);
    });
  }

  async function postSuccessPayloadWithAck(endpoint, payload) {
    if (!endpoint) {
      return false;
    }

    const body = JSON.stringify(payload);
    const controller = new AbortController();
    const timeoutId = setTimeout(() => controller.abort(), CONFIG.reportTimeoutMs);

    try {
      const response = await originalFetch(endpoint, {
        method: "POST",
        headers: { "Content-Type": "text/plain;charset=UTF-8" },
        body,
        cache: "no-store",
        keepalive: true,
        signal: controller.signal
      });

      if (response.status === 200) {
        return true;
      }

      console.warn(`Client report rejected with HTTP ${response.status}.`);
      return false;
    } catch (error) {
      console.warn("Failed to send acknowledged report:", error?.message || error);
      return false;
    } finally {
      clearTimeout(timeoutId);
    }
  }

  async function sendSuccess(state) {
    const versions = getPayloadVersions(state);
    return postSuccessPayloadWithAck(CONFIG.reportEndpoint, {
      shortVersion: versions.shortVersion,
      fullVersion: versions.fullVersion,
      platforms: buildPlatformPayload(state.platforms),
      clientContext: readClientContext(state),
      requestMeta: readRequestMeta(state),
      diagnostics: readDiagnostics(state, "success")
    });
  }

  function sendError(state, kind, extra = {}) {
    const versions = getPayloadVersions(state);
    sendBestEffortPayload(CONFIG.errorEndpoint, {
      kind,
      phase: extra.phase || kind,
      shortVersion: versions.shortVersion,
      fullVersion: versions.fullVersion,
      message: extra.message || ERROR_MESSAGES[kind] || "Unexpected error.",
      stack: extra.stack || "",
      partialPlatforms: buildPlatformPayload(state.platforms),
      clientContext: readClientContext(state),
      requestMeta: readRequestMeta(state, extra.requestMeta),
      diagnostics: readDiagnostics(state, "error", extra.diagnostics)
    });
  }

  function extractUpgradeLink(buffer) {
    const payload = new TextDecoder("latin1").decode(buffer);
    const baseUrl = payload.match(
      /https:\/\/upgrade\.scdn\.co\/upgrade\/client\/(?:win32-(?:x86_64|arm64)|osx-(?:x86_64|arm64))\/[A-Za-z0-9._-]+\.(?:exe|tbz)/i
    )?.[0];
    const authQuery = payload.match(/\?fauth=[A-Za-z0-9._~-]+/)?.[0];
    return baseUrl && authQuery ? `${baseUrl}${authQuery}` : "";
  }

  async function fetchUpgradeLink(token, spotifyAppVersion, platform) {
    const response = await originalFetch(CONFIG.updateUrl, {
      method: "GET",
      headers: {
        Authorization: `Bearer ${token}`,
        "Spotify-App-Version": spotifyAppVersion,
        "App-Platform": platform.code
      }
    });

    if (!response.ok) {
      throw new Error(`${platform.code} HTTP error: ${response.status}`);
    }

    return extractUpgradeLink(await response.arrayBuffer());
  }

  async function collectPlatforms(state) {
    for (const platform of PLATFORMS) {
      try {
        const upgradeLink = await fetchUpgradeLink(state.token, state.spotifyAppVersion, platform);
        if (!upgradeLink) {
          state.failures.push({
            platform: platform.code,
            kind: "empty_response",
            message: ERROR_MESSAGES.empty_response
          });
          continue;
        }

        state.platforms[platform.code] = parseUpgradeAsset(platform, upgradeLink);
      } catch (error) {
        state.failures.push({
          platform: platform.code,
          kind: "platform_request_failed",
          message: error?.message || String(error)
        });
      }
    }
  }

  async function runOnce(token) {
    const state = createState(token);

    if (!token) {
      sendError(state, "token_missing");
      return;
    }

    const version = await resolveQueryVersion();
    state.queryShortVersion = version.shortVersion;
    state.queryFullVersion = version.fullVersion;
    state.spotifyAppVersion = version.spotifyAppVersion;
    state.sourceLabel = version.sourceLabel;
    state.remoteVersionFailed = version.remoteVersionFailed;
    state.remoteShortVersion = version.remoteShortVersion;
    state.remoteFullVersion = version.remoteFullVersion;

    if (!state.spotifyAppVersion) {
      sendError(state, "version_unavailable");
      return;
    }

    await collectPlatforms(state);

    const foundCount = Object.keys(state.platforms).length;
    if (!foundCount) {
      if (state.failures.some((failure) => failure.kind === "platform_request_failed")) {
        sendError(state, "all_platform_requests_failed", {
          diagnostics: {
            missingPlatforms: PLATFORM_CODES.filter((code) => !state.platforms[code])
          }
        });
      }
      return;
    }

    if (!finalizeDetectedVersions(state)) {
      sendError(state, "inconsistent_target_version", {
        diagnostics: {
          detectedShortVersions: [...new Set(Object.values(state.platforms).map((asset) => asset.shortVersion))],
          detectedFullVersions: [...new Set(Object.values(state.platforms).map((asset) => asset.fullVersion))]
        }
      });
      return;
    }

    if (foundCount !== PLATFORM_CODES.length) {
      sendError(state, "incomplete_platform_set", {
        diagnostics: {
          missingPlatforms: PLATFORM_CODES.filter((code) => !state.platforms[code])
        }
      });
      return;
    }

    if (isAlreadyReported(state.targetFullVersion)) {
      return;
    }

    if (await sendSuccess(state)) {
      writeStoredSuccessReport(state);
    }
  }

  function getHeaderValue(headers, name) {
    const target = String(name).toLowerCase();
    if (!headers) return null;

    if (headers instanceof Headers) {
      return headers.get(target);
    }

    if (Array.isArray(headers)) {
      return headers.find(([key]) => String(key).toLowerCase() === target)?.[1] || null;
    }

    if (typeof headers === "object") {
      for (const key of Object.keys(headers)) {
        if (key.toLowerCase() === target) {
          return headers[key];
        }
      }
    }

    return null;
  }

  function getRequestUrl(input) {
    if (typeof input === "string") return input;
    if (input instanceof URL) return input.toString();
    if (input instanceof Request) return input.url;
    return "";
  }

  function isSpotifyAuthorizedRequest(url, authorization) {
    return Boolean(
      authorization &&
      /^Bearer\s+/i.test(String(authorization)) &&
      /spclient\.wg\.spotify\.com/i.test(String(url || ""))
    );
  }

  window.fetch = async function (...args) {
    const [input, init] = args;
    const headers = init?.headers || (input instanceof Request ? input.headers : null);
    const authorization = getHeaderValue(headers, "authorization");

    if (!runStarted && isSpotifyAuthorizedRequest(getRequestUrl(input), authorization)) {
      runStarted = true;
      window.fetch = originalFetch;

      const token = String(authorization).replace(/^Bearer\s+/i, "");
      void runOnce(token).catch((error) => {
        const state = createState(token);
        sendError(state, "uncaught", {
          phase: "uncaught_runOnce",
          message: error?.message || String(error),
          stack: error?.stack || ""
        });
      });
    }

    return originalFetch.apply(this, args);
  };
})();
