(() => {
  if (window.oneTime) return;
  window.oneTime = true;

  const REPORT_BASE_URL = "https://spotify-ingest-admin.amd64fox1.workers.dev";
  const SCRIPT_VERSION = "1.1.0";

  const SOURCE_LABELS = {
    REMOTE: "latest.json",
    LOCAL: "window",
    FIXED: "fixed-version"
  };

  const PLATFORMS = [
    {
      code: "Win32_x86_64",
      assetPrefix: "spotify_installer",
      assetSuffix: "x64",
      extension: ".exe"
    },
    {
      code: "Win32_ARM64",
      assetPrefix: "spotify_installer",
      assetSuffix: "arm64",
      extension: ".exe"
    },
    {
      code: "OSX",
      assetPrefix: "spotify-autoupdate",
      assetSuffix: "x86_64",
      extension: ".tbz"
    },
    {
      code: "OSX_ARM64",
      assetPrefix: "spotify-autoupdate",
      assetSuffix: "arm64",
      extension: ".tbz"
    }
  ];

  const PLATFORM_CODES = PLATFORMS.map((platform) => platform.code);
  const SUCCESS_REPORT_STORAGE_KEY = "spotify_ingest:last_successful_report_v1";
  const ERROR_MESSAGES = {
    token_missing: "Authorization token not captured",
    version_unavailable: "Spotify version unavailable. Update check stopped",
    inconsistent_target_version: "Inconsistent target version across platform links",
    empty_response: "No update link in response",
    desktop_update_parse_error: "Desktop-update response parse failed."
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
    versionTimeoutMs: 10000,
    desktopUpdateTimeoutMs: 8000,
    desktopUpdateMaxRetries: 1
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

  function readVersionSourceSnapshot() {
    return {
      clientInformationAppVersion: String(window.clientInformation?.appVersion || ""),
      userAgent: String(navigator.userAgent || ""),
      navigatorAppVersion: String(window.navigator?.appVersion || "")
    };
  }

  function getLocalSpotifyVersion() {
    const versionSources = readVersionSourceSnapshot();
    const sources = [
      versionSources.clientInformationAppVersion,
      versionSources.userAgent,
      versionSources.navigatorAppVersion
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
    const versionSources = readVersionSourceSnapshot();

    return {
      clientInformationAppVersion: versionSources.clientInformationAppVersion,
      userAgent: versionSources.userAgent,
      navigatorAppVersion: versionSources.navigatorAppVersion,
      realVersion:
        versionSources.userAgent.match(SPOTIFY_VERSION_RE)?.[1] ||
        versionSources.navigatorAppVersion.match(SPOTIFY_VERSION_RE)?.[1] ||
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
      failures: [],
      desktopUpdateResponses: [],
      retryCountByPlatform: {},
      forensicMode: false
    };
  }

  function readClientContext(state) {
    const nav = window.navigator || {};
    return {
      scriptVersion: SCRIPT_VERSION,
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
      foundPlatforms: Object.keys(state.platforms),
      failures: state.failures,
      ...extra
    };
  }

  function getPayloadVersions(state) {
    return {
      shortVersion: state.targetShortVersion || "",
      fullVersion: state.targetFullVersion || ""
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
      shortVersion: state.targetShortVersion || "",
      fullVersion: state.targetFullVersion || "",
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

  function postJsonWithTimeout(endpoint, body) {
    const controller = new AbortController();
    const timeoutId = setTimeout(() => controller.abort(), CONFIG.reportTimeoutMs);

    return originalFetch(endpoint, {
      method: "POST",
      headers: { "Content-Type": "text/plain;charset=UTF-8" },
      body,
      cache: "no-store",
      keepalive: true,
      signal: controller.signal
    }).finally(() => {
      clearTimeout(timeoutId);
    });
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

    void postJsonWithTimeout(endpoint, body).catch((error) => {
      console.warn("Failed to send report:", error?.message || error);
    });
  }

  async function postSuccessPayloadWithAck(endpoint, payload) {
    if (!endpoint) {
      return false;
    }

    const body = JSON.stringify(payload);

    try {
      const response = await postJsonWithTimeout(endpoint, body);

      if (response.status === 200) {
        return true;
      }

      console.warn(`Client report rejected with HTTP ${response.status}.`);
      return false;
    } catch (error) {
      console.warn("Failed to send acknowledged report:", error?.message || error);
      return false;
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
      diagnostics: readDiagnostics(state, "error", extra.diagnostics),
      rawPayload: extra.rawPayload
    });
  }

  function decodeLatin1Buffer(buffer) {
    return new TextDecoder("latin1").decode(buffer);
  }

  function extractUpgradeLink(bodyLatin1) {
    const payload = String(bodyLatin1 || "");
    const baseUrl = payload.match(
      /https:\/\/upgrade\.scdn\.co\/upgrade\/client\/(?:win32-(?:x86_64|arm64)|osx-(?:x86_64|arm64))\/[A-Za-z0-9._-]+\.(?:exe|tbz)/i
    )?.[0];
    const authQuery = payload.match(/\?fauth=[A-Za-z0-9._~-]+/)?.[0];
    return baseUrl && authQuery ? `${baseUrl}${authQuery}` : "";
  }

  function readResponseHeaders(headers) {
    const result = {};
    if (!headers || typeof headers.forEach !== "function") {
      return result;
    }
    headers.forEach((value, key) => {
      result[String(key || "").toLowerCase()] = String(value || "");
    });
    return result;
  }

  function formatDesktopUpdateError(platform, error) {
    if (error?.name === "AbortError") {
      return `${platform.code} request timeout after ${CONFIG.desktopUpdateTimeoutMs}ms`;
    }
    return error?.message || String(error);
  }

  function buildRequestErrorResult(base, errorMessage) {
    return {
      outcome: "request_error",
      finalUrl: base.finalUrl || CONFIG.updateUrl,
      status: Number.isFinite(Number(base.status)) ? Number(base.status) : null,
      headers: base.headers || {},
      contentType: base.contentType || null,
      contentLength: base.contentLength || null,
      byteLength: null,
      bodyLatin1: null,
      extractedUpgradeLink: "",
      parseErrorMessage: null,
      errorMessage: errorMessage || null
    };
  }

  async function fetchDesktopUpdateAttempt(token, spotifyAppVersion, platform) {
    const controller = new AbortController();
    const timeoutId = setTimeout(() => controller.abort(), CONFIG.desktopUpdateTimeoutMs);

    let response;
    try {
      response = await originalFetch(CONFIG.updateUrl, {
        method: "GET",
        headers: {
          Authorization: `Bearer ${token}`,
          "Spotify-App-Version": spotifyAppVersion,
          "App-Platform": platform.code
        },
        signal: controller.signal
      });
    } catch (error) {
      return buildRequestErrorResult({
        finalUrl: CONFIG.updateUrl,
        status: null,
        headers: {},
        contentType: null,
        contentLength: null
      }, formatDesktopUpdateError(platform, error));
    } finally {
      clearTimeout(timeoutId);
    }

    const finalUrl = response.url || CONFIG.updateUrl;
    const headers = readResponseHeaders(response.headers);
    const contentType = response.headers?.get?.("content-type") || null;
    const contentLength = response.headers?.get?.("content-length") || null;

    if (!response.ok) {
      return buildRequestErrorResult({
        finalUrl,
        status: response.status,
        headers,
        contentType,
        contentLength
      }, `${platform.code} HTTP error: ${response.status}`);
    }

    let buffer;
    try {
      buffer = await response.arrayBuffer();
    } catch (error) {
      return buildRequestErrorResult({
        finalUrl,
        status: response.status,
        headers,
        contentType,
        contentLength
      }, formatDesktopUpdateError(platform, error));
    }

    const bodyLatin1 = decodeLatin1Buffer(buffer);
    const extractedUpgradeLink = extractUpgradeLink(bodyLatin1);
    const baseResult = {
      finalUrl,
      status: response.status,
      headers,
      contentType,
      contentLength,
      byteLength: buffer.byteLength,
      bodyLatin1,
      extractedUpgradeLink
    };

    if (!extractedUpgradeLink) {
      return {
        outcome: "empty_response",
        ...baseResult,
        parseErrorMessage: null,
        errorMessage: null
      };
    }

    try {
      const asset = parseUpgradeAsset(platform, extractedUpgradeLink);
      return {
        outcome: "success",
        ...baseResult,
        parseErrorMessage: null,
        errorMessage: null,
        asset
      };
    } catch (error) {
      return {
        outcome: "parse_error",
        ...baseResult,
        parseErrorMessage: error?.message || String(error),
        errorMessage: null
      };
    }
  }

  function buildAttemptMetadata(attemptNumber, result) {
    return {
      attempt: attemptNumber,
      outcome: result.outcome,
      status: Number.isFinite(Number(result.status)) ? Number(result.status) : null,
      finalUrl: result.finalUrl || null,
      contentType: result.contentType || null,
      contentLength: result.contentLength || null,
      byteLength: Number.isFinite(Number(result.byteLength)) ? Number(result.byteLength) : null,
      errorMessage: result.errorMessage || null
    };
  }

  function buildDesktopUpdateResponseRecord(platformCode, attempts, result, requestErrors) {
    return {
      platform: platformCode,
      attempts,
      finalOutcome: result.outcome,
      finalUrl: result.finalUrl || null,
      status: Number.isFinite(Number(result.status)) ? Number(result.status) : null,
      headers: result.headers || {},
      contentType: result.contentType || null,
      contentLength: result.contentLength || null,
      byteLength: Number.isFinite(Number(result.byteLength)) ? Number(result.byteLength) : null,
      bodyLatin1: result.bodyLatin1 || null,
      extractedUpgradeLink: result.extractedUpgradeLink || "",
      parseErrorMessage: result.parseErrorMessage || null,
      requestErrors
    };
  }

  function buildForensicDiagnostics(state) {
    const retryCountByPlatform = {};
    for (const platform of PLATFORMS) {
      retryCountByPlatform[platform.code] = Number(state.retryCountByPlatform[platform.code] || 0);
    }

    const successfulPlatforms = [];
    const parseErrorPlatforms = [];
    const requestErrorPlatforms = [];
    const emptyResponsePlatforms = [];

    for (const item of state.desktopUpdateResponses) {
      if (!item?.platform) {
        continue;
      }
      if (item.finalOutcome === "success") successfulPlatforms.push(item.platform);
      if (item.finalOutcome === "parse_error") parseErrorPlatforms.push(item.platform);
      if (item.finalOutcome === "request_error") requestErrorPlatforms.push(item.platform);
      if (item.finalOutcome === "empty_response") emptyResponsePlatforms.push(item.platform);
    }

    return {
      successfulPlatforms,
      parseErrorPlatforms,
      requestErrorPlatforms,
      emptyResponsePlatforms,
      retryCountByPlatform
    };
  }

  function buildForensicRawPayload(state) {
    return {
      desktopUpdateResponses: state.desktopUpdateResponses.map((item) => ({
        platform: item.platform,
        attempts: Array.isArray(item.attempts) ? item.attempts.map((attempt) => ({ ...attempt })) : [],
        finalOutcome: item.finalOutcome,
        finalUrl: item.finalUrl || null,
        status: item.status ?? null,
        headers: item.headers && typeof item.headers === "object" ? { ...item.headers } : {},
        contentType: item.contentType || null,
        contentLength: item.contentLength || null,
        byteLength: item.byteLength ?? null,
        bodyLatin1: item.bodyLatin1 || null,
        extractedUpgradeLink: item.extractedUpgradeLink || "",
        parseErrorMessage: item.parseErrorMessage || null,
        requestErrors: Array.isArray(item.requestErrors) ? item.requestErrors.slice() : []
      }))
    };
  }

  async function collectPlatformResult(state, platform) {
    const attempts = [];
    const requestErrors = [];
    const maxAttempts = 1 + Number(CONFIG.desktopUpdateMaxRetries || 0);
    let finalResult = null;

    for (let attemptIndex = 0; attemptIndex < maxAttempts; attemptIndex += 1) {
      const result = await fetchDesktopUpdateAttempt(state.token, state.spotifyAppVersion, platform);
      finalResult = result;
      attempts.push(buildAttemptMetadata(attemptIndex + 1, result));
      if (result.outcome === "request_error" && result.errorMessage) {
        requestErrors.push(result.errorMessage);
      }
      if (result.outcome !== "request_error" || attemptIndex === maxAttempts - 1) {
        break;
      }
    }

    state.retryCountByPlatform[platform.code] = Math.max(0, attempts.length - 1);
    state.desktopUpdateResponses.push(
      buildDesktopUpdateResponseRecord(platform.code, attempts, finalResult, requestErrors)
    );

    if (finalResult.outcome === "success") {
      state.platforms[platform.code] = finalResult.asset;
      return finalResult.outcome;
    }

    if (finalResult.outcome === "parse_error") {
      state.forensicMode = true;
      state.failures.push({
        platform: platform.code,
        kind: "parse_error",
        message: finalResult.parseErrorMessage || `Failed to parse ${platform.code} upgrade response`
      });
      return finalResult.outcome;
    }

    if (finalResult.outcome === "empty_response") {
      state.failures.push({
        platform: platform.code,
        kind: "empty_response",
        message: ERROR_MESSAGES.empty_response
      });
      return finalResult.outcome;
    }

    state.failures.push({
      platform: platform.code,
      kind: "request_error",
      message: finalResult.errorMessage || `Failed to request ${platform.code} update metadata`
    });
    return finalResult.outcome;
  }

  async function collectPlatforms(state) {
    for (const platform of PLATFORMS) {
      const outcome = await collectPlatformResult(state, platform);
      if (!state.forensicMode && outcome !== "success") {
        return { aborted: true };
      }
    }
    return { aborted: false };
  }

  function sendDesktopUpdateParseError(state) {
    sendError(state, "desktop_update_parse_error", {
      phase: "desktop_update_parse_error",
      message: ERROR_MESSAGES.desktop_update_parse_error,
      diagnostics: buildForensicDiagnostics(state),
      rawPayload: buildForensicRawPayload(state)
    });
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

    const collection = await collectPlatforms(state);
    if (state.forensicMode) {
      sendDesktopUpdateParseError(state);
      return;
    }
    if (collection.aborted) {
      return;
    }

    const foundCount = Object.keys(state.platforms).length;
    if (!finalizeDetectedVersions(state)) {
      sendError(state, "inconsistent_target_version", {
        diagnostics: {
          detectedShortVersions: [...new Set(Object.values(state.platforms).map((asset) => asset.shortVersion))],
          detectedFullVersions: [...new Set(Object.values(state.platforms).map((asset) => asset.fullVersion))]
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
