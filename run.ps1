[CmdletBinding()]
param
(
    [Parameter(HelpMessage = 'Latest recommended Spotify version for Windows 10+.')]
    [string]$latest_full = "1.3.0",

    [Parameter(HelpMessage = 'Latest supported Spotify version for Windows 7-8.1')]
    [string]$last_win7_full = "1.2.5.1006.g22820f93",

    [Parameter(HelpMessage = 'Latest supported Spotify version for x86')]
    [string]$last_x86_full = "1.2.53.440.g7b2f582a",


    [Parameter(HelpMessage = 'Force a specific download method. Default is automatic selection.')]
    [Alias('dm')]
    [ValidateSet('curl', 'webclient')]
    [string]$download_method,

    [Parameter(HelpMessage = "Change recommended Spotify version. Example: 1.2.88 or 1.2.88.485.g1012a6e0.")]
    [Alias("v")]
    [string]$version,

    [Parameter(HelpMessage = 'Custom path to Spotify installation directory. Default is %APPDATA%\Spotify.')]
    [string]$SpotifyPath,

    [Parameter(HelpMessage = 'Custom local path to patches.json')]
    [Alias('cp')]
    [string]$CustomPatchesPath,

    [Parameter(HelpMessage = 'Skip pause before exit')]
    [switch]$no_pause,

    [Parameter(HelpMessage = 'Skip Microsoft Defender exclusions')]
    [switch]$defender_exclusions_off,

    [Parameter(HelpMessage = "Use github.io mirror instead of raw.githubusercontent.")]
    [Alias("m")]
    [switch]$mirror,

    [Parameter(HelpMessage = "Developer mode activation.")]
    [Alias("dev")]
    [switch]$devtools,

    [Parameter(HelpMessage = 'Disable podcasts/episodes/audiobooks from homepage.')]
    [switch]$podcasts_off,

    [Parameter(HelpMessage = 'Disable Ad-like sections from homepage')]
    [switch]$adsections_off,

    [Parameter(HelpMessage = 'Disable canvas from homepage')]
    [switch]$canvashome_off,

    [Parameter(HelpMessage = 'Do not disable podcasts/episodes/audiobooks from homepage.')]
    [switch]$podcasts_on,

    [Parameter(HelpMessage = 'Block Spotify automatic updates.')]
    [switch]$block_update_on,

    [Parameter(HelpMessage = 'Do not block Spotify automatic updates.')]
    [switch]$block_update_off,

    [Parameter(HelpMessage = 'Change limit for clearing audio cache.')]
    [Alias('cl')]
    [int]$cache_limit,

    [Parameter(HelpMessage = 'Automatic uninstallation of Spotify MS if it was found.')]
    [switch]$confirm_uninstall_ms_spoti,

    [Parameter(HelpMessage = 'Overwrite outdated or unsupported version of Spotify with the recommended version.')]
    [Alias('sp-over')]
    [switch]$confirm_spoti_recomended_over,

    [Parameter(HelpMessage = 'Uninstall outdated or unsupported version of Spotify and install the recommended version.')]
    [Alias('sp-uninstall')]
    [switch]$confirm_spoti_recomended_uninstall,

    [Parameter(HelpMessage = 'Installation without ad blocking for premium accounts.')]
    [switch]$premium,

    [Parameter(HelpMessage = 'Disable Spotify autostart on Windows boot.')]
    [switch]$DisableStartup,

    [Parameter(HelpMessage = 'Automatic launch of Spotify after installation is complete.')]
    [switch]$start_spoti,

    [Parameter(HelpMessage = 'Experimental features operated by Spotify.')]
    [switch]$exp_spotify,

    [Parameter(HelpMessage = 'Enable top search bar.')]
    [switch]$topsearchbar,

    [Parameter(HelpMessage = 'Enable new fullscreen mode (Experimental)')]
    [switch]$newFullscreenMode,

    [Parameter(HelpMessage = 'disable subfeed filter chips on home.')]
    [switch]$homesub_off,

    [Parameter(HelpMessage = 'Do not hide the icon of collaborations in playlists.')]
    [switch]$hide_col_icon_off,

    [Parameter(HelpMessage = 'Disable new right sidebar.')]
    [switch]$rightsidebar_off,

    [Parameter(HelpMessage = 'it`s killing the heart icon, you`re able to save and choose the destination for any song, playlist, or podcast')]
    [switch]$plus,

    [Parameter(HelpMessage = 'Enable funny progress bar.')]
    [switch]$funnyprogressBar,

    [Parameter(HelpMessage = 'New theme activated (new right and left sidebar, some cover change)')]
    [switch]$new_theme,

    [Parameter(HelpMessage = 'Enable right sidebar coloring to match cover color)')]
    [switch]$rightsidebarcolor,

    [Parameter(HelpMessage = 'Disable native lyrics')]
    [switch]$lyrics_block,

    [Parameter(HelpMessage = 'Do not create desktop shortcut.')]
    [switch]$no_shortcut,

    [Parameter(HelpMessage = 'Disable sending new versions')]
    [switch]$sendversion_off,

    [Parameter(HelpMessage = 'Static color for lyrics.')]
    [ArgumentCompleter({ param($cmd, $param, $wordToComplete)
            [array] $validValues = @('blue', 'blueberry', 'discord', 'drot', 'default', 'forest', 'fresh', 'github', 'lavender', 'orange', 'postlight', 'pumpkin', 'purple', 'radium', 'relish', 'red', 'sandbar', 'spotify', 'spotify#2', 'strawberry', 'turquoise', 'yellow', 'zing', 'pinkle', 'krux', 'royal', 'oceano')
            $validValues -like "*$wordToComplete*"
        })]
    [string]$lyrics_stat,

    [Parameter(HelpMessage = 'Accumulation of track listening history with Goofy.')]
    [string]$urlform_goofy = $null,

    [Parameter(HelpMessage = 'Accumulation of track listening history with Goofy.')]
    [string]$idbox_goofy = $null,

    [Parameter(HelpMessage = 'Error log ru string.')]
    [switch]$err_ru,

    [Parameter(HelpMessage = 'Select the desired language to use for installation. Default is the detected system language.')]
    [Alias('l')]
    [string]$language,

    # Deprecated parameters
    [Parameter(HelpMessage = 'Deprecated, old lyrics are enabled by default')]
    [switch]$old_lyrics
)

# Ignore errors from `Stop-Process`
$PSDefaultParameterValues['Stop-Process:ErrorAction'] = [System.Management.Automation.ActionPreference]::SilentlyContinue

function Format-LanguageCode {

    # Normalizes and confirms support of the selected language.
    [CmdletBinding()]
    [OutputType([string])]
    param
    (
        [string]$LanguageCode
    )

    $supportLanguages = @(
        'be', 'bn', 'cs', 'de', 'el', 'en', 'es', 'fa', 'fi', 'fil', 'fr', 'hi', 'hu',
        'id', 'it', 'ja', 'ka', 'ko', 'lv', 'pl', 'pt', 'ro', 'ru', 'sk', 'sr', 'sr-Latn',
        'sv', 'ta', 'tr', 'uk', 'vi', 'zh', 'zh-TW'
    )

    # Trim the language code down to two letter code.
    switch -Regex ($LanguageCode) {
        '^be' {
            $returnCode = 'be'
            break
        }
        '^bn' {
            $returnCode = 'bn'
            break
        }
        '^cs' {
            $returnCode = 'cs'
            break
        }
        '^de' {
            $returnCode = 'de'
            break
        }
        '^el' {
            $returnCode = 'el'
            break
        }
        '^en' {
            $returnCode = 'en'
            break
        }
        '^es' {
            $returnCode = 'es'
            break
        }
        '^fa' {
            $returnCode = 'fa'
            break
        }
        '^fi$' {
            $returnCode = 'fi'
            break
        }
        '^fil' {
            $returnCode = 'fil'
            break
        }
        '^fr' {
            $returnCode = 'fr'
            break
        }
        '^hi' {
            $returnCode = 'hi'
            break
        }
        '^hu' {
            $returnCode = 'hu'
            break
        }
        '^id' {
            $returnCode = 'id'
            break
        }
        '^it' {
            $returnCode = 'it'
            break
        }
        '^ja' {
            $returnCode = 'ja'
            break
        }
        '^ka' {
            $returnCode = 'ka'
            break
        }
        '^ko' {
            $returnCode = 'ko'
            break
        }
        '^lv' {
            $returnCode = 'lv'
            break
        }
        '^pl' {
            $returnCode = 'pl'
            break
        }
        '^pt' {
            $returnCode = 'pt'
            break
        }
        '^ro' {
            $returnCode = 'ro'
            break
        }
        '^(ru|py)' {
            $returnCode = 'ru'
            break
        }
        '^sk' {
            $returnCode = 'sk'
            break
        }
        '^(sr|sr-Cyrl)$' {
            $returnCode = 'sr'
            break
        }
        '^sr-Latn' {
            $returnCode = 'sr-Latn'
            break
        }
        '^sv' {
            $returnCode = 'sv'
            break
        }
        '^ta' {
            $returnCode = 'ta'
            break
        }
        '^tr' {
            $returnCode = 'tr'
            break
        }
        '^uk' {
            $returnCode = 'uk'
            break
        }
        '^vi' {
            $returnCode = 'vi'
            break
        }
        '^(zh|zh-CN)$' {
            $returnCode = 'zh'
            break
        }
        '^zh-TW' {
            $returnCode = 'zh-TW'
            break
        }
        Default {
            $returnCode = $PSUICulture
            $long_code = $true
            break
        }
    }

    # Checking the long language code
    if ($long_code -and $returnCode -NotIn $supportLanguages) {
        if ($returnCode -match '-') {
            $intermediateCode = $returnCode.Substring(0, $returnCode.LastIndexOf('-'))

            if ($intermediateCode -in $supportLanguages) {
                $returnCode = $intermediateCode
            }
            else {
                $returnCode = $returnCode -split "-" | Select-Object -First 1
            }
        }
    }

    if ($returnCode -NotIn $supportLanguages) {

        $returnCode = 'en'
    }
    return $returnCode
}

$spotifyRoamingDirectory = Join-Path $env:APPDATA 'Spotify'
$spotifyDirectory = $spotifyRoamingDirectory
$spotifyDirectory2 = Join-Path $env:LOCALAPPDATA 'Spotify'

# Использовать кастомный путь если указан параметр -SpotifyPath
if ($SpotifyPath) {
    $spotifyDirectory = $SpotifyPath
}
$spotifyExecutable = Join-Path $spotifyDirectory 'Spotify.exe'
$spotifyUninstaller = Join-Path $spotifyDirectory 'uninstall.exe'
$spotifyDll = Join-Path $spotifyDirectory 'Spotify.dll'
$chrome_elf = Join-Path $spotifyDirectory 'chrome_elf.dll'
$exe_bak = Join-Path $spotifyDirectory 'Spotify.bak'
$dll_bak = Join-Path $spotifyDirectory 'Spotify.dll.bak'
$chrome_elf_bak = Join-Path $spotifyDirectory 'chrome_elf.dll.bak'
$spotifyUninstall = Join-Path ([System.IO.Path]::GetTempPath()) 'SpotifyUninstall.exe'
$start_menu = Join-Path $env:APPDATA 'Microsoft\Windows\Start Menu\Programs\Spotify.lnk'
$xpui_spa_patch = Join-Path (Join-Path $spotifyDirectory 'Apps') 'xpui.spa'

$upgrade_client = $false
$downgrading = $false
$ru = $false
$podcast_off = $false
$css = $null
$calltype = $null
$tempDirectory = $null
$script:curlSupportsFailWithBody = $null

# Check version Powershell
$psv = $PSVersionTable.PSVersion.major
if ($psv -ge 7) {
    Import-Module Appx -UseWindowsPowerShell -WarningAction:SilentlyContinue
}

# add Tls12
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12;

function Stop-Script {
    param(
        [string]$Message = ($lang).StopScript
    )

    Write-Host $Message

    if (-not $no_pause) {
        switch ($Host.Name) {
            "Windows PowerShell ISE Host" {
                pause
                break
            }
            default {
                Write-Host ($lang).PressAnyKey
                [void][System.Console]::ReadKey($true)
                break
            }
        }
    }
    Exit
}

function Stop-BrokenSpotifyFiles {
    param(
        [string]$Details
    )

    if ($Details) { Write-Warning $Details }
    Write-Host ($lang).Error -ForegroundColor Red
    Write-Host ($lang).FileLocBroken
    Stop-Script
}

function Get-Link {
    param (
        [Alias("e")]
        [string]$endlink,
        [string]$Owner = "SpotX-Official",
        [string]$Repository = "SpotX"
    )

    $pagesOwner = $Owner.ToLowerInvariant()
    switch ($mirror) {
        $true { return "https://$pagesOwner.github.io/$Repository" + $endlink }
        default { return "https://raw.githubusercontent.com/$Owner/$Repository/main" + $endlink }
    }
}

function CallLang($clg) {

    $ProgressPreference = 'SilentlyContinue'

    try {
        $response = (iwr -Uri (Get-Link -e "/scripts/installer-lang/$clg.ps1") -UseBasicParsing).Content
        if ($mirror) { $response = [System.Text.Encoding]::UTF8.GetString($response) }
        Invoke-Expression $response
    }
    catch {
        Write-Host "Error loading $clg language"
        if (-not $no_pause) { Pause }
        Exit
    }
}

# Set language code for script.
$langCode = Format-LanguageCode -LanguageCode $Language

$lang = CallLang -clg $langCode

Write-Host ($lang).Welcome
Write-Host

if ($old_lyrics) {
    Write-Warning @"
-old_lyrics is deprecated
    Old lyrics are enabled by default
    Remove this parameter from your command line
"@
    Write-Host
}

# Check version Windows
$os = Get-CimInstance -ClassName "Win32_OperatingSystem" -ErrorAction SilentlyContinue
if ($os) {
    $osCaption = $os.Caption
}
else {
    $osCaption = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name ProductName).ProductName
}
$pattern = "\bWindows (7|8(\.1)?|10|11|12)\b"
$reg = [regex]::Matches($osCaption, $pattern)
$win_os = $reg.Value

$win12 = $win_os -match "\windows 12\b"
$win11 = $win_os -match "\windows 11\b"
$win10 = $win_os -match "\windows 10\b"
$win8_1 = $win_os -match "\windows 8.1\b"
$win8 = $win_os -match "\windows 8\b"
$win7 = $win_os -match "\windows 7\b"

function Get-SystemArchitecture {
    $archNames = @($env:PROCESSOR_ARCHITEW6432, $env:PROCESSOR_ARCHITECTURE) | Where-Object { $_ }

    foreach ($archName in $archNames) {
        switch ($archName.ToUpperInvariant()) {
            'ARM64' { return 'arm64' }
            'AMD64' { return 'x64' }
            'X86' { return 'x86' }
        }
    }

    return 'x64'
}

function Get-SpotifyVersionNumber {
    param(
        [Parameter(Mandatory = $true)]
        [string]$SpotifyVersion
    )

    return [Version]($SpotifyVersion -replace '\.g[0-9a-f]{8}$', '')
}

function Get-SpotifyInstallerArchitecture {
    param(
        [Parameter(Mandatory = $true)]
        [string]$SystemArchitecture,
        [Parameter(Mandatory = $true)]
        [version]$SpotifyVersion,
        [Parameter(Mandatory = $true)]
        [version]$LastX86SupportedVersion
    )

    switch ($SystemArchitecture) {
        'arm64' { return 'arm64' }
        'x64' {
            if ($SpotifyVersion -le $LastX86SupportedVersion) {
                return 'x86'
            }

            return 'x64'
        }
        'x86' {
            if ($SpotifyVersion -le $LastX86SupportedVersion) {
                return 'x86'
            }

            throw "Version $SpotifyVersion is not supported on x86 systems"
        }
        default { return 'x64' }
    }
}

function Test-SpotifyVersionRequiresResolution {
    param(
        [Parameter(Mandatory = $true)]
        [string]$SpotifyVersion
    )

    return $SpotifyVersion -match '^\d+\.\d+\.\d+(?:\.\d+)?$'
}

function Get-SpotifyVersionsManifest {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Url
    )

    $previousProgressPreference = $ProgressPreference
    try {
        $ProgressPreference = 'SilentlyContinue'
        return Invoke-RestMethod -Uri $Url -UseBasicParsing -TimeoutSec 15
    }
    catch {
        throw "Failed to load Spotify versions manifest`nURL: $Url`n$($_.Exception.Message)"
    }
    finally {
        $ProgressPreference = $previousProgressPreference
    }
}

function Resolve-SpotifyInstallerVersionFromManifest {
    param(
        [Parameter(Mandatory = $true)]
        [object]$VersionsManifest,
        [Parameter(Mandatory = $true)]
        [string]$SpotifyVersion,
        [Parameter(Mandatory = $true)]
        [string]$Architecture
    )

    $versions = @($VersionsManifest.PSObject.Properties)

    if ($SpotifyVersion -match '^\d+\.\d+\.\d+$') {
        $versionPrefix = "$SpotifyVersion."
        $selectedVersion = $versions |
        Where-Object { $_.Name.StartsWith($versionPrefix, [System.StringComparison]::Ordinal) } |
        Sort-Object { [version]$_.Name } -Descending |
        Select-Object -First 1
    }
    else {
        $selectedVersion = $versions | Where-Object { $_.Name -eq $SpotifyVersion } | Select-Object -First 1
    }

    if (!$selectedVersion) {
        throw "Spotify version $SpotifyVersion was not found in versions manifest"
    }

    $entry = $selectedVersion.Value
    $fullVersion = [string]$entry.fullversion
    if ($fullVersion -notmatch '^\d+\.\d+\.\d+\.\d+\.g[0-9a-f]{8}$') {
        throw "Spotify version $($selectedVersion.Name) has invalid fullversion in versions manifest"
    }

    $windowsAssets = $entry.win
    $architectureAsset = if ($windowsAssets) {
        $windowsAssets.PSObject.Properties[$Architecture]
    }
    else {
        $null
    }

    if (!$architectureAsset) {
        throw "Spotify version $($selectedVersion.Name) does not have Windows $Architecture asset in versions manifest"
    }

    $assetUrl = [string]$architectureAsset.Value.url
    if (!$assetUrl) {
        throw "Spotify version $($selectedVersion.Name) does not have Windows $Architecture URL in versions manifest"
    }

    $expectedAssetName = "spotify_installer-$fullVersion-$Architecture.exe"
    try {
        $assetFileName = [System.IO.Path]::GetFileName(([Uri]$assetUrl).AbsolutePath)
    }
    catch {
        $assetFileName = ''
    }

    if ($assetFileName -ne $expectedAssetName) {
        throw "Spotify version $($selectedVersion.Name) has unexpected Windows $Architecture asset in versions manifest"
    }

    return $fullVersion
}

$spotifyDownloadBaseUrl = "https://loadspot.amd64fox1.workers.dev/download"
$spotifyTemporaryDownloadBaseUrl = "https://loadspot.amd64fox1.workers.dev/temporary-download"
$spotifyTemporaryDownloadVersion = "1.2.86.502.g8cd7fb22"
$spotifyVersionsManifestUrl = Get-Link -e "/table/versions.json" -Owner "LoaderSpot" -Repository "table"
$systemArchitecture = Get-SystemArchitecture

$match_v = "^(?<version>\d+\.\d+\.\d+(?:\.\d+(?:\.g[0-9a-f]{8})?)?)(?:-\d+)?$"
$versionIsSupported = $false
if ($version) {
    if ($version -match $match_v) {
        $onlineFull = $Matches.version
        $versionIsSupported = $true
    }
    else {
        Write-Warning "Invalid $($version) format. Example: 1.2.88 or 1.2.88.485.g1012a6e0 (legacy -4064 suffix is optional)"
        Write-Host
    }
}

$old_os = $win7 -or $win8 -or $win8_1

$last_win7 = Get-SpotifyVersionNumber -SpotifyVersion $last_win7_full

$last_x86 = Get-SpotifyVersionNumber -SpotifyVersion $last_x86_full

if (-not $versionIsSupported) {
    if ($old_os) {
        $onlineFull = $last_win7_full
    }
    elseif ($systemArchitecture -eq 'x86') {
        $onlineFull = $last_x86_full
    }
    else {
        # latest tested version for Win 10-12
        $onlineFull = $latest_full
    }
}
else {
    $requestedOnlineVersion = Get-SpotifyVersionNumber -SpotifyVersion $onlineFull

    if ($old_os) {
        if ($requestedOnlineVersion -gt $last_win7) {

            Write-Warning ("Version {0} is only supported on Windows 10 and above" -f $requestedOnlineVersion)
            Write-Warning ("The recommended version has been automatically changed to {0}, the latest supported version for Windows 7-8.1" -f $last_win7)
            Write-Host
            $onlineFull = $last_win7_full
            $requestedOnlineVersion = $last_win7
        }
    }

    if ($systemArchitecture -eq 'x86' -and $requestedOnlineVersion -gt $last_x86) {
        Write-Warning ("Version {0} is not supported on 32-bit (x86) Windows systems" -f $requestedOnlineVersion)
        Write-Warning ("The recommended version has been automatically changed to {0}, the latest supported version for x86 systems" -f $last_x86)
        Write-Host
        $onlineFull = $last_x86_full
        $requestedOnlineVersion = $last_x86
    }
}

$onlineDownloadVersion = $onlineFull

if (Test-SpotifyVersionRequiresResolution -SpotifyVersion $onlineFull) {
    try {
        $onlineInstallerArchitecture = Get-SpotifyInstallerArchitecture `
            -SystemArchitecture $systemArchitecture `
            -SpotifyVersion (Get-SpotifyVersionNumber -SpotifyVersion $onlineFull) `
            -LastX86SupportedVersion $last_x86

        $spotifyVersionsManifest = Get-SpotifyVersionsManifest -Url $spotifyVersionsManifestUrl

        $onlineFull = Resolve-SpotifyInstallerVersionFromManifest `
            -VersionsManifest $spotifyVersionsManifest `
            -SpotifyVersion $onlineFull `
            -Architecture $onlineInstallerArchitecture
    }
    catch {
        Write-Warning $_.Exception.Message
        Stop-Script
    }
}

$online = (Get-SpotifyVersionNumber -SpotifyVersion $onlineFull).ToString()


function Get {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Url,
        [int]$MaxRetries = 3,
        [int]$RetrySeconds = 3,
        [string]$OutputPath
    )

    $params = @{
        Uri        = $Url
        TimeoutSec = 15
    }

    if ($OutputPath) {
        $params['OutFile'] = $OutputPath
    }

    for ($i = 0; $i -lt $MaxRetries; $i++) {
        try {
            $response = Invoke-RestMethod @params
            return $response
        }
        catch {
            Write-Warning "Attempt $($i+1) of $MaxRetries failed: $_"
            if ($i -lt $MaxRetries - 1) {
                Start-Sleep -Seconds $RetrySeconds
            }
        }
    }

    Write-Host
    Write-Host "ERROR: " -ForegroundColor Red -NoNewline; Write-Host "Failed to retrieve data from $Url" -ForegroundColor White
    Write-Host
    return $null
}

function Get-PatchesJson {
    param (
        [string]$LocalPath
    )

    if ($LocalPath) {
        try {
            $resolvedPath = Resolve-Path -LiteralPath $LocalPath -ErrorAction Stop | Select-Object -ExpandProperty Path

            if (-not (Test-Path -LiteralPath $resolvedPath -PathType Leaf)) {
                throw "File not found: $resolvedPath"
            }

            Write-Host ("Using a local file for patches: {0}" -f $resolvedPath)
            Write-Host

            $jsonContent = [System.IO.File]::ReadAllText($resolvedPath, [System.Text.Encoding]::UTF8)
            return $jsonContent | ConvertFrom-Json -ErrorAction Stop
        }
        catch {
            Write-Host
            Write-Host "Failed to load local patches.json" -ForegroundColor Red
            Write-Host $_.Exception.Message -ForegroundColor Red
            Write-Host
            return $null
        }
    }

    return Get -Url (Get-Link -e "/patches/patches.json") -RetrySeconds 5
}


function incorrectValue {

    Write-Host ($lang).Incorrect"" -ForegroundColor Red -NoNewline
    Write-Host ($lang).Incorrect2"" -NoNewline
    Start-Sleep -Milliseconds 1000
    Write-Host "3" -NoNewline
    Start-Sleep -Milliseconds 1000
    Write-Host " 2" -NoNewline
    Start-Sleep -Milliseconds 1000
    Write-Host " 1"
    Start-Sleep -Milliseconds 1000
    Clear-Host
}

function Unlock-Folder {
    $blockFileUpdate = Join-Path $env:LOCALAPPDATA 'Spotify\Update'

    if (Test-Path $blockFileUpdate -PathType Container) {
        $folderUpdateAccess = Get-Acl $blockFileUpdate
        $hasDenyAccessRule = $false

        foreach ($accessRule in $folderUpdateAccess.Access) {
            if ($accessRule.AccessControlType -eq 'Deny') {
                $hasDenyAccessRule = $true
                $folderUpdateAccess.RemoveAccessRule($accessRule)
            }
        }

        if ($hasDenyAccessRule) {
            Set-Acl $blockFileUpdate $folderUpdateAccess
        }
    }
}

function Invoke-SpotifyUninstall {
    param(
        [Parameter(Mandatory = $true)]
        [string]$InstalledVersion
    )

    $installedVersionObject = [version]$InstalledVersion

    if ($installedVersionObject -ge [version]'1.2.84.476') {
        if (-not (Test-Path -LiteralPath $spotifyUninstaller)) {
            Write-Host "ERROR: " -ForegroundColor Red -NoNewline
            Write-Host ("Spotify uninstall.exe was not found for version {0}. Aborting reinstall" -f $InstalledVersion) -ForegroundColor White
            Stop-Script
        }

        try {
            $launcher = Start-Process -FilePath $spotifyUninstaller `
                -ArgumentList '/silent' `
                -PassThru `
                -WindowStyle Hidden `
                -ErrorAction Stop

            $launcher.WaitForExit()

            $pollIntervalMs = 200
            $pollMaxMs = 10000
            $elapsedMs = 0

            while ($elapsedMs -lt $pollMaxMs) {
                $uninstallProcess = Get-Process -Name SpotifyUninstall -ErrorAction SilentlyContinue | Select-Object -First 1
                if ($uninstallProcess) {
                    Wait-Process -Name SpotifyUninstall -ErrorAction SilentlyContinue
                    break
                }

                if (-not (Test-Path -LiteralPath $spotifyExecutable) -or -not (Test-Path -LiteralPath $spotifyDirectory)) {
                    break
                }

                Start-Sleep -Milliseconds $pollIntervalMs
                $elapsedMs += $pollIntervalMs
            }
        }
        catch {
            Write-Host "ERROR: " -ForegroundColor Red -NoNewline
            Write-Host ("Failed to launch Spotify uninstaller for version {0}. {1}" -f $InstalledVersion, $_.Exception.Message) -ForegroundColor White
            Stop-Script
        }
    }
    else {
        cmd /c $spotifyExecutable /UNINSTALL /SILENT
        Wait-Process -Name SpotifyUninstall
    }

    Start-Sleep -Milliseconds 200

    if (Test-Path -LiteralPath $spotifyDirectory) { Remove-Item -Recurse -Force -LiteralPath $spotifyDirectory -ErrorAction SilentlyContinue }
    if (Test-Path -LiteralPath $spotifyDirectory2) { Remove-Item -Recurse -Force -LiteralPath $spotifyDirectory2 -ErrorAction SilentlyContinue }
    if (Test-Path -LiteralPath $spotifyUninstall) { Remove-Item -Recurse -Force -LiteralPath $spotifyUninstall -ErrorAction SilentlyContinue }

    $spotifyRemoved = (-not (Test-Path -LiteralPath $spotifyExecutable)) -or (-not (Test-Path -LiteralPath $spotifyDirectory))
    if (-not $spotifyRemoved) {
        Write-Host "ERROR: " -ForegroundColor Red -NoNewline
        Write-Host ("Spotify uninstall failed for version {0}. Spotify is still installed" -f $InstalledVersion) -ForegroundColor White
        Stop-Script
    }
}

function Mod-F {
    param(
        [string] $template,
        [object[]] $arguments
    )

    $result = $template
    for ($i = 0; $i -lt $arguments.Length; $i++) {
        $placeholder = "{${i}}"
        $value = $arguments[$i]
        $result = $result -replace [regex]::Escape($placeholder), $value
    }

    return $result
}

function Test-CurlAvailability {
    try {
        if (curl.exe -V) {
            return $true
        }
    }
    catch { }

    return $false
}

function Resolve-SpotifyDownloadMethod {
    param(
        [string]$ForcedMethod
    )

    if ($ForcedMethod) {
        switch ($ForcedMethod) {
            'curl' {
                if (Test-CurlAvailability) {
                    return 'curl'
                }

                throw "Forced download method 'curl' is not available on this system"
            }
            'webclient' {
                return 'webclient'
            }
        }
    }

    if (Test-CurlAvailability) {
        return 'curl'
    }

    return 'webclient'
}

function Format-DownloadSizeMb {
    param(
        [long]$Bytes
    )

    return ('{0:N2} MB' -f ($Bytes / 1MB))
}

function Convert-CommandOutputToString {
    param(
        [object[]]$Output
    )

    if ($null -eq $Output) {
        return ''
    }

    $lines = foreach ($item in @($Output)) {
        if ($null -eq $item) {
            continue
        }

        if ($item -is [System.Management.Automation.ErrorRecord]) {
            $item.Exception.Message.TrimEnd()
            continue
        }

        $item.ToString().TrimEnd()
    }

    return (@($lines) -join [Environment]::NewLine).Trim()
}

function Get-CurlHttpStatus {
    param(
        [string]$Output
    )

    $match = [regex]::Match([string]$Output, 'HTTP_STATUS:(\d{3})')
    if ($match.Success) {
        return $match.Groups[1].Value
    }

    return ''
}

function Get-CurlDiagnosticDetails {
    param(
        [string]$Output
    )

    if ([string]::IsNullOrWhiteSpace($Output)) {
        return ''
    }

    $cleanLines = foreach ($line in ($Output -split '\r?\n')) {
        $currentLine = [string]$line

        if ([string]::IsNullOrWhiteSpace($currentLine)) {
            continue
        }

        if ($currentLine -match '^\s*HTTP_STATUS:\d{3}\s*$') {
            continue
        }

        if ($currentLine -match '^\s*[#O=\-]+\s*$') {
            continue
        }

        $curlMessageIndex = $currentLine.IndexOf('curl:')
        if ($curlMessageIndex -gt 0) {
            $currentLine = $currentLine.Substring($curlMessageIndex)
        }

        $currentLine = $currentLine.Trim()

        if ($currentLine) {
            $currentLine
        }
    }

    return (@($cleanLines) -join [Environment]::NewLine).Trim()
}

function Format-CurlFailureMessage {
    param(
        [string]$Url,
        [string]$Stage,
        [int]$ExitCode,
        [string]$HttpStatus,
        [string]$Details,
        [string]$ResponseText
    )

    $lines = @(
        "curl $Stage failed",
        "URL: $Url"
    )

    if ($ExitCode -ne 0) {
        $lines += "Exit code: $ExitCode"
    }

    if ($HttpStatus) {
        $lines += "HTTP status: $HttpStatus"
    }

    if ($Details) {
        $lines += "Details: $Details"
    }

    if ($ResponseText) {
        $lines += "Server response: $ResponseText"
    }

    return ($lines -join [Environment]::NewLine)
}

function New-DownloadFailureException {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Message,
        [string]$DownloadMethod,
        [string]$FailureKind,
        [string]$HttpStatus,
        [int]$ExitCode = 0,
        [System.Exception]$InnerException
    )

    if ($InnerException) {
        $exception = New-Object System.Exception($Message, $InnerException)
    }
    else {
        $exception = New-Object System.Exception($Message)
    }

    if ($DownloadMethod) {
        $exception.Data['DownloadMethod'] = $DownloadMethod
    }
    if ($FailureKind) {
        $exception.Data['FailureKind'] = $FailureKind
    }
    if ($HttpStatus) {
        $exception.Data['HttpStatus'] = $HttpStatus
    }
    if ($ExitCode -ne 0) {
        $exception.Data['ExitCode'] = $ExitCode
    }

    return $exception
}

function Write-DownloadFailureDetails {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Method,
        [System.Exception]$Exception,
        [string]$Title
    )

    if ($Title) {
        Write-Host $Title -ForegroundColor Red
    }

    Write-Host "Download method: $Method" -ForegroundColor Yellow
    if ($Exception) {
        Write-Host $Exception.Message -ForegroundColor Yellow
    }
    Write-Host
}

function Invoke-DownloadMethodWithRetries {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Url,
        [Parameter(Mandatory = $true)]
        [string]$DestinationPath,
        [Parameter(Mandatory = $true)]
        [System.Net.WebClient]$WebClient,
        [Parameter(Mandatory = $true)]
        [ValidateSet('curl', 'webclient')]
        [string]$DownloadMethod,
        [Parameter(Mandatory = $true)]
        [string]$FileName
    )

    $lastError = $null

    for ($attempt = 1; $attempt -le 2; $attempt++) {
        try {
            if ($attempt -gt 1) {
                Write-Host ("Download method: {0} (attempt {1}/2)" -f $DownloadMethod, $attempt) -ForegroundColor Yellow
            }

            Invoke-SpotifyDownloadAttempt `
                -Url $Url `
                -DestinationPath $DestinationPath `
                -WebClient $WebClient `
                -DownloadMethod $DownloadMethod

            return [PSCustomObject]@{
                Success = $true
                Error   = $null
                Method  = $DownloadMethod
            }
        }
        catch {
            $lastError = $_.Exception
            Write-Host

            if ($attempt -eq 1) {
                Write-Host ($lang).Download $FileName -ForegroundColor RED
                Write-DownloadFailureDetails -Method $DownloadMethod -Exception $lastError
                Write-Host ($lang).Download2`n
                Start-Sleep -Milliseconds 5000
            }
        }
    }

    return [PSCustomObject]@{
        Success = $false
        Error   = $lastError
        Method  = $DownloadMethod
    }
}

function Invoke-WebClientDownloadWithProgress {
    param(
        [Parameter(Mandatory = $true)]
        [System.Net.WebClient]$WebClient,
        [Parameter(Mandatory = $true)]
        [string]$Url,
        [Parameter(Mandatory = $true)]
        [string]$DestinationPath
    )

    $fileName = Split-Path -Path $DestinationPath -Leaf
    $previousProgressPreference = $ProgressPreference
    $responseStream = $null
    $fileStream = $null
    $stopwatch = $null

    try {
        $ProgressPreference = 'Continue'
        $responseStream = $WebClient.OpenRead($Url)

        if ($null -eq $responseStream) {
            throw "Failed to open response stream for $Url"
        }

        $totalBytes = 0L
        $contentLength = $WebClient.ResponseHeaders['Content-Length']
        if ($contentLength) {
            $null = [long]::TryParse($contentLength, [ref]$totalBytes)
        }

        $fileStream = [System.IO.File]::Open($DestinationPath, [System.IO.FileMode]::Create, [System.IO.FileAccess]::Write, [System.IO.FileShare]::None)

        $buffer = New-Object byte[] 262144
        $bytesReceived = 0L
        $progressUpdateIntervalMs = 200
        $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
        $lastProgressUpdateMs = - $progressUpdateIntervalMs

        while (($bytesRead = $responseStream.Read($buffer, 0, $buffer.Length)) -gt 0) {
            $fileStream.Write($buffer, 0, $bytesRead)
            $bytesReceived += $bytesRead

            if (($stopwatch.ElapsedMilliseconds - $lastProgressUpdateMs) -ge $progressUpdateIntervalMs) {
                if ($totalBytes -gt 0) {
                    $percentComplete = [Math]::Min([int][Math]::Floor(($bytesReceived / $totalBytes) * 100), 100)
                    $status = "{0} / {1} ({2}%)" -f (Format-DownloadSizeMb -Bytes $bytesReceived), (Format-DownloadSizeMb -Bytes $totalBytes), $percentComplete
                    Write-Progress -Activity "Downloading $fileName" -Status $status -PercentComplete $percentComplete
                }
                else {
                    $status = "{0} downloaded" -f (Format-DownloadSizeMb -Bytes $bytesReceived)
                    Write-Progress -Activity "Downloading $fileName" -Status $status -PercentComplete 0
                }

                $lastProgressUpdateMs = $stopwatch.ElapsedMilliseconds
            }
        }

        if ($totalBytes -gt 0) {
            $completedStatus = "{0} / {1} (100%)" -f (Format-DownloadSizeMb -Bytes $bytesReceived), (Format-DownloadSizeMb -Bytes $totalBytes)
            Write-Progress -Activity "Downloading $fileName" -Status $completedStatus -PercentComplete 100
        }

        Write-Progress -Activity "Downloading $fileName" -Completed
    }
    finally {
        if ($null -ne $stopwatch) {
            $stopwatch.Stop()
        }
        if ($null -ne $fileStream) {
            $fileStream.Dispose()
        }
        if ($null -ne $responseStream) {
            $responseStream.Dispose()
        }

        Write-Progress -Activity "Downloading $fileName" -Completed
        $ProgressPreference = $previousProgressPreference
    }
}

function Invoke-SpotifyDownloadAttempt {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Url,
        [Parameter(Mandatory = $true)]
        [string]$DestinationPath,
        [Parameter(Mandatory = $true)]
        [System.Net.WebClient]$WebClient,
        [Parameter(Mandatory = $true)]
        [ValidateSet('curl', 'webclient')]
        [string]$DownloadMethod
    )

    switch ($DownloadMethod) {
        'curl' {
            if (Test-Path -LiteralPath $DestinationPath) {
                Remove-Item -LiteralPath $DestinationPath -Force -ErrorAction SilentlyContinue
            }

            if ($null -eq $script:curlSupportsFailWithBody) {
                try {
                    $helpOutput = curl.exe --help all 2>$null
                    $script:curlSupportsFailWithBody = [bool]($helpOutput -match '--fail-with-body')
                }
                catch {
                    $script:curlSupportsFailWithBody = $false
                }
            }

            $curlFailOption = if ($script:curlSupportsFailWithBody) { '--fail-with-body' } else { '--fail' }
            $curlOutput = & curl.exe `
                -q `
                -L `
                -k `
                $curlFailOption `
                --connect-timeout 15 `
                --ssl-no-revoke `
                --progress-bar `
                -o $DestinationPath `
                -w "`nHTTP_STATUS:%{http_code}`n" `
                $Url
            $curlExitCode = $LASTEXITCODE

            $curlOutputText = Convert-CommandOutputToString -Output $curlOutput
            $httpStatus = Get-CurlHttpStatus -Output $curlOutputText
            $curlDetails = Get-CurlDiagnosticDetails -Output $curlOutputText
            $responseText = ''

            if ([string]::IsNullOrWhiteSpace($curlDetails)) {
                $curlDetails = "curl exited with code $curlExitCode"
            }

            if ($httpStatus) {
                try {
                    if (Test-Path -LiteralPath $DestinationPath) {
                        $responseFile = Get-Item -LiteralPath $DestinationPath -ErrorAction Stop
                        if ($responseFile.Length -gt 0) {
                            $bytesToRead = [Math]::Min([int]$responseFile.Length, 4096)
                            $stream = [System.IO.File]::OpenRead($DestinationPath)
                            try {
                                $buffer = New-Object byte[] $bytesToRead
                                $bytesRead = $stream.Read($buffer, 0, $buffer.Length)
                            }
                            finally {
                                $stream.Dispose()
                            }

                            if ($bytesRead -gt 0) {
                                $responseText = [System.Text.Encoding]::UTF8.GetString($buffer, 0, $bytesRead)
                                $responseText = $responseText -replace "[`0-\b\v\f\x0E-\x1F]", " "
                                $responseText = ($responseText -replace '\s+', ' ').Trim()
                            }
                        }
                    }
                }
                catch {
                    $responseText = ''
                }
            }

            $curlFailureKind = if ($httpStatus) { 'http' } else { 'network' }

            if ($curlExitCode -ne 0) {
                $message = Format-CurlFailureMessage -Url $Url -Stage 'download request' -ExitCode $curlExitCode -HttpStatus $httpStatus -Details $curlDetails -ResponseText $responseText
                throw (New-DownloadFailureException -Message $message -DownloadMethod 'curl' -FailureKind $curlFailureKind -HttpStatus $httpStatus -ExitCode $curlExitCode)
            }

            if ($httpStatus -ne '200') {
                $message = Format-CurlFailureMessage -Url $Url -Stage 'download request' -ExitCode $curlExitCode -HttpStatus $httpStatus -Details $curlDetails -ResponseText $responseText
                throw (New-DownloadFailureException -Message $message -DownloadMethod 'curl' -FailureKind 'http' -HttpStatus $httpStatus -ExitCode $curlExitCode)
            }

            if (!(Test-Path -LiteralPath $DestinationPath)) {
                throw "curl download failed`nURL: $Url`nDestination file was not created: $DestinationPath"
            }

            $downloadedFile = Get-Item -LiteralPath $DestinationPath -ErrorAction SilentlyContinue
            if ($null -eq $downloadedFile -or $downloadedFile.Length -le 0) {
                throw "curl download failed`nURL: $Url`nDownloaded file is empty: $DestinationPath"
            }

            return
        }
        'webclient' {
            try {
                Invoke-WebClientDownloadWithProgress -WebClient $WebClient -Url $Url -DestinationPath $DestinationPath
            }
            catch {
                $webException = $_.Exception
                $httpStatus = ''
                $details = $webException.Message
                $failureKind = 'network'

                if ($webException -is [System.Net.WebException]) {
                    $details = "WebException status: $($webException.Status)"

                    $httpResponse = $webException.Response -as [System.Net.HttpWebResponse]
                    if ($httpResponse) {
                        $httpStatus = [string][int]$httpResponse.StatusCode
                        $statusDescription = [string]$httpResponse.StatusDescription
                        $failureKind = 'http'
                        if ([string]::IsNullOrWhiteSpace($statusDescription)) {
                            $details = $webException.Message
                        }
                        else {
                            $details = $statusDescription
                        }
                    }
                    elseif ($webException.Message) {
                        $details = "WebException status: $($webException.Status)`n$($webException.Message)"
                    }
                }

                $lines = @(
                    'webclient download request failed',
                    "URL: $Url"
                )

                if ($httpStatus) {
                    $lines += "HTTP status: $httpStatus"
                }

                if ($details) {
                    $lines += "Details: $details"
                }

                $message = $lines -join [Environment]::NewLine
                throw (New-DownloadFailureException -Message $message -DownloadMethod 'webclient' -FailureKind $failureKind -HttpStatus $httpStatus -InnerException $webException)
            }

            return
        }
    }
}

function downloadSp([string]$DownloadFolder) {

    $webClient = New-Object -TypeName System.Net.WebClient

    $spotifyVersion = Get-SpotifyVersionNumber -SpotifyVersion $onlineFull
    $downloadVersion = if ($onlineDownloadVersion) { $onlineDownloadVersion } else { $onlineFull }
    $arch = Get-SpotifyInstallerArchitecture `
        -SystemArchitecture $systemArchitecture `
        -SpotifyVersion $spotifyVersion `
        -LastX86SupportedVersion $last_x86

    $downloadBaseUrl = $spotifyDownloadBaseUrl
    if ($downloadVersion -eq $spotifyTemporaryDownloadVersion -and $arch -eq 'x64') {
        $downloadBaseUrl = $spotifyTemporaryDownloadBaseUrl
    }

    $web_Url = "$downloadBaseUrl/spotify_installer-$downloadVersion-$arch.exe"
    $local_Url = Join-Path $DownloadFolder 'SpotifySetup.exe'
    $web_name_file = "SpotifySetup.exe"
    try {
        $selectedDownloadMethod = Resolve-SpotifyDownloadMethod -ForcedMethod $download_method
    }
    catch {
        Write-Warning $_.Exception.Message
        Stop-Script
    }

    $lastDownloadError = $null
    $lastDownloadMethod = $selectedDownloadMethod

    if ($selectedDownloadMethod -eq 'curl') {
        $curlResult = Invoke-DownloadMethodWithRetries `
            -Url $web_Url `
            -DestinationPath $local_Url `
            -WebClient $webClient `
            -DownloadMethod 'curl' `
            -FileName $web_name_file

        if ($curlResult.Success) {
            return
        }

        $lastDownloadError = $curlResult.Error
        $lastDownloadMethod = $curlResult.Method

        Write-DownloadFailureDetails -Method 'curl' -Exception $lastDownloadError -Title 'Curl download failed again'

        $httpStatus = if ($lastDownloadError) { [string]$lastDownloadError.Data['HttpStatus'] } else { '' }
        $shouldUseWebClientFallback = $httpStatus -ne '429'
        if ($shouldUseWebClientFallback) {
            Write-Host "Switching to WebClient fallback..." -ForegroundColor Yellow
            Write-Host

            if (Test-Path -LiteralPath $local_Url) {
                Remove-Item -LiteralPath $local_Url -Force -ErrorAction SilentlyContinue
            }

            try {
                $lastDownloadMethod = 'webclient'
                Write-Host "Download method: webclient (fallback)" -ForegroundColor Yellow
                Invoke-SpotifyDownloadAttempt `
                    -Url $web_Url `
                    -DestinationPath $local_Url `
                    -WebClient $webClient `
                    -DownloadMethod 'webclient'
                return
            }
            catch {
                $lastDownloadError = $_.Exception
                Write-Host
                Write-DownloadFailureDetails -Method 'webclient' -Exception $lastDownloadError -Title 'WebClient fallback failed'
            }
        }
        else {
            if ($httpStatus) {
                Write-Host ("Skipping WebClient fallback because the server returned HTTP {0}." -f $httpStatus) -ForegroundColor Yellow
                Write-Host
            }
        }
    }
    else {
        $downloadResult = Invoke-DownloadMethodWithRetries `
            -Url $web_Url `
            -DestinationPath $local_Url `
            -WebClient $webClient `
            -DownloadMethod $selectedDownloadMethod `
            -FileName $web_name_file

        if ($downloadResult.Success) {
            return
        }

        $lastDownloadError = $downloadResult.Error
        $lastDownloadMethod = $downloadResult.Method
    }

    Write-Host ($lang).Download3 -ForegroundColor RED
    if ($lastDownloadError) {
        Write-DownloadFailureDetails -Method $lastDownloadMethod -Exception $lastDownloadError
    }
    Write-Host ($lang).Download4`n

    if ($DownloadFolder -and (Test-Path $DownloadFolder)) {
        Start-Sleep -Milliseconds 200
        Remove-Item -Recurse -LiteralPath $DownloadFolder -ErrorAction SilentlyContinue
    }

    Stop-Script
}

function Remove-TempDirectory {
    param(
        [string]$Directory,
        [int]$DelayMs = 200
    )
    if ($Directory -and (Test-Path $Directory)) {
        Start-Sleep -Milliseconds $DelayMs
        Remove-Item -Recurse -LiteralPath $Directory -ErrorAction SilentlyContinue -Force
    }
}

function DesktopFolder {

    # If the default Dekstop folder does not exist, then try to find it through the registry.
    $ErrorActionPreference = 'SilentlyContinue'
    if (Test-Path "$env:USERPROFILE\Desktop") {
        $desktop_folder = "$env:USERPROFILE\Desktop"
    }

    $regedit_desktop_folder = Get-ItemProperty -Path "Registry::HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders\"
    $regedit_desktop = $regedit_desktop_folder.'{754AC886-DF64-4CBA-86B5-F7FBF4FBCEF5}'

    if (!(Test-Path "$env:USERPROFILE\Desktop")) {
        $desktop_folder = $regedit_desktop
    }
    return $desktop_folder
}

function Test-IsAdministrator {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()

    try {
        $principal = New-Object -TypeName Security.Principal.WindowsPrincipal -ArgumentList $identity
        return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    }
    finally {
        $identity.Dispose()
    }
}

function ConvertTo-DefenderExclusionPath {
    param (
        [string[]]$Path
    )

    $normalizedPaths = foreach ($item in $Path) {
        if ([string]::IsNullOrWhiteSpace($item)) { continue }

        try {
            [IO.Path]::GetFullPath([Environment]::ExpandEnvironmentVariables($item))
        }
        catch {
            Write-Verbose "Invalid Microsoft Defender exclusion path: $item"
        }
    }

    return @($normalizedPaths | Sort-Object -Unique)
}

function ConvertTo-PowerShellStringLiteral {
    param (
        [Parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [string]$Value
    )

    if ($Value.IndexOf([char]34) -ge 0) {
        throw 'Double quotes are not valid in Windows paths'
    }

    $escapedValue = [Management.Automation.Language.CodeGeneration]::EscapeSingleQuotedStringContent($Value)
    return "'$escapedValue'"
}

function Add-SpotifyDefenderExclusions {
    param (
        [Parameter(Mandatory = $true)]
        [string[]]$Path,

        [Parameter(Mandatory = $true)]
        [string[]]$ProcessPath
    )

    [string[]]$paths = @(ConvertTo-DefenderExclusionPath -Path $Path)
    [string[]]$processPaths = @(ConvertTo-DefenderExclusionPath -Path $ProcessPath)
    if ($paths.Count -eq 0 -and $processPaths.Count -eq 0) { return }

    $defenderPrompt = $lang.DefenderPrompt
    $defenderAdded = $lang.DefenderAdded

    try {
        $isAdministrator = Test-IsAdministrator

        if (-not $isAdministrator) {
            do {
                $defenderChoice = Read-Host -Prompt $defenderPrompt
                Write-Host
                if ($defenderChoice -notmatch '^y$|^n$') { incorrectValue }
            }
            while ($defenderChoice -notmatch '^y$|^n$')

            if ($defenderChoice -eq 'n') { return }
        }

        if ($isAdministrator) {
            $modulePath = [IO.Path]::Combine(
                [Environment]::SystemDirectory,
                'WindowsPowerShell\v1.0\Modules\Defender\Defender.psd1'
            )
            $null = Import-Module -Name $modulePath -Force -ErrorAction Stop
            $preferences = Defender\Get-MpPreference -ErrorAction Stop
            $currentPaths = @($preferences.ExclusionPath)
            $currentProcessPaths = @($preferences.ExclusionProcess)
            $missingPaths = @($paths | Where-Object { $_ -notin $currentPaths })
            $missingProcessPaths = @($processPaths | Where-Object { $_ -notin $currentProcessPaths })

            if ($missingPaths.Count -gt 0) {
                $null = Defender\Add-MpPreference -ExclusionPath $missingPaths -Force -ErrorAction Stop
            }
            if ($missingProcessPaths.Count -gt 0) {
                $null = Defender\Add-MpPreference -ExclusionProcess $missingProcessPaths -Force -ErrorAction Stop
            }

            $verified = $false
            for ($attempt = 0; $attempt -lt 5; $attempt++) {
                $updatedPreferences = Defender\Get-MpPreference -ErrorAction Stop
                $updatedPaths = @($updatedPreferences.ExclusionPath)
                $updatedProcessPaths = @($updatedPreferences.ExclusionProcess)
                $remainingPaths = @($paths | Where-Object { $_ -notin $updatedPaths })
                $remainingProcessPaths = @($processPaths | Where-Object { $_ -notin $updatedProcessPaths })
                if ($remainingPaths.Count -eq 0 -and $remainingProcessPaths.Count -eq 0) {
                    $verified = $true
                    break
                }
                if ($attempt -lt 4) { Start-Sleep -Milliseconds 250 }
            }
            if (-not $verified) {
                throw 'Microsoft Defender exclusion verification failed'
            }

            Write-Host $defenderAdded
            Write-Host
            return
        }

        $pathLiterals = @($paths | ForEach-Object {
                ConvertTo-PowerShellStringLiteral -Value $_
            }) -join ', '
        $processPathLiterals = @($processPaths | ForEach-Object {
                ConvertTo-PowerShellStringLiteral -Value $_
            }) -join ', '
        $command = @(
            "`$ErrorActionPreference = 'Stop';"
            'try {'
            "[string[]]`$paths = @($pathLiterals);"
            "[string[]]`$processPaths = @($processPathLiterals);"
            "`$modulePath = [IO.Path]::Combine([Environment]::SystemDirectory, 'WindowsPowerShell\v1.0\Modules\Defender\Defender.psd1');"
            '$null = Import-Module -Name $modulePath -Force -ErrorAction Stop;'
            '$preferences = Defender\Get-MpPreference -ErrorAction Stop;'
            '$currentPaths = @($preferences.ExclusionPath);'
            '$currentProcessPaths = @($preferences.ExclusionProcess);'
            '$missingPaths = @($paths | Where-Object { $_ -notin $currentPaths });'
            '$missingProcessPaths = @($processPaths | Where-Object { $_ -notin $currentProcessPaths });'
            'if ($missingPaths.Count -gt 0) { $null = Defender\Add-MpPreference -ExclusionPath $missingPaths -Force -ErrorAction Stop };'
            'if ($missingProcessPaths.Count -gt 0) { $null = Defender\Add-MpPreference -ExclusionProcess $missingProcessPaths -Force -ErrorAction Stop };'
            '$verified = $false;'
            'for ($attempt = 0; $attempt -lt 5; $attempt++) {'
            '$updatedPreferences = Defender\Get-MpPreference -ErrorAction Stop;'
            '$updatedPaths = @($updatedPreferences.ExclusionPath);'
            '$updatedProcessPaths = @($updatedPreferences.ExclusionProcess);'
            '$remainingPaths = @($paths | Where-Object { $_ -notin $updatedPaths });'
            '$remainingProcessPaths = @($processPaths | Where-Object { $_ -notin $updatedProcessPaths });'
            'if ($remainingPaths.Count -eq 0 -and $remainingProcessPaths.Count -eq 0) { $verified = $true; break };'
            'if ($attempt -lt 4) { Start-Sleep -Milliseconds 250 };'
            '}'
            "if (-not `$verified) { throw 'Microsoft Defender exclusion verification failed' };"
            'exit 0'
            '}'
            'catch {'
            'exit 1'
            '}'
        ) -join ' '

        $systemDirectoryName = if (
            [Environment]::Is64BitOperatingSystem -and
            -not [Environment]::Is64BitProcess
        ) {
            'Sysnative'
        }
        else {
            'System32'
        }
        $powerShellPath = Join-Path $env:SystemRoot "$systemDirectoryName\WindowsPowerShell\v1.0\powershell.exe"
        $startProcessParams = @{
            FilePath     = $powerShellPath
            ArgumentList = "-NoLogo -NoProfile -Command `"$command`""
            Verb          = 'RunAs'
            WindowStyle   = 'Normal'
            Wait          = $true
            PassThru      = $true
            ErrorAction   = 'Stop'
        }

        $process = Start-Process @startProcessParams
        if ($process.ExitCode -ne 0) {
            throw "Elevated Microsoft Defender command failed with exit code $($process.ExitCode)"
        }
        Write-Host $defenderAdded
        Write-Host
    }
    catch {
        Write-Warning $lang.DefenderFailed
        Write-Verbose $_.Exception.Message
        Write-Host
    }
}

if (-not $defender_exclusions_off) {
    try {
        $desktopShortcut = Join-Path (DesktopFolder) 'Spotify.lnk'
        $currentProcess = [Diagnostics.Process]::GetCurrentProcess()
        try {
            $defenderPowerShellProcess = $currentProcess.MainModule.FileName
        }
        finally {
            $currentProcess.Dispose()
        }
        $defenderExclusionPaths = @(
            $spotifyRoamingDirectory
            $spotifyDirectory2
            $spotifyExecutable
            $spotifyDll
            $chrome_elf
            $xpui_spa_patch
            $desktopShortcut
            $start_menu
        )
        $null = Add-SpotifyDefenderExclusions `
            -Path $defenderExclusionPaths `
            -ProcessPath $defenderPowerShellProcess
    }
    catch {
        Write-Warning $lang.DefenderFailed
        Write-Verbose $_.Exception.Message
        Write-Host
    }
}

function Kill-Spotify {
    param (
        [int]$maxAttempts = 5
    )

    for ($attempt = 1; $attempt -le $maxAttempts; $attempt++) {
        $allProcesses = Get-Process -ErrorAction SilentlyContinue

        $spotifyProcesses = $allProcesses | Where-Object { $_.ProcessName -like "*spotify*" }

        if ($spotifyProcesses) {
            foreach ($process in $spotifyProcesses) {
                try {
                    Stop-Process -Id $process.Id -Force
                }
                catch {
                    # Ignore NoSuchProcess exception
                }
            }
            Start-Sleep -Seconds 1
        }
        else {
            break
        }
    }

    if ($attempt -gt $maxAttempts) {
        Write-Host "The maximum number of attempts to terminate a process has been reached."
    }
}


Kill-Spotify

# Remove Spotify Windows Store If Any
if ($win10 -or $win11 -or $win8_1 -or $win8 -or $win12) {

    if (Get-AppxPackage -Name SpotifyAB.SpotifyMusic) {
        Write-Host ($lang).MsSpoti`n

        if (!($confirm_uninstall_ms_spoti)) {
            do {
                $ch = Read-Host -Prompt ($lang).MsSpoti2
                Write-Host
                if (!($ch -eq 'n' -or $ch -eq 'y')) {
                    incorrectValue
                }
            }

            while ($ch -notmatch '^y$|^n$')
        }
        if ($confirm_uninstall_ms_spoti) { $ch = 'y' }
        if ($ch -eq 'y') {
            $previousProgressPreference = $ProgressPreference
            try {
                $ProgressPreference = 'SilentlyContinue' # Hiding Progress Bars
                if ($confirm_uninstall_ms_spoti) { Write-Host ($lang).MsSpoti3`n }
                if (!($confirm_uninstall_ms_spoti)) { Write-Host ($lang).MsSpoti4`n }
                Get-AppxPackage -Name SpotifyAB.SpotifyMusic | Remove-AppxPackage
            }
            finally {
                $ProgressPreference = $previousProgressPreference
            }
        }
        if ($ch -eq 'n') {
            Stop-Script
        }
    }
}

if ($premium) {
    Write-Host ($lang).Prem`n
}

$spotifyInstalled = (Test-Path -LiteralPath $spotifyExecutable)

if ($SpotifyPath -and -not $spotifyInstalled) {
    Write-Warning "Spotify not found in custom path: $spotifyDirectory"
    Stop-Script
}

if ($spotifyInstalled) {

    # Check version Spotify offline
    $offline = (Get-Item $spotifyExecutable).VersionInfo.FileVersion

    # Version comparison
    # converting strings to arrays of numbers using the -split operator and a foreach loop

    $arr1 = $online -split '\.' | foreach { [int]$_ }
    $arr2 = $offline -split '\.' | foreach { [int]$_ }
    $oldversion = $false
    $testversion = $false

    # compare each element of the array in order from most significant to least significant.
    for ($i = 0; $i -lt $arr1.Length; $i++) {
        if ($arr1[$i] -gt $arr2[$i]) {
            $oldversion = $true
            break
        }
        elseif ($arr1[$i] -lt $arr2[$i]) {
            $testversion = $true
            break
        }
    }

    # Old version Spotify (skip if custom path is used)
    if ($oldversion -and -not $SpotifyPath) {
        if (!($confirm_spoti_recomended_over) -and !($confirm_spoti_recomended_uninstall)) {
            do {
                Write-Host (($lang).OldV2 -f $offline, $online)
                $ch = Read-Host -Prompt ($lang).OldV3
                Write-Host
                if (!($ch -eq 'n' -or $ch -eq 'y')) {
                    incorrectValue
                }
            }
            while ($ch -notmatch '^y$|^n$')
        }
        if ($confirm_spoti_recomended_over -or $confirm_spoti_recomended_uninstall) {
            $ch = 'y'
        }
        if ($ch -eq 'y') {
            $upgrade_client = $true

            if (!($confirm_spoti_recomended_over) -and !($confirm_spoti_recomended_uninstall)) {
                do {
                    $ch = Read-Host -Prompt (($lang).DelOrOver -f $offline)
                    Write-Host
                    if (!($ch -eq 'n' -or $ch -eq 'y')) {
                        incorrectValue
                    }
                }
                while ($ch -notmatch '^y$|^n$')
            }
            if ($confirm_spoti_recomended_uninstall) { $ch = 'y' }
            if ($confirm_spoti_recomended_over) { $ch = 'n' }
            if ($ch -eq 'y') {
                Write-Host ($lang).DelSpotify`n
                $null = Unlock-Folder
                Invoke-SpotifyUninstall -InstalledVersion $offline
            }
            if ($ch -eq 'n') { $ch = $null }
        }
        if ($ch -eq 'n') {
            $downgrading = $true
        }
    }

    # Unsupported version Spotify (skip if custom path is used)
    if ($testversion -and -not $SpotifyPath) {
        $autoVersionDowngradeUninstall = $versionIsSupported -and !$confirm_spoti_recomended_over -and !$confirm_spoti_recomended_uninstall

        if (!($confirm_spoti_recomended_over) -and !($confirm_spoti_recomended_uninstall) -and !$autoVersionDowngradeUninstall) {
            do {
                Write-Host (($lang).NewV2 -f $offline, $online)
                $ch = Read-Host -Prompt (($lang).NewV3 -f $offline)
                Write-Host
                if (!($ch -eq 'n' -or $ch -eq 'y')) {
                    incorrectValue
                }
            }
            while ($ch -notmatch '^y$|^n$')
        }
        if ($confirm_spoti_recomended_over -or $confirm_spoti_recomended_uninstall -or $autoVersionDowngradeUninstall) { $ch = 'n' }
        if ($ch -eq 'y') { $upgrade_client = $false }
        if ($ch -eq 'n') {
            if (!($confirm_spoti_recomended_over) -and !($confirm_spoti_recomended_uninstall) -and !$autoVersionDowngradeUninstall) {
                do {
                    $ch = Read-Host -Prompt (($lang).Recom -f $online)
                    Write-Host
                    if (!($ch -eq 'n' -or $ch -eq 'y')) {
                        incorrectValue
                    }
                }
                while ($ch -notmatch '^y$|^n$')
            }
            if ($confirm_spoti_recomended_over -or $confirm_spoti_recomended_uninstall -or $autoVersionDowngradeUninstall) {
                $ch = 'y'
            }
            if ($ch -eq 'y') {
                $upgrade_client = $true
                $downgrading = $true
                if (!($confirm_spoti_recomended_over) -and !($confirm_spoti_recomended_uninstall) -and !$autoVersionDowngradeUninstall) {
                    do {
                        $ch = Read-Host -Prompt (($lang).DelOrOver -f $offline)
                        Write-Host
                        if (!($ch -eq 'n' -or $ch -eq 'y')) {
                            incorrectValue
                        }
                    }
                    while ($ch -notmatch '^y$|^n$')
                }
                if ($confirm_spoti_recomended_uninstall) { $ch = 'y' }
                if ($confirm_spoti_recomended_over) { $ch = 'n' }
                if ($autoVersionDowngradeUninstall) { $ch = 'y' }
                if ($ch -eq 'y') {
                    Write-Host ($lang).DelSpotify`n
                    $null = Unlock-Folder
                    Invoke-SpotifyUninstall -InstalledVersion $offline
                }
                if ($ch -eq 'n') { $ch = $null }
            }

            if ($ch -eq 'n') {
                Remove-TempDirectory -Directory $tempDirectory
                Stop-Script
            }
        }
    }
}
# If there is no client or it is outdated, then install (skip if custom path is used)
if (-not $SpotifyPath -and (-not $spotifyInstalled -or $upgrade_client)) {

    Write-Host ($lang).DownSpoti"" -NoNewline
    Write-Host  $online -ForegroundColor Green
    Write-Host ($lang).DownSpoti2`n

    # Delete old version files of Spotify before installing, leave only profile files
    $ErrorActionPreference = 'SilentlyContinue'
    Kill-Spotify
    Start-Sleep -Milliseconds 600
    $null = Unlock-Folder
    Start-Sleep -Milliseconds 200
    Get-ChildItem $spotifyDirectory -Exclude 'Users', 'prefs' | Remove-Item -Recurse -Force
    Start-Sleep -Milliseconds 200

    $tempDirName = "SpotX_Temp-$(Get-Date -UFormat '%Y-%m-%d_%H-%M-%S')"
    $tempDirectory = Join-Path ([System.IO.Path]::GetTempPath()) $tempDirName
    if (-not (Test-Path -LiteralPath $tempDirectory)) { New-Item -ItemType Directory -Path $tempDirectory | Out-Null }

    # Client download
    downloadSp -DownloadFolder $tempDirectory
    Write-Host

    Start-Sleep -Milliseconds 200

    # Client installation
    $setupExe = Join-Path $tempDirectory 'SpotifySetup.exe'
    Start-Process -FilePath explorer.exe -ArgumentList $setupExe
    while (-not (get-process | Where-Object { $_.ProcessName -eq 'SpotifySetup' })) {}
    wait-process -name SpotifySetup
    Kill-Spotify

    # Upgrade check version Spotify offline
    $offline = (Get-Item $spotifyExecutable).VersionInfo.FileVersion

    # Upgrade check version Spotify.bak
    $offline_bak = (Get-Item $exe_bak).VersionInfo.FileVersion
}



# Delete Spotify shortcut if it is on desktop
if ($no_shortcut) {
    $ErrorActionPreference = 'SilentlyContinue'
    $desktop_folder = DesktopFolder
    Start-Sleep -Milliseconds 1000
    remove-item "$desktop_folder\Spotify.lnk" -Recurse -Force
}

$ch = $null


# updated Russian translation
if ($langCode -eq 'ru' -and [version]$offline -ge [version]"1.1.92.644") {

    $webjsonru = Get -Url (Get-Link -e "/patches/Augmented%20translation/ru.json")

    if ($webjsonru -ne $null) {

        $ru = $true
    }
}

if ($podcasts_off) {
    Write-Host ($lang).PodcatsOff`n
    $ch = 'y'
}
if ($podcasts_on) {
    Write-Host ($lang).PodcastsOn`n
    $ch = 'n'
}
if (!($podcasts_off) -and !($podcasts_on)) {

    do {
        $ch = Read-Host -Prompt ($lang).PodcatsSelect
        Write-Host
        if (!($ch -eq 'n' -or $ch -eq 'y')) { incorrectValue }
    }
    while ($ch -notmatch '^y$|^n$')
}
if ($ch -eq 'y') { $podcast_off = $true }

$ch = $null

if ($downgrading) { $upd = "`n" + [string]($lang).DowngradeNote }

else { $upd = "" }

if ($block_update_on) {
    Write-Host ($lang).UpdBlock`n
    $ch = 'y'
}
if ($block_update_off) {
    Write-Host ($lang).UpdUnblock`n
    $ch = 'n'
}
if (!($block_update_on) -and !($block_update_off)) {
    do {
        $text_upd = [string]($lang).UpdSelect + $upd
        $ch = Read-Host -Prompt $text_upd
        Write-Host
        if (!($ch -eq 'n' -or $ch -eq 'y')) { incorrectValue }
    }
    while ($ch -notmatch '^y$|^n$')
}
if ($ch -eq 'y') { $not_block_update = $false }

if (!($new_theme) -and [version]$offline -ge [version]"1.2.14.1141") {
    Write-Warning "This version does not support the old theme, use version 1.2.13.661 or below"
    Write-Host
}

if ($ch -eq 'n') {
    $not_block_update = $true
    $ErrorActionPreference = 'SilentlyContinue'
    if ((Test-Path -LiteralPath $exe_bak) -and $offline -eq $offline_bak) {
        Remove-Item $spotifyExecutable -Recurse -Force
        Rename-Item $exe_bak $spotifyExecutable
    }
}

$ch = $null

$webjson = Get-PatchesJson -LocalPath $CustomPatchesPath

if ($webjson -eq $null) {
    Write-Host
    Write-Host "Failed to load patches.json" -ForegroundColor Red
    Remove-TempDirectory -Directory $tempDirectory
    Stop-Script
}

function Get-JsonValue {
    param (
        [AllowNull()]
        [object]$Object,

        [Parameter(Mandatory = $true)]
        [string]$Name
    )

    if ($null -eq $Object) { return $null }
    $property = $Object.PSObject.Properties[$Name]
    if ($null -eq $property) { return $null }
    return $property.Value
}

function Test-PatchVersionMatch {
    param (
        [AllowNull()]
        [object]$Patch,

        [switch]$Translate
    )

    if ($null -eq $Patch) { return $false }
    if ((Get-JsonValue -Object $Patch -Name 'disable') -eq $true) { return $false }
    if ($Translate) { return $true }

    $version = Get-JsonValue -Object $Patch -Name 'version'
    $versionTo = Get-JsonValue -Object $version -Name 'to'
    $versionFr = Get-JsonValue -Object $version -Name 'fr'
    $offline_patch = $offline -replace '(\d+\.\d+\.\d+)(.\d+)', '$1'

    if ($versionTo) { $to = [version]$versionTo -ge [version]$offline_patch } else { $to = $true }
    if ($versionFr) { $fr = [version]$versionFr -le [version]$offline_patch } else { $fr = $false }

    return $fr -and $to
}

function Helper($paramname, [switch]$CheckOnly) {


    function Remove-Json {
        param (
            [Parameter(Mandatory = $true)]
            [Alias("j")]
            [PSObject]$Json,

            [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
            [Alias("p")]
            [string[]]$Properties
        )

        foreach ($Property in $Properties) {
            $Json.psobject.properties.Remove($Property)
        }
    }
    function Move-Json {
        param (
            [Parameter(Mandatory = $true)]
            [Alias("t")]
            [PSObject]$to,

            [Parameter(Mandatory = $true)]
            [Alias("n")]
            [string[]]$name,

            [Parameter(Mandatory = $true)]
            [Alias("f")]
            [PSObject]$from
        )

        foreach ($propertyName in $name) {
            $from | Add-Member -MemberType NoteProperty -Name $propertyName -Value $to.$propertyName
            Remove-Json -j $to -p $propertyName
        }
    }
    switch ( $paramname ) {
        "HtmlLicMin" {
            # Licenses HTML minification
            $name = "patches.json.others."
            $n = $licensesFileName
            $contents = "htmlmin"
            $json = $webjson.others
        }
        "HtmlBlank" {
            # htmlBlank minification
            $name = "patches.json.others."
            $n = "blank.html"
            $contents = "blank.html"
            $json = $webjson.others
        }
        "MinJs" {
            # Minification of all *.js
            $contents = "minjs"
            $json = $webjson.others
        }
        "MinJson" {
            # Minification of all *.json
            $contents = "minjson"
            $json = $webjson.others
        }
        "FixCss" {
            # Remove indent for old theme xpui.css
            $name = "patches.json.others."
            $n = "xpui.css"
            $contents = "fix-old-theme"
            $json = $webjson.others
        }
        "Fixjs" {
            $n = $name
            $contents = "searchFixes"
            $name = "patches.json.others."
            $json = $webjson.others
        }
        "Cssmin" {
            # Minification of all *.css
            $contents = "cssmin"
            $json = $webjson.others
        }
        "DisableSentry" {

            $name = "patches.json.others."
            $n = $fileName
            $contents = "disablesentry"
            $json = $webjson.others
        }
        "Discriptions" {
            # Add discriptions (xpui-desktop-modals.js)

            if (!$CheckOnly) {
                $svg_tg = $webjson.others.discriptions.svgtg
                $svg_git = $webjson.others.discriptions.svggit
                $svg_faq = $webjson.others.discriptions.svgfaq
                $replace = $webjson.others.discriptions.replace

                $replacedText = $replace -f $svg_git, $svg_tg, $svg_faq

                $webjson.others.discriptions.replace = '$1"' + $replacedText + '"})'
            }

            $name = "patches.json.others."
            $n = "xpui-desktop-modals.js"
            $contents = "discriptions"
            $json = $webjson.others
        }
        "OffadsonFullscreen" {
            # Full screen mode activation and removing "Upgrade to premium" menu, upgrade button, disabling a playlist sponsor
            $name = "patches.json.free."
            $n = "xpui.js"
            $contents = $webjson.free.psobject.properties.name
            $json = $webjson.free
        }
        "ForcedExp" {
            # Forced disable some exp (xpui.js)
            if ($CheckOnly) {
                $name = "patches.json.others."
                $n = "xpui.js"
                $contents = "ForcedExp"
                $json = $webjson.others
                break
            }

            $offline_patch = $offline -replace '(\d+\.\d+\.\d+)(.\d+)', '$1'
            $Enable = $webjson.others.EnableExp
            $Disable = $webjson.others.DisableExp
            $Custom = $webjson.others.CustomExp

            # causes lags in the main menu 1.2.44-1.2.56
            if ([version]$offline -le [version]'1.2.56.502') { Move-Json -n 'HomeCarousels' -t $Enable -f $Disable }

            # disable search suggestions
            Move-Json -n 'SearchSuggestions' -t $Enable -f $Disable

            # disable new scrollbar
            Move-Json -n 'NewOverlayScrollbars' -t $Enable -f $Disable

            # temporarily disable collapsing right sidebar
            Move-Json -n 'PeekNpv' -t $Enable -f $Disable

            if ($podcast_off) { Move-Json -n 'HomePin' -t $Enable -f $Disable }

            # disabled broken panel from 1.2.37 to 1.2.38
            if ([version]$offline -eq [version]'1.2.37.701' -or [version]$offline -eq [version]'1.2.38.720' ) {
                Move-Json -n 'DevicePickerSidePanel' -t $Enable -f $Disable
            }

            if ([version]$offline -ge [version]'1.2.41.434' -and $lyrics_block) { Move-Json -n 'Lyrics' -t $Enable -f $Disable }

            Remove-Json -j $Enable -p 'RightSidebarLyrics'
            if ($Custom.PSObject.Properties.Name -contains 'LyricsVariationsInNPV') {
                $Custom.LyricsVariationsInNPV.value = "CONTROL"
            }

            if ([version]$offline -eq [version]'1.2.30.1135') { Move-Json -n 'QueueOnRightPanel' -t $Enable -f $Disable }

            if ([version]$offline -le [version]'1.2.50.335') {

                if (!($plus)) { Move-Json -n "Plus", "AlignedCurationSavedIn" -t $Enable -f $Disable }

            }

            if (!$topsearchbar) {
                Move-Json -n "GlobalNavBar" -t $Enable -f $Disable
                $Custom.GlobalNavBar.value = "control"
                if ([version]$offline -le [version]"1.2.45.454") {
                    Move-Json -n "RecentSearchesDropdown" -t $Enable -f $Disable
                }
            }
            if ([version]$offline -le [version]'1.2.50.335') {

                if (!($funnyprogressbar)) { Move-Json -n 'HeBringsNpb' -t $Enable -f $Disable }

            }

            if ([version]$offline -le [version]'1.2.62.580') {

                if (!$newFullscreenMode) { Move-Json -n "ImprovedCinemaMode", "ImprovedCinemaModeCanvas" -t $Enable -f $Disable }

            }
            # disable subfeed filter chips on home
            if ($homesub_off) {
                Move-Json -n "HomeSubfeeds" -t $Enable -f $Disable
            }

            # Old theme
            if (!($new_theme) -and [version]$offline -le [version]"1.2.13.661") {

                Move-Json -n 'RightSidebar', 'LeftSidebar' -t $Enable -f $Disable

                Remove-Json -j $Custom -p "NavAlt", 'NavAlt2'
                Remove-Json -j $Enable -p 'RightSidebarLyrics', 'RightSidebarCredits', 'RightSidebar', 'LeftSidebar', 'RightSidebarColors'
            }
            # New theme
            else {
                if ($rightsidebar_off -and [version]$offline -lt [version]"1.2.24.756") {
                    Move-Json -n 'RightSidebar' -t $Enable -from $Disable
                }
                else {
                    if (!($rightsidebarcolor)) { Remove-Json -j $Enable -p 'RightSidebarColors' }
                }
            }
            if (!$premium) { Remove-Json -j $Enable -p 'RemoteDownloads', 'Magpie', 'MagpiePrompting', 'MagpieScheduling', 'MagpieCuration', 'MagpieAudiobookRows' }

            # Disable unimportant exp
            if ($exp_spotify) {
                $objects = @(
                    @{
                        Object           = $webjson.others.CustomExp.psobject.properties
                        PropertiesToKeep = @('LyricsUpsell', 'LyricsVariationsInNPV')
                    },
                    @{
                        Object           = $webjson.others.EnableExp.psobject.properties
                        PropertiesToKeep = @('BrowseViaPathfinder', 'HomeViaGraphQLV2')
                    }
                )

                foreach ($obj in $objects) {
                    $propertiesToRemove = $obj.Object.Name | Where-Object { $_ -notin $obj.PropertiesToKeep }
                    $propertiesToRemove | foreach {
                        $obj.Object.Remove($_)
                    }
                }

            }

            $Exp = ($Enable, $Disable, $Custom)

            foreach ($item in $Exp) {
                $itemProperties = $item | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name

                foreach ($key in $itemProperties) {
                    $vers = $item.$key.version

                    if (!($vers.to -eq "" -or [version]$vers.to -ge [version]$offline_patch -and [version]$vers.fr -le [version]$offline_patch)) {
                        if ($item.PSObject.Properties.Name -contains $key) {
                            $item.PSObject.Properties.Remove($key)
                        }
                    }
                }
            }

            $Enable = $webjson.others.EnableExp
            $Disable = $webjson.others.DisableExp
            $Custom = $webjson.others.CustomExp

            $enableNames = foreach ($item in $Enable.PSObject.Properties.Name) {
                $webjson.others.EnableExp.$item.name
            }

            $disableNames = foreach ($item in $Disable.PSObject.Properties.Name) {
                $webjson.others.DisableExp.$item.name
            }

            $customNames = foreach ($item in $Custom.PSObject.Properties.Name) {
                $custname = $webjson.others.CustomExp.$item.name
                $custvalue = $webjson.others.CustomExp.$item.value

                # Create a string with the desired format
                $objectString = "{name:'$custname',value:'$custvalue'}"
                $objectString
            }

            # Convert the strings of objects into a single text string
            if ([string]::IsNullOrEmpty($customNames)) { $customTextVariable = '[]' }
            else { $customTextVariable = "[" + ($customNames -join ',') + "]" }
            if ([string]::IsNullOrEmpty($enableNames)) { $enableTextVariable = '[]' }
            else { $enableTextVariable = "['" + ($enableNames -join "','") + "']" }
            if ([string]::IsNullOrEmpty($disableNames)) { $disableTextVariable = '[]' }
            else { $disableTextVariable = "['" + ($disableNames -join "','") + "']" }

            $replacements = @(
                @("enable:[]", "enable:$enableTextVariable"),
                @("disable:[]", "disable:$disableTextVariable"),
                @("custom:[]", "custom:$customTextVariable")
            )

            foreach ($replacement in $replacements) {
                $webjson.others.ForcedExp.replace = $webjson.others.ForcedExp.replace.Replace($replacement[0], $replacement[1])
            }

            $name = "patches.json.others."
            $n = "xpui.js"
            $contents = "ForcedExp"
            $json = $webjson.others
        }
        "RuTranslate" {
            # Additional translation of some words for the Russian language
            $n = "ru.json"
            $contents = $webjsonru.psobject.properties.name
            $json = $webjsonru
        }
        "Binary" {
            if ($CheckOnly) {
                $name = "patches.json.others.binary."
                $n = "Spotify.exe"
                $contents = $webjson.others.binary.psobject.properties.name
                $json = $webjson.others.binary
                break
            }

            $binary = $webjson.others.binary

            if ($not_block_update) { Remove-Json -j $binary -p 'block_update' }

            if ($premium) { Remove-Json -j $binary -p 'block_slots_2', 'block_slots_3' }

            $name = "patches.json.others.binary."
            $n = "Spotify.exe"
            $contents = $webjson.others.binary.psobject.properties.name
            $json = $webjson.others.binary
        }
        "Collaborators" {
            # Hide Collaborators icon
            $name = "patches.json.others."
            $n = "xpui-routes-playlist.js"
            $contents = "collaboration"
            $json = $webjson.others
        }
        "Dev" {

            $name = "patches.json.others."
            $n = "xpui-routes-desktop-settings.js"
            $contents = "dev-tools"
            $json = $webjson.others

        }
        "HomeV2-js" {

            $name = "patches.json.others."
            $n = "home-v2.js"
            $contents = "fixHomeV2EmptyResponseCheck"
            $json = $webjson.others
        }
        "VariousofXpui-js" {
            if ($CheckOnly) {
                $name = "patches.json.VariousJs."
                $n = "xpui.js"
                $contents = $webjson.VariousJs.psobject.properties.name
                $json = $webjson.VariousJs
                break
            }

            $VarJs = $webjson.VariousJs

            if ($premium) { Remove-Json -j $VarJs -p 'mock', 'upgradeButton', 'upgradeMenu' }

            if ($topsearchbar -or ([version]$offline -ne [version]"1.2.45.451" -and [version]$offline -ne [version]"1.2.45.454")) {
                Remove-Json -j $VarJs -p "fixTitlebarHeight"
            }

            if (!($lyrics_block)) { Remove-Json -j $VarJs -p "lyrics-block" }

            else {
                Remove-Json -j $VarJs -p "lyrics-old-on"
            }

            if (!($devtools)) { Remove-Json -j $VarJs -p "dev-tools" }

            else {
                if ([version]$offline -ge [version]"1.2.35.663") {

                    # Create a copy of 'dev-tools'
                    $newDevTools = $webjson.VariousJs.'dev-tools'.PSObject.Copy()

                    # Delete the first item and change the version
                    $newDevTools.match = $newDevTools.match[0], $newDevTools.match[2]
                    $newDevTools.replace = $newDevTools.replace[0], $newDevTools.replace[2]
                    $newDevTools.version.fr = '1.2.35'

                    # Assign a copy of 'devtools' to the 'devtools' property in $web json.others
                    $webjson.others | Add-Member -Name 'dev-tools' -Value $newDevTools -MemberType NoteProperty

                    # leave only first item in $web json.Various Js.'devtools' match & replace
                    $webjson.VariousJs.'dev-tools'.match = $webjson.VariousJs.'dev-tools'.match[1]
                    $webjson.VariousJs.'dev-tools'.replace = $webjson.VariousJs.'dev-tools'.replace[1]
                }
            }

            if ($urlform_goofy -and $idbox_goofy) {
                $webjson.VariousJs.goofyhistory.replace = $webjson.VariousJs.goofyhistory.replace -f "`"$urlform_goofy`"", "`"$idbox_goofy`""
            }
            else { Remove-Json -j $VarJs -p "goofyhistory" }

            if (!($ru)) { Remove-Json -j $VarJs -p "offrujs" }

            $adds = $null
            if (!($premium) -or ($cache_limit)) {
                if (!($premium)) {
                    $adds += $webjson.VariousJs.product_state.add
                }

                if ($cache_limit) {

                    if ($cache_limit -lt 500) { $cache_limit = 500 }
                    if ($cache_limit -gt 20000) { $cache_limit = 20000 }

                    $adds2 = $webjson.VariousJs.product_state.add2
                    if (!([string]::IsNullOrEmpty($adds))) { $adds2 = ',' + $adds2 }
                    $adds += $adds2 -f $cache_limit

                }
                $repl = $webjson.VariousJs.product_state.replace
                $webjson.VariousJs.product_state.replace = $repl -f "{pairs:{$adds}}"
            }
            else { Remove-Json -j $VarJs -p 'product_state' }


            $name = "patches.json.VariousJs."
            $n = "xpui.js"
            $contents = $webjson.VariousJs.psobject.properties.name
            $json = $webjson.VariousJs
        }
    }
    $paramdata = $xpui
    $novariable = "Didn't find variable "

    foreach ($contentName in @($contents)) {
        if ([string]::IsNullOrEmpty($contentName)) {
            continue
        }

        $contentPatch = Get-JsonValue -Object $json -Name $contentName
        if ($null -eq $contentPatch) {
            continue
        }

        if ((Get-JsonValue -Object $contentPatch -Name 'disable') -eq $true) {
            continue
        }

        $translate = $paramname -eq "RuTranslate"
        $checkVer = Test-PatchVersionMatch -Patch $contentPatch -Translate:$translate

        if ($checkVer) {
            if ($CheckOnly) { return $true }

            $matchValue = Get-JsonValue -Object $contentPatch -Name 'match'
            $replaceValue = Get-JsonValue -Object $contentPatch -Name 'replace'
            if ($null -eq $matchValue -or $null -eq $replaceValue) {
                continue
            }

            $matchPatterns = @($matchValue)
            $replacements = @($replaceValue)

            if ($matchPatterns.Count -gt 1) {

                $count = $matchPatterns.Count - 1
                $numbers = 0

                While ($numbers -le $count) {

                    if ($paramdata -match $matchPatterns[$numbers]) {
                        $paramdata = $paramdata -replace $matchPatterns[$numbers], $replacements[$numbers]
                    }
                    else {
                        $notlog = "MinJs", "MinJson", "Cssmin"
                        if ($paramname -notin $notlog) {

                            Write-Host $novariable -ForegroundColor red -NoNewline
                            Write-Host "$name$contentName $numbers"'in'$n
                        }
                    }
                    $numbers++
                }
            }
            if ($matchPatterns.Count -eq 1) {
                if ($paramdata -match $matchPatterns[0]) {
                    $paramdata = $paramdata -replace $matchPatterns[0], $replacements[0]
                }
                else {
                    if (!($translate) -or $err_ru) {
                        Write-Host $novariable -ForegroundColor red -NoNewline
                        Write-Host "$name$contentName"'in'$n
                    }
                }
            }
        }
    }
    if ($CheckOnly) { return $false }
    $paramdata
}

function extract ($counts, $method, $name, $helper, $add, $patch) {
    $zip = $null
    $reader = $null
    $writer = $null

    if ($helper -and $null -eq $add -and !(Helper -paramname $helper -CheckOnly)) { return }

    try {
        switch ( $counts ) {
            "one" {
                if ($method -eq "zip") {
                    Add-Type -Assembly 'System.IO.Compression.FileSystem'
                    $xpui_spa_patch = Join-Path (Join-Path $spotifyDirectory 'Apps') 'xpui.spa'
                    $zip = [System.IO.Compression.ZipFile]::Open($xpui_spa_patch, 'update')
                    $file = $zip.GetEntry($name)
                    if ($null -eq $file) {
                        Write-Warning "Error: Archive entry not found: $name"
                        return
                    }
                    $reader = New-Object System.IO.StreamReader($file.Open())
                }
                elseif ($method -eq "nonezip") {
                    $file = Get-Item (Join-Path (Join-Path (Join-Path $spotifyDirectory 'Apps') 'xpui') $name) -ErrorAction Stop
                    $reader = New-Object -TypeName System.IO.StreamReader -ArgumentList $file
                }
                else {
                    throw "Unsupported extraction method: $method"
                }

                $xpui = $reader.ReadToEnd()
                $reader.Dispose()
                $reader = $null

                if ($helper) { $xpui = Helper -paramname $helper }
                if ($method -eq "zip") { $writer = New-Object System.IO.StreamWriter($file.Open()) }
                if ($method -eq "nonezip") { $writer = New-Object System.IO.StreamWriter -ArgumentList $file }
                $writer.BaseStream.SetLength(0)
                $writer.Write($xpui)
                if ($add) { $add | foreach { $writer.Write([System.Environment]::NewLine + $PSItem ) } }
                $writer.Dispose()
                $writer = $null
            }
            "more" {
                Add-Type -Assembly 'System.IO.Compression.FileSystem'
                $xpui_spa_patch = Join-Path (Join-Path $spotifyDirectory 'Apps') 'xpui.spa'
                $zip = [System.IO.Compression.ZipFile]::Open($xpui_spa_patch, 'update')
                $entries = @($zip.Entries | Where-Object { $_.FullName -like $name -and $_.FullName.Split('/') -notcontains 'spotx-helper' })

                foreach ($entry in $entries) {
                    $reader = New-Object System.IO.StreamReader($entry.Open())
                    $xpui = $reader.ReadToEnd()
                    $reader.Dispose()
                    $reader = $null

                    $xpui = Helper -paramname $helper
                    $writer = New-Object System.IO.StreamWriter($entry.Open())
                    $writer.BaseStream.SetLength(0)
                    $writer.Write($xpui)
                    $writer.Dispose()
                    $writer = $null
                }
            }
            "exe" {
                $ANSI = [Text.Encoding]::GetEncoding(1251)
                $xpui = [IO.File]::ReadAllText($spotify_binary, $ANSI)
                $xpui = Helper -paramname $helper
                [IO.File]::WriteAllText($spotify_binary, $xpui, $ANSI)
            }
        }
    }
    catch {
        Stop-BrokenSpotifyFiles -Details "Error: $($_.Exception.Message)"
    }
    finally {
        if ($null -ne $reader) { $reader.Dispose() }
        if ($null -ne $writer) { $writer.Dispose() }
        if ($null -ne $zip) { $zip.Dispose() }
    }
}

function injection {
    param(
        [Alias("p")]
        [string]$ArchivePath,

        [Alias("f")]
        [string]$FolderInArchive,

        [Alias("n")]
        [string[]]$FileNames,

        [Alias("c")]
        [string[]]$FileContents,

        [Alias("i")]
        [string[]]$FilesToInject  # force only specific file/files to connect index.html otherwise all will be connected
    )

    $folderPathInArchive = "$($FolderInArchive)/"

    Add-Type -AssemblyName System.IO.Compression.FileSystem
    $archive = $null

    try {
        $archive = [System.IO.Compression.ZipFile]::Open($ArchivePath, 'Update')

        for ($i = 0; $i -lt $FileNames.Length; $i++) {
            $fileName = $FileNames[$i]
            $fileContent = $FileContents[$i]

            $entry = $archive.GetEntry($folderPathInArchive + $fileName)
            if ($entry -eq $null) {
                $stream = $archive.CreateEntry($folderPathInArchive + $fileName).Open()
            }
            else {
                $stream = $entry.Open()
            }

            $writer = [System.IO.StreamWriter]::new($stream)
            $writer.Write($fileContent)

            $writer.Dispose()
            $stream.Dispose()
        }

        $indexEntry = $archive.Entries | Where-Object { $_.FullName -eq "index.html" }
        if ($indexEntry -ne $null) {
            $indexStream = $indexEntry.Open()
            $reader = [System.IO.StreamReader]::new($indexStream)
            $indexContent = $reader.ReadToEnd()
            $reader.Dispose()
            $indexStream.Dispose()

            $headTagIndex = $indexContent.IndexOf("</head>")
            $scriptTagIndex = $indexContent.IndexOf("<script")

            if ($headTagIndex -ge 0 -or $scriptTagIndex -ge 0) {
                $filesToInject = if ($FilesToInject) { $FilesToInject } else { $FileNames }

                foreach ($fileName in $filesToInject) {
                    if ($fileName.EndsWith(".js")) {
                        $modifiedIndexContent = $indexContent.Insert($scriptTagIndex, "<script defer=`"defer`" src=`"/$FolderInArchive/$fileName`"></script>")
                        $indexContent = $modifiedIndexContent
                    }
                    elseif ($fileName.EndsWith(".css")) {
                        $modifiedIndexContent = $indexContent.Insert($headTagIndex, "<link href=`"/$FolderInArchive/$fileName`" rel=`"stylesheet`">")
                        $indexContent = $modifiedIndexContent
                    }
                }

                $indexEntry.Delete()
                $newIndexEntry = $archive.CreateEntry("index.html").Open()
                $indexWriter = [System.IO.StreamWriter]::new($newIndexEntry)
                $indexWriter.Write($indexContent)
                $indexWriter.Dispose()
                $newIndexEntry.Dispose()

            }
            else {
                Write-Warning "<script or </head> tag was not found in the index.html file in the archive."
            }
        }
        else {
            Write-Warning "index.html not found in xpui.spa"
        }
    }
    catch {
        Stop-BrokenSpotifyFiles -Details "Error: $($_.Exception.Message)"
    }
    finally {
        if ($archive -ne $null) {
            $archive.Dispose()
        }
    }
}


function Extract-WebpackModules {
    param(
        [Parameter(Mandatory = $true)]
        [string]$InputFile
    )

    $scriptStart = Get-Date
    Write-Debug "=== Script execution started ==="
    Write-Debug "Input file: $InputFile"

    function Encode-UTF16LE {
        param([byte[]]$Bytes)
        $str = [System.Text.Encoding]::UTF8.GetString($Bytes)
        [System.Text.Encoding]::Unicode.GetBytes($str)
    }

    $StartMarker = [System.Text.Encoding]::UTF8.GetBytes("var __webpack_modules__={")
    $EndMarker = [System.Text.Encoding]::UTF8.GetBytes("//# sourceMappingURL=xpui-modules.js.map")

    [byte[]]$fileContent = [System.IO.File]::ReadAllBytes($InputFile)

    $isUTF16LE = $false
    if ($fileContent.Length -ge 2 -and $fileContent[0] -eq 0xFF -and $fileContent[1] -eq 0xFE) {
        $isUTF16LE = $true
    }
    elseif ($fileContent.Length -gt 100 -and $fileContent[1] -eq 0x00) {
        $isUTF16LE = $true
    }
    if (-not $isUTF16LE) {
        Write-Error "File is not in UTF-16LE format: $InputFile"
        exit 1
    }

    $searchStartMarker = Encode-UTF16LE -Bytes $StartMarker
    $searchEndMarker = Encode-UTF16LE -Bytes $EndMarker

    function IndexOfBytes($haystack, $needle, [int]$startIndex = 0) {
        if ($startIndex -lt 0) { $startIndex = 0 }
        $haystackLength = $haystack.Length
        $needleLength = $needle.Length
        $searchLimit = $haystackLength - $needleLength
        if ($searchLimit -lt $startIndex) { return -1 }
        $firstNeedleByte = $needle[0]
        for ($i = $startIndex; $i -le $searchLimit; $i++) {
            if ($haystack[$i] -eq $firstNeedleByte) {
                $found = $true
                for ($j = 1; $j -lt $needleLength; $j++) {
                    if ($haystack[$i + $j] -ne $needle[$j]) {
                        $found = $false
                        break
                    }
                }
                if ($found) { return $i }
            }
        }
        return -1
    }

    $startIdx = IndexOfBytes $fileContent $searchStartMarker 2
    if ($startIdx -eq -1) {
        Write-Error "Start marker not found"
        exit 1
    }
    Write-Debug "Start marker found at index $startIdx"

    $endMarkerSearchOffset = $startIdx + $searchStartMarker.Length
    $endIdx = IndexOfBytes $fileContent $searchEndMarker $endMarkerSearchOffset
    if ($endIdx -eq -1) {
        Write-Error "End marker not found after index $endMarkerSearchOffset"
        exit 1
    }
    Write-Debug "End marker found at absolute index $endIdx"

    $endDataIdx = $endIdx + $searchEndMarker.Length
    $length = $endDataIdx - $startIdx

    Write-Debug "Decoding data from UTF-16LE..."
    $decodedString = [System.Text.Encoding]::Unicode.GetString($fileContent, $startIdx, $length)

    $scriptEnd = Get-Date
    $duration = [math]::Round(($scriptEnd - $scriptStart).TotalSeconds, 1)
    Write-Debug "=== Execution completed in $duration seconds ==="

    return $decodedString
}

function Initialize-BinaryScanner {
    if (([System.Management.Automation.PSTypeName]'BinaryScannerV3').Type) {
        return
    }

    $csharpCode = @"
using System;
using System.Collections.Generic;

// Bump the type name when the scanner API changes
public static class BinaryScannerV3 {
    public static int FindBytes(byte[] data, byte[] pattern, int start) {
        if (data == null || pattern == null || pattern.Length == 0) return -1;
        if (start < 0) start = 0;
        for (int i = start; i <= data.Length - pattern.Length; i++) {
            if (data[i] != pattern[0]) continue;
            bool matched = true;
            for (int j = 1; j < pattern.Length; j++) {
                if (data[i + j] != pattern[j]) {
                    matched = false;
                    break;
                }
            }
            if (matched) return i;
        }
        return -1;
    }

    public static bool MatchBytes(byte[] data, int offset, byte[] pattern) {
        if (data == null || pattern == null || pattern.Length == 0) return false;
        if (offset < 0 || offset > data.Length - pattern.Length) return false;
        for (int i = 0; i < pattern.Length; i++) {
            if (data[offset + i] != pattern[i]) return false;
        }
        return true;
    }

    public static int FindMaskedBytes(byte[] data, byte[] pattern, byte[] mask, int start, int length) {
        if (data == null || pattern == null || mask == null || pattern.Length == 0 || pattern.Length != mask.Length) return -1;
        if (start < 0) start = 0;
        if (start >= data.Length || length <= 0) return -1;
        int end = (int)Math.Min(data.Length, (long)start + length);
        int limit = end - pattern.Length;
        for (int i = start; i <= limit; i++) {
            bool matched = true;
            for (int j = 0; j < pattern.Length; j++) {
                if (mask[j] != 0 && data[i + j] != pattern[j]) {
                    matched = false;
                    break;
                }
            }
            if (matched) return i;
        }
        return -1;
    }

    public static bool MatchMaskedBytes(byte[] data, int offset, byte[] pattern, byte[] mask) {
        if (data == null || pattern == null || mask == null || pattern.Length == 0 || pattern.Length != mask.Length) return false;
        if (offset < 0 || offset > data.Length - pattern.Length) return false;
        for (int i = 0; i < pattern.Length; i++) {
            if (mask[i] != 0 && data[offset + i] != pattern[i]) return false;
        }
        return true;
    }

    public static List<int> FindXrefArm64(byte[] data, ulong stringRVA, ulong sectionRVA, uint sectionRawPtr, uint sectionSize) {
        List<int> results = new List<int>();
        for (uint i = 0; i < sectionSize; i += 4) {
            ulong fileOffset = (ulong)sectionRawPtr + i;
            if ((ulong)i + 8 > sectionSize || fileOffset + 8 > (ulong)data.Length) break;
            uint inst1 = BitConverter.ToUInt32(data, (int)fileOffset);

            // ADRP
            if ((inst1 & 0x9F000000) == 0x90000000) {
                int rd = (int)(inst1 & 0x1F);
                long immLo = (inst1 >> 29) & 3;
                long immHi = (inst1 >> 5) & 0x7FFFF;
                long imm = (immHi << 2) | immLo;
                if ((imm & 0x100000) != 0) { imm |= unchecked((long)0xFFFFFFFFFFE00000); }
                imm = imm << 12;
                ulong pc = sectionRVA + i;
                ulong pcPage = pc & 0xFFFFFFFFFFFFF000;
                ulong page = (ulong)((long)pcPage + imm);

                uint inst2 = BitConverter.ToUInt32(data, (int)fileOffset + 4);
                // ADD
                if ((inst2 & 0xFFC00000) == 0x91000000) {
                    int rn = (int)((inst2 >> 5) & 0x1F);
                    if (rn == rd) {
                        long imm12 = (inst2 >> 10) & 0xFFF;
                        ulong target = page + (ulong)imm12;
                        if (target == stringRVA) { results.Add((int)fileOffset); }
                    }
                }
            }
        }
        return results;
    }

    public static int[] FindRipLeaRefs(byte[] bytes, int start, int length, long targetRva, int[] rawPtrs, int[] rawSizes, int[] virtualAddresses) {
        var result = new List<int>();
        if (bytes == null || rawPtrs == null || rawSizes == null || virtualAddresses == null) return result.ToArray();
        if (rawPtrs.Length != rawSizes.Length || rawPtrs.Length != virtualAddresses.Length) return result.ToArray();
        if (start < 0) start = 0;
        int end = (int)Math.Min(bytes.Length, (long)start + length);
        for (int p = start; p + 7 <= end; p++) {
            if ((bytes[p] & 0xF8) != 0x48 || bytes[p + 1] != 0x8D) continue;
            if ((bytes[p + 2] & 0xC7) != 0x05) continue;
            long nextRva = OffsetToRva(p + 7, rawPtrs, rawSizes, virtualAddresses);
            if (nextRva < 0) continue;
            int disp = BitConverter.ToInt32(bytes, p + 3);
            if (nextRva + disp == targetRva) result.Add(p);
        }
        return result.ToArray();
    }

    public static int[] FindCrossfadeGateCallsToRva(byte[] bytes, int start, int length, long targetRva, int[] rawPtrs, int[] rawSizes, int[] virtualAddresses) {
        var result = new List<int>();
        if (bytes == null || rawPtrs == null || rawSizes == null || virtualAddresses == null) return result.ToArray();
        if (rawPtrs.Length != rawSizes.Length || rawPtrs.Length != virtualAddresses.Length) return result.ToArray();
        if (start < 0) start = 0;
        int end = (int)Math.Min(bytes.Length, (long)start + length);
        for (int p = start; p + 6 <= end; p++) {
            if (bytes[p] != 0xE8) continue;
            long nextRva = OffsetToRva(p + 5, rawPtrs, rawSizes, virtualAddresses);
            if (nextRva < 0) continue;
            int disp = BitConverter.ToInt32(bytes, p + 1);
            if (nextRva + disp == targetRva && bytes[p + 5] == 0x88) {
                result.Add(p);
            }
        }
        return result.ToArray();
    }

    public static long[] FindFunctionRange(byte[] bytes, int runtimeFunctionsRawPtr, int runtimeFunctionsRawSize, long rva, long codeRva, long codeSize) {
        if (bytes == null || runtimeFunctionsRawPtr < 0 || runtimeFunctionsRawSize <= 0 || codeSize <= 0) return Array.Empty<long>();
        long runtimeFunctionsEnd = Math.Min(bytes.Length, (long)runtimeFunctionsRawPtr + runtimeFunctionsRawSize);
        long codeEnd = codeRva + codeSize;
        long bestBegin = -1;
        long bestFinish = -1;
        for (int p = runtimeFunctionsRawPtr; (long)p + 12 <= runtimeFunctionsEnd; p += 12) {
            long begin = BitConverter.ToUInt32(bytes, p);
            long finish = BitConverter.ToUInt32(bytes, p + 4);
            if (begin < codeRva || finish <= begin || finish > codeEnd || rva < begin || rva >= finish) continue;
            if (bestBegin < 0 || begin > bestBegin || (begin == bestBegin && finish < bestFinish)) {
                bestBegin = begin;
                bestFinish = finish;
            }
        }
        return bestBegin < 0 ? Array.Empty<long>() : new long[] { bestBegin, bestFinish };
    }

    public static long[] FindArm64FunctionRange(byte[] bytes, int runtimeFunctionsRawPtr, int runtimeFunctionsRawSize, long rva, long codeRva, long codeSize, int[] rawPtrs, int[] rawSizes, int[] virtualAddresses) {
        if (bytes == null || rawPtrs == null || rawSizes == null || virtualAddresses == null) return Array.Empty<long>();
        if (rawPtrs.Length != rawSizes.Length || rawPtrs.Length != virtualAddresses.Length) return Array.Empty<long>();
        if (runtimeFunctionsRawPtr < 0 || runtimeFunctionsRawSize <= 0 || codeSize <= 0) return Array.Empty<long>();
        long runtimeFunctionsEnd = Math.Min(bytes.Length, (long)runtimeFunctionsRawPtr + runtimeFunctionsRawSize);
        long codeEnd = codeRva + codeSize;
        long bestBegin = -1;
        long bestFinish = -1;
        for (int p = runtimeFunctionsRawPtr; (long)p + 8 <= runtimeFunctionsEnd; p += 8) {
            long begin = BitConverter.ToUInt32(bytes, p);
            uint unwind = BitConverter.ToUInt32(bytes, p + 4);
            if (begin < codeRva || begin >= codeEnd || unwind == 0) continue;

            long length;
            uint flag = unwind & 3;
            if (flag == 1 || flag == 2) {
                length = ((unwind >> 2) & 0x7FF) * 4L;
            } else if (flag == 0) {
                int unwindOffset = RvaToOffset(unwind, rawPtrs, rawSizes, virtualAddresses);
                if (unwindOffset < 0 || unwindOffset > bytes.Length - 4) continue;
                uint header = BitConverter.ToUInt32(bytes, unwindOffset);
                if (((header >> 18) & 3) != 0) continue;
                length = (header & 0x3FFFF) * 4L;
            } else {
                continue;
            }

            long finish = begin + length;
            if (length <= 0 || finish > codeEnd || rva < begin || rva >= finish) continue;
            if (bestBegin < 0 || begin > bestBegin || (begin == bestBegin && finish < bestFinish)) {
                bestBegin = begin;
                bestFinish = finish;
            }
        }
        return bestBegin < 0 ? Array.Empty<long>() : new long[] { bestBegin, bestFinish };
    }

    public static int[] FindArm64BlockSlotsCallers(byte[] bytes, int start, int length, uint enumValue) {
        var result = new List<int>();
        if (bytes == null || enumValue > 0xFFFF) return result.ToArray();
        if (start < 0) start = 0;
        int end = (int)Math.Min(bytes.Length, (long)start + length);
        uint movEnum = 0x52800001 | (enumValue << 5);
        for (int p = start; p + 12 <= end; p += 4) {
            uint call = BitConverter.ToUInt32(bytes, p);
            uint branch = BitConverter.ToUInt32(bytes, p + 4);
            uint loadEnum = BitConverter.ToUInt32(bytes, p + 8);
            if ((call & 0xFC000000) != 0x94000000) continue;
            if ((branch & 0xFFF8001F) != 0x37000000) continue;
            if (loadEnum == movEnum) result.Add(p);
        }
        return result.ToArray();
    }

    private static long OffsetToRva(int offset, int[] rawPtrs, int[] rawSizes, int[] virtualAddresses) {
        for (int i = 0; i < rawPtrs.Length; i++) {
            if (offset >= rawPtrs[i] && offset < rawPtrs[i] + rawSizes[i]) {
                return (long)virtualAddresses[i] + (offset - rawPtrs[i]);
            }
        }
        return -1;
    }

    private static int RvaToOffset(long rva, int[] rawPtrs, int[] rawSizes, int[] virtualAddresses) {
        for (int i = 0; i < rawPtrs.Length; i++) {
            long relative = rva - virtualAddresses[i];
            if (relative >= 0 && relative < rawSizes[i]) {
                return rawPtrs[i] + (int)relative;
            }
        }
        return -1;
    }
}
"@

    try {
        Add-Type -TypeDefinition $csharpCode -ErrorAction Stop
    }
    catch {
        $compilerError = $_.Exception.Message -split '\r?\n' | Select-Object -First 1
        throw "BinaryScanner initialization failed: $compilerError"
    }

    if (-not ([System.Management.Automation.PSTypeName]'BinaryScannerV3').Type) {
        throw "BinaryScanner initialization failed: Type was not loaded"
    }
}

function Convert-HexStringToBytes {
    param([string]$HexString)

    return [byte[]]($HexString -split '\s+' | Where-Object { $_ } | ForEach-Object { [Convert]::ToByte($_, 16) })
}

function Read-PEUInt16([byte[]]$Bytes, [int]$Offset) { [BitConverter]::ToUInt16($Bytes, $Offset) }
function Read-PEUInt32([byte[]]$Bytes, [int]$Offset) { [BitConverter]::ToUInt32($Bytes, $Offset) }
function Read-PEUInt64([byte[]]$Bytes, [int]$Offset) { [BitConverter]::ToUInt64($Bytes, $Offset) }

function Get-PEArchitectureOffsets {
    param([UInt16]$MachineType)

    $result = @{ Architecture = $null; DataDirectoryOffset = $null }
    switch ($MachineType) {
        0x8664 { $result.Architecture = 'x64'; $result.DataDirectoryOffset = 112 }
        0xAA64 { $result.Architecture = 'ARM64'; $result.DataDirectoryOffset = 112 }
        0x014c { $result.Architecture = 'x86'; $result.DataDirectoryOffset = 96 }
        default { $result.Architecture = 'Unknown'; $result.DataDirectoryOffset = $null }
    }
    $result.MachineType = $MachineType
    return $result
}

function Get-PEFileInfo {
    param([byte[]]$Bytes)

    $peHeaderOffset = [int](Read-PEUInt32 $Bytes 0x3C)
    if ($Bytes[$peHeaderOffset] -ne 0x50 -or $Bytes[$peHeaderOffset + 1] -ne 0x45) {
        throw 'Invalid PE file'
    }

    $fileHeaderOffset = $peHeaderOffset + 4
    $optionalHeaderOffset = $fileHeaderOffset + 20
    $machineType = Read-PEUInt16 $Bytes $fileHeaderOffset
    $archInfo = Get-PEArchitectureOffsets -MachineType $machineType
    $optionalHeaderMagic = Read-PEUInt16 $Bytes $optionalHeaderOffset

    if ($optionalHeaderMagic -eq 0x20b) {
        $imageBase = [int64](Read-PEUInt64 $Bytes ($optionalHeaderOffset + 24))
    }
    elseif ($optionalHeaderMagic -eq 0x10b) {
        $imageBase = [int64](Read-PEUInt32 $Bytes ($optionalHeaderOffset + 28))
    }
    else {
        throw 'Unsupported optional header format'
    }

    $numberOfSections = [int](Read-PEUInt16 $Bytes ($fileHeaderOffset + 2))
    $optionalHeaderSize = [int](Read-PEUInt16 $Bytes ($fileHeaderOffset + 16))
    $sectionTableStart = $optionalHeaderOffset + $optionalHeaderSize
    $exceptionDirectoryRva = [int64]0
    $exceptionDirectorySize = [int64]0
    if ($null -ne $archInfo.DataDirectoryOffset -and ($archInfo.DataDirectoryOffset + 32) -le $optionalHeaderSize) {
        $dataDirectoryStart = $optionalHeaderOffset + $archInfo.DataDirectoryOffset
        $exceptionDirectoryRva = [int64](Read-PEUInt32 $Bytes ($dataDirectoryStart + 24))
        $exceptionDirectorySize = [int64](Read-PEUInt32 $Bytes ($dataDirectoryStart + 28))
    }
    $sections = @()
    $codeSection = $null

    for ($i = 0; $i -lt $numberOfSections; $i++) {
        $sectionOffset = $sectionTableStart + ($i * 40)
        $nameBytes = $Bytes[$sectionOffset..($sectionOffset + 7)]
        $name = ([Text.Encoding]::ASCII.GetString($nameBytes) -replace "`0.*$", '')
        $characteristics = Read-PEUInt32 $Bytes ($sectionOffset + 36)
        $section = [PSCustomObject]@{
            Name           = $name
            VirtualSize    = [int64](Read-PEUInt32 $Bytes ($sectionOffset + 8))
            VirtualAddress = [int64](Read-PEUInt32 $Bytes ($sectionOffset + 12))
            RawSize        = [int64](Read-PEUInt32 $Bytes ($sectionOffset + 16))
            RawPtr         = [int64](Read-PEUInt32 $Bytes ($sectionOffset + 20))
            Characteristics = $characteristics
        }
        $sections += $section
        if (($characteristics -band 0x20) -ne 0 -and $null -eq $codeSection) {
            $codeSection = $section
        }
    }

    $exceptionTable = $null
    foreach ($section in $sections) {
        $sectionSpan = [Math]::Max([int64]$section.VirtualSize, [int64]$section.RawSize)
        if ($exceptionDirectoryRva -lt $section.VirtualAddress -or
            $exceptionDirectoryRva -ge ($section.VirtualAddress + $sectionSpan)) {
            continue
        }

        $relativeOffset = $exceptionDirectoryRva - $section.VirtualAddress
        if ($relativeOffset -lt 0 -or
            ($relativeOffset + $exceptionDirectorySize) -gt $section.RawSize -or
            ($section.RawPtr + $relativeOffset + $exceptionDirectorySize) -gt $Bytes.Length) {
            break
        }
        $exceptionTable = [PSCustomObject]@{
            Rva     = $exceptionDirectoryRva
            RawPtr  = [int64]$section.RawPtr + $relativeOffset
            RawSize = $exceptionDirectorySize
        }
        break
    }

    return [PSCustomObject]@{
        PeHeaderOffset      = $peHeaderOffset
        FileHeaderOffset    = $fileHeaderOffset
        OptionalHeaderOffset = $optionalHeaderOffset
        MachineType         = $machineType
        Architecture        = $archInfo.Architecture
        DataDirectoryOffset = $archInfo.DataDirectoryOffset
        ImageBase           = $imageBase
        Sections            = $sections
        CodeSection         = $codeSection
        ExceptionTable      = $exceptionTable
    }
}

function Get-PERvaFromOffset {
    param(
        [object[]]$Sections,
        [int64]$Offset
    )

    foreach ($section in $Sections) {
        if ($Offset -ge $section.RawPtr -and $Offset -lt ($section.RawPtr + $section.RawSize)) {
            return [int64]$section.VirtualAddress + ($Offset - $section.RawPtr)
        }
    }
    return $null
}

function Get-PEOffsetFromRva {
    param(
        [object[]]$Sections,
        [int64]$Rva
    )

    foreach ($section in $Sections) {
        $sectionSpan = [Math]::Max([int64]$section.VirtualSize, [int64]$section.RawSize)
        if ($Rva -lt $section.VirtualAddress -or $Rva -ge ($section.VirtualAddress + $sectionSpan)) {
            continue
        }

        $relativeOffset = $Rva - $section.VirtualAddress
        if ($relativeOffset -ge $section.RawSize) {
            return $null
        }
        return [int64]$section.RawPtr + $relativeOffset
    }
    return $null
}

function Get-BinaryPatchContext {
    param(
        [object]$PeInfo
    )

    $text = $PeInfo.CodeSection
    $runtimeFunctions = $PeInfo.ExceptionTable
    if (-not $text -or -not $runtimeFunctions) {
        throw 'Required PE code or exception data was not found'
    }
    $runtimeFunctionSize = if ($PeInfo.Architecture -eq 'ARM64') { 8 } else { 12 }
    if ($runtimeFunctions.RawSize -lt $runtimeFunctionSize -or
        ($runtimeFunctions.RawSize % $runtimeFunctionSize) -ne 0) {
        throw 'PE exception data size is invalid'
    }

    return [PSCustomObject]@{
        Text             = $text
        RuntimeFunctions = $runtimeFunctions
        RawPtrs          = [int[]]($PeInfo.Sections | ForEach-Object { [int]$_.RawPtr })
        RawSizes         = [int[]]($PeInfo.Sections | ForEach-Object { [int]$_.RawSize })
        VirtualAddresses = [int[]]($PeInfo.Sections | ForEach-Object { [int]$_.VirtualAddress })
    }
}

function Get-UniqueBinaryAnchor {
    param(
        [byte[]]$Bytes,
        [object]$PeInfo,
        [string]$Text,
        [switch]$NullTerminated
    )

    $anchorText = if ($NullTerminated) { "$Text`0" } else { $Text }
    $anchor = [Text.Encoding]::ASCII.GetBytes($anchorText)
    $anchorOffset = [BinaryScannerV3]::FindBytes($Bytes, $anchor, 0)
    if ($anchorOffset -lt 0 -or [BinaryScannerV3]::FindBytes($Bytes, $anchor, $anchorOffset + 1) -ge 0) {
        throw "$Text anchor was not found uniquely"
    }

    $anchorRva = Get-PERvaFromOffset -Sections $PeInfo.Sections -Offset $anchorOffset
    if ($null -eq $anchorRva) {
        throw "$Text anchor RVA was not found"
    }

    return [PSCustomObject]@{
        Offset = [int64]$anchorOffset
        Rva    = [int64]$anchorRva
    }
}

function Read-Arm64Instruction {
    param(
        [byte[]]$Bytes,
        [int64]$Offset
    )

    if ($Offset -lt 0 -or $Offset + 4 -gt $Bytes.Length -or ($Offset % 4) -ne 0) {
        throw 'ARM64 instruction is outside the file or unaligned'
    }
    return [BitConverter]::ToUInt32($Bytes, [int]$Offset)
}

function ConvertFrom-Arm64SignedImmediate {
    param(
        [int64]$Value,
        [int]$Bits
    )

    $sign = [int64]1 -shl ($Bits - 1)
    if (($Value -band $sign) -ne 0) {
        return $Value - ([int64]1 -shl $Bits)
    }
    return $Value
}

function Get-Arm64AdrTargetRva {
    param(
        [uint32]$Instruction,
        [int64]$InstructionRva
    )

    if (($Instruction -band [uint32]0x9F000000L) -ne [uint32]0x10000000) {
        throw 'Expected ARM64 ADR instruction'
    }
    $immediate = [int64]((($Instruction -shr 5) -band 0x7FFFF) -shl 2) -bor
        [int64](($Instruction -shr 29) -band 3)
    return $InstructionRva + (ConvertFrom-Arm64SignedImmediate -Value $immediate -Bits 21)
}

function Get-Arm64BranchTargetRva {
    param(
        [uint32]$Instruction,
        [int64]$InstructionRva,
        [ValidateSet('B', 'BL', 'TbnzW0Bit0')]
        [string]$Kind
    )

    switch ($Kind) {
        'B' {
            if (($Instruction -band [uint32]0xFC000000L) -ne [uint32]0x14000000) {
                throw 'Expected ARM64 B instruction'
            }
            $immediate = ConvertFrom-Arm64SignedImmediate -Value ([int64]($Instruction -band 0x03FFFFFF)) -Bits 26
        }
        'BL' {
            if (($Instruction -band [uint32]0xFC000000L) -ne [uint32]0x94000000L) {
                throw 'Expected ARM64 BL instruction'
            }
            $immediate = ConvertFrom-Arm64SignedImmediate -Value ([int64]($Instruction -band 0x03FFFFFF)) -Bits 26
        }
        'TbnzW0Bit0' {
            if (($Instruction -band [uint32]0xFFF8001FL) -ne [uint32]0x37000000) {
                throw 'Expected ARM64 TBNZ w0, #0 instruction'
            }
            $immediate = ConvertFrom-Arm64SignedImmediate -Value ([int64](($Instruction -shr 5) -band 0x3FFF)) -Bits 14
        }
    }
    return $InstructionRva + ($immediate -shl 2)
}

function Get-Arm64CbzW8TargetRva {
    param(
        [uint32]$Instruction,
        [int64]$InstructionRva
    )

    if (($Instruction -band [uint32]0xFF00001FL) -ne [uint32]0x34000008) {
        throw 'Expected ARM64 CBZ w8 instruction'
    }
    $immediate = ConvertFrom-Arm64SignedImmediate -Value ([int64](($Instruction -shr 5) -band 0x7FFFF)) -Bits 19
    return $InstructionRva + ($immediate -shl 2)
}

function New-Arm64BranchBytes {
    param(
        [int64]$InstructionRva,
        [int64]$TargetRva
    )

    $displacement = $TargetRva - $InstructionRva
    if (($displacement % 4) -ne 0 -or $displacement -lt -0x8000000 -or $displacement -gt 0x7FFFFFC) {
        throw 'ARM64 branch target is out of range or unaligned'
    }
    $immediate = ([int64]($displacement / 4)) -band 0x03FFFFFF
    return [BitConverter]::GetBytes([uint32]([uint32]0x14000000 -bor [uint32]$immediate))
}

function Get-BinaryPatchFunctionRange {
    param(
        [byte[]]$Bytes,
        [object]$PeInfo,
        [object]$Context,
        [int64]$Rva
    )

    if ($PeInfo.Architecture -eq 'x64') {
        return , ([BinaryScannerV3]::FindFunctionRange(
            $Bytes,
            [int]$Context.RuntimeFunctions.RawPtr,
            [int]$Context.RuntimeFunctions.RawSize,
            $Rva,
            [int64]$Context.Text.VirtualAddress,
            [Math]::Max([int64]$Context.Text.VirtualSize, [int64]$Context.Text.RawSize)
        ))
    }
    if ($PeInfo.Architecture -eq 'ARM64') {
        return , ([BinaryScannerV3]::FindArm64FunctionRange(
            $Bytes,
            [int]$Context.RuntimeFunctions.RawPtr,
            [int]$Context.RuntimeFunctions.RawSize,
            $Rva,
            [int64]$Context.Text.VirtualAddress,
            [Math]::Max([int64]$Context.Text.VirtualSize, [int64]$Context.Text.RawSize),
            $Context.RawPtrs,
            $Context.RawSizes,
            $Context.VirtualAddresses
        ))
    }
    return , ([long[]]@())
}

function Find-ResetDllSignBinaryPatchLocation {
    param(
        [byte[]]$Bytes,
        [object]$PeInfo
    )

    $context = Get-BinaryPatchContext -PeInfo $PeInfo
    $anchor = Get-UniqueBinaryAnchor `
        -Bytes $Bytes `
        -PeInfo $PeInfo `
        -Text 'Check failed: sep_pos != std::wstring::npos.'

    switch ($PeInfo.Architecture) {
        'x64' {
            $anchorRefs = @([BinaryScannerV3]::FindRipLeaRefs(
                $Bytes,
                [int]$context.Text.RawPtr,
                [int]$context.Text.RawSize,
                [int64]$anchor.Rva,
                $context.RawPtrs,
                $context.RawSizes,
                $context.VirtualAddresses
            ) | Select-Object -Unique)
            $patchedBytes = Convert-HexStringToBytes 'B8 01 00 00 00 C3'
        }
        'ARM64' {
            $anchorRefs = @([BinaryScannerV3]::FindXrefArm64(
                $Bytes,
                [uint64]$anchor.Rva,
                [uint64]$context.Text.VirtualAddress,
                [uint32]$context.Text.RawPtr,
                [uint32]$context.Text.RawSize
            ) | Select-Object -Unique)
            $patchedBytes = Convert-HexStringToBytes '20 00 80 52 C0 03 5F D6'
        }
        default {
            throw "Architecture $($PeInfo.Architecture) is not supported for reset_dll_sign patch"
        }
    }
    if ($anchorRefs.Count -eq 0) {
        throw 'reset_dll_sign code reference was not found'
    }

    $functions = @{}
    foreach ($anchorRef in $anchorRefs) {
        $anchorRefRva = Get-PERvaFromOffset -Sections $PeInfo.Sections -Offset $anchorRef
        if ($null -eq $anchorRefRva) { continue }
        $range = Get-BinaryPatchFunctionRange -Bytes $Bytes -PeInfo $PeInfo -Context $context -Rva $anchorRefRva
        if ($range.Length -ne 2) { continue }
        $functions['{0:X}' -f [int64]$range[0]] = [PSCustomObject]@{
            StartRva = [int64]$range[0]
            EndRva   = [int64]$range[1]
        }
    }
    if ($functions.Count -ne 1) {
        throw "Expected one reset_dll_sign function, found $($functions.Count)"
    }

    $function = @($functions.Values)[0]
    $patchOffset = Get-PEOffsetFromRva -Sections $PeInfo.Sections -Rva $function.StartRva
    if ($null -eq $patchOffset -or
        ($function.EndRva - $function.StartRva) -lt $patchedBytes.Length -or
        $patchOffset + $patchedBytes.Length -gt $Bytes.Length) {
        throw 'reset_dll_sign patch range is invalid'
    }
    $patchOffset = [int64]$patchOffset

    if ([BinaryScannerV3]::MatchBytes($Bytes, [int]$patchOffset, $patchedBytes)) {
        $state = 'Patched'
        $originalBytes = $null
    }
    else {
        if ($PeInfo.Architecture -eq 'ARM64') {
            $prologue = Read-Arm64Instruction -Bytes $Bytes -Offset $patchOffset
            if (($prologue -band [uint32]0xFF00FFFFL) -ne [uint32]0xA9007BFDL) {
                throw 'Unexpected ARM64 reset_dll_sign function prologue'
            }
        }
        else {
            $firstByte = [int]$Bytes[$patchOffset]
            if ($firstByte -ne 0x48 -and $firstByte -ne 0x40 -and $firstByte -ne 0x55 -and
                ($firstByte -lt 0x53 -or $firstByte -gt 0x57)) {
                throw 'Unexpected x64 reset_dll_sign function prologue'
            }
        }
        $originalBytes = [byte[]]$Bytes[$patchOffset..($patchOffset + $patchedBytes.Length - 1)]
        $state = 'Original'
    }

    return [PSCustomObject]@{
        Architecture  = $PeInfo.Architecture
        FunctionRva   = $function.StartRva
        PatchOffset   = $patchOffset
        OriginalBytes = $originalBytes
        PatchedBytes  = $patchedBytes
        State         = $state
        AnchorRefCount = $anchorRefs.Count
    }
}

function Reset-Dll-Sign {
    [CmdletBinding()]
    param (
        [string]$FilePath
    )

    $result = Invoke-VerifiedBinaryPatch `
        -FilePath $FilePath `
        -PatchName 'reset_dll_sign' `
        -Locator {
            param([byte[]]$Bytes, [object]$PeInfo)
            Find-ResetDllSignBinaryPatchLocation -Bytes $Bytes -PeInfo $PeInfo
        } `
        -DescribeLocation {
            param([object]$Location)
            Write-Verbose ("reset_dll_sign {0} function RVA 0x{1:X}, references {2}" -f
                $Location.Architecture, $Location.FunctionRva, $Location.AnchorRefCount)
        }
    if (-not $result) {
        Stop-Script
    }
}

function Read-X64SignedByte {
    param(
        [byte[]]$Bytes,
        [int]$Offset
    )

    if ($Offset -lt 0 -or $Offset -ge $Bytes.Length) {
        throw 'Signed byte is outside the file'
    }

    $value = [int]$Bytes[$Offset]
    if ($value -ge 0x80) {
        return $value - 0x100
    }
    return $value
}

function Read-X64RelativeBranch {
    param(
        [byte[]]$Bytes,
        [int]$Offset,
        [ValidateSet('Je', 'Jne', 'Jmp')]
        [string]$Kind,
        [int]$Limit
    )

    switch ($Kind) {
        'Je' { $shortOpcode = 0x74; $nearOpcode = 0x84 }
        'Jne' { $shortOpcode = 0x75; $nearOpcode = 0x85 }
        'Jmp' { $shortOpcode = 0xEB; $nearOpcode = $null }
    }

    if ($Offset -ge 0 -and ($Offset + 2) -le $Limit -and $Bytes[$Offset] -eq $shortOpcode) {
        $nextOffset = $Offset + 2
        $displacement = Read-X64SignedByte -Bytes $Bytes -Offset ($Offset + 1)
    }
    elseif ($null -ne $nearOpcode -and $Offset -ge 0 -and ($Offset + 6) -le $Limit -and
        $Bytes[$Offset] -eq 0x0F -and $Bytes[$Offset + 1] -eq $nearOpcode) {
        $nextOffset = $Offset + 6
        $displacement = [BitConverter]::ToInt32($Bytes, $Offset + 2)
    }
    elseif ($Kind -eq 'Jmp' -and $Offset -ge 0 -and ($Offset + 5) -le $Limit -and $Bytes[$Offset] -eq 0xE9) {
        $nextOffset = $Offset + 5
        $displacement = [BitConverter]::ToInt32($Bytes, $Offset + 1)
    }
    else {
        throw "Expected $Kind branch"
    }

    return [PSCustomObject]@{
        NextOffset   = [int]$nextOffset
        TargetOffset = [int64]$nextOffset + [int64]$displacement
    }
}

function Read-X64BlockSlotsField {
    param(
        [byte[]]$Bytes,
        [int]$Offset,
        [ValidateSet('CmpRcxBl', 'MovAlRcx', 'CmpRdiBl')]
        [string]$Kind
    )

    switch ($Kind) {
        'CmpRcxBl' { $disp8 = Convert-HexStringToBytes '38 59'; $disp32 = Convert-HexStringToBytes '38 99' }
        'MovAlRcx' { $disp8 = Convert-HexStringToBytes '8A 41'; $disp32 = Convert-HexStringToBytes '8A 81' }
        'CmpRdiBl' { $disp8 = Convert-HexStringToBytes '38 5F'; $disp32 = Convert-HexStringToBytes '38 9F' }
    }

    if ([BinaryScannerV3]::MatchBytes($Bytes, $Offset, $disp8) -and ($Offset + 3) -le $Bytes.Length) {
        return [PSCustomObject]@{
            Value      = [int64](Read-X64SignedByte -Bytes $Bytes -Offset ($Offset + 2))
            NextOffset = $Offset + 3
        }
    }
    if ([BinaryScannerV3]::MatchBytes($Bytes, $Offset, $disp32) -and ($Offset + 6) -le $Bytes.Length) {
        return [PSCustomObject]@{
            Value      = [int64][BitConverter]::ToInt32($Bytes, $Offset + 2)
            NextOffset = $Offset + 6
        }
    }

    throw "Unexpected block_slots field instruction"
}

function Get-X64BlockSlotsMapperSequenceEnum {
    param(
        [byte[]]$Bytes,
        [int]$SequenceOffset,
        [int]$BranchOffset,
        [bool]$MatchTaken = $true
    )

    $movEcxR8d = Convert-HexStringToBytes '41 8B C8'
    $subEcx8 = Convert-HexStringToBytes '83 E9'
    $subEcx32 = Convert-HexStringToBytes '81 E9'
    $cmpEcx8 = Convert-HexStringToBytes '83 F9'
    $cmpEcx32 = Convert-HexStringToBytes '81 F9'
    if (-not [BinaryScannerV3]::MatchBytes($Bytes, $SequenceOffset, $movEcxR8d)) {
        return @()
    }

    $matches = @()
    for ($enumValue = 1; $enumValue -le 0x3FF; $enumValue++) {
        $ecx = [int64]$enumValue
        $zeroFlag = $false
        $hasFlags = $false
        $cursor = $SequenceOffset + $movEcxR8d.Length
        $valid = $true
        $matched = $false

        while ($cursor -le $BranchOffset) {
            if ([BinaryScannerV3]::MatchBytes($Bytes, $cursor, $subEcx8)) {
                $ecx -= [int64](Read-X64SignedByte -Bytes $Bytes -Offset ($cursor + 2))
                $zeroFlag = ($ecx -eq 0)
                $hasFlags = $true
                $cursor += 3
                continue
            }
            if ([BinaryScannerV3]::MatchBytes($Bytes, $cursor, $subEcx32)) {
                $ecx -= [int64][BitConverter]::ToInt32($Bytes, $cursor + 2)
                $zeroFlag = ($ecx -eq 0)
                $hasFlags = $true
                $cursor += 6
                continue
            }
            if ([BinaryScannerV3]::MatchBytes($Bytes, $cursor, $cmpEcx8)) {
                $compareValue = [int64](Read-X64SignedByte -Bytes $Bytes -Offset ($cursor + 2))
                $zeroFlag = ($ecx -eq $compareValue)
                $hasFlags = $true
                $cursor += 3
                continue
            }
            if ([BinaryScannerV3]::MatchBytes($Bytes, $cursor, $cmpEcx32)) {
                $compareValue = [int64][BitConverter]::ToInt32($Bytes, $cursor + 2)
                $zeroFlag = ($ecx -eq $compareValue)
                $hasFlags = $true
                $cursor += 6
                continue
            }

            $branchLength = 0
            $branchOnEqual = $false
            if (($cursor + 2) -le $Bytes.Length -and ($Bytes[$cursor] -eq 0x74 -or $Bytes[$cursor] -eq 0x75)) {
                $branchLength = 2
                $branchOnEqual = ($Bytes[$cursor] -eq 0x74)
            }
            elseif (($cursor + 6) -le $Bytes.Length -and $Bytes[$cursor] -eq 0x0F -and
                ($Bytes[$cursor + 1] -eq 0x84 -or $Bytes[$cursor + 1] -eq 0x85)) {
                $branchLength = 6
                $branchOnEqual = ($Bytes[$cursor + 1] -eq 0x84)
            }
            else {
                $valid = $false
                break
            }

            if (-not $hasFlags) {
                $valid = $false
                break
            }
            $branchTaken = if ($branchOnEqual) { $zeroFlag } else { -not $zeroFlag }
            if ($cursor -eq $BranchOffset) {
                $matched = if ($MatchTaken) { $branchTaken } else { -not $branchTaken }
                break
            }
            if ($branchTaken) {
                $valid = $false
                break
            }
            $cursor += $branchLength
        }

        if ($valid -and $matched) {
            $matches += [uint32]$enumValue
        }
    }

    return $matches
}

function Get-X64BlockSlotsMapperEnumValue {
    param(
        [byte[]]$Bytes,
        [object]$PeInfo,
        [int64]$MapperStartRva,
        [int64]$MapperEndRva,
        [int[]]$AnchorRefs
    )

    $mapperOffset = Get-PEOffsetFromRva -Sections $PeInfo.Sections -Rva $MapperStartRva
    if ($null -eq $mapperOffset) {
        throw 'slot_is_disabled mapper offset was not found'
    }

    $mapperOffset = [int]$mapperOffset
    $mapperEndOffset = [int64]$mapperOffset + ($MapperEndRva - $MapperStartRva)
    if ($mapperEndOffset -le $mapperOffset -or $mapperEndOffset -gt $Bytes.Length) {
        throw 'slot_is_disabled mapper range is invalid'
    }

    $stringCases = @(
        [PSCustomObject]@{
            PrefixLength = 20
            Pattern      = Convert-HexStringToBytes '0F 57 C0 0F 11 02 48 89 7A 10 48 89 7A 18 41 B8 10 00 00 00 48 8D 15 00 00 00 00'
            Mask         = Convert-HexStringToBytes 'FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF 00 00 00 00'
            DispatchMode = 'Target'
        },
        [PSCustomObject]@{
            PrefixLength = 18
            Pattern      = Convert-HexStringToBytes '0F 57 C0 0F 11 02 48 89 7A 10 48 89 7A 18 44 8D 41 0F 48 8D 15 00 00 00 00'
            Mask         = Convert-HexStringToBytes 'FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF 00 00 00 00'
            DispatchMode = 'Fallthrough'
        }
    )
    $movEcxR8d = Convert-HexStringToBytes '41 8B C8'
    $cmpR8d8 = Convert-HexStringToBytes '41 83 F8'
    $cmpR8d32 = Convert-HexStringToBytes '41 81 F8'
    $enumValues = @{}

    foreach ($anchorRef in $AnchorRefs) {
        if (([int64]$anchorRef + 7) -gt $mapperEndOffset) {
            continue
        }

        foreach ($stringCase in $stringCases) {
            $caseOffset = [int]$anchorRef - $stringCase.PrefixLength
            if ($caseOffset -lt $mapperOffset -or
                -not [BinaryScannerV3]::MatchMaskedBytes($Bytes, $caseOffset, $stringCase.Pattern, $stringCase.Mask)) {
                continue
            }

            $dispatches = @()
            if ($stringCase.DispatchMode -eq 'Target') {
                for ($branchOffset = $mapperOffset; $branchOffset -lt $caseOffset; $branchOffset++) {
                    if (($Bytes[$branchOffset] -eq 0x74 -or $Bytes[$branchOffset] -eq 0x75) -and
                        ($branchOffset + 2) -le $mapperEndOffset) {
                        $branchOnEqual = ($Bytes[$branchOffset] -eq 0x74)
                        $branchTarget = [int64]$branchOffset + 2 +
                            (Read-X64SignedByte -Bytes $Bytes -Offset ($branchOffset + 1))
                    }
                    elseif ($Bytes[$branchOffset] -eq 0x0F -and ($branchOffset + 6) -le $mapperEndOffset -and
                        ($Bytes[$branchOffset + 1] -eq 0x84 -or $Bytes[$branchOffset + 1] -eq 0x85)) {
                        $branchOnEqual = ($Bytes[$branchOffset + 1] -eq 0x84)
                        $branchTarget = [int64]$branchOffset + 6 + [BitConverter]::ToInt32($Bytes, $branchOffset + 2)
                    }
                    else {
                        continue
                    }

                    if ($branchTarget -eq $caseOffset) {
                        $dispatches += [PSCustomObject]@{
                            Offset        = $branchOffset
                            BranchOnEqual = $branchOnEqual
                            MatchTaken    = $true
                        }
                    }
                }
            }
            else {
                if ($caseOffset -ge ($mapperOffset + 6) -and $Bytes[$caseOffset - 6] -eq 0x0F -and
                    ($Bytes[$caseOffset - 5] -eq 0x84 -or $Bytes[$caseOffset - 5] -eq 0x85)) {
                    $branchOffset = $caseOffset - 6
                    $branchOnEqual = ($Bytes[$caseOffset - 5] -eq 0x84)
                    $branchTarget = [int64]$caseOffset + [BitConverter]::ToInt32($Bytes, $caseOffset - 4)
                }
                elseif ($caseOffset -ge ($mapperOffset + 2) -and
                    ($Bytes[$caseOffset - 2] -eq 0x74 -or $Bytes[$caseOffset - 2] -eq 0x75)) {
                    $branchOffset = $caseOffset - 2
                    $branchOnEqual = ($Bytes[$caseOffset - 2] -eq 0x74)
                    $branchTarget = [int64]$caseOffset +
                        (Read-X64SignedByte -Bytes $Bytes -Offset ($caseOffset - 1))
                }
                else {
                    continue
                }

                if ($branchTarget -lt $mapperOffset -or $branchTarget -ge $mapperEndOffset -or $branchTarget -eq $caseOffset) {
                    continue
                }
                $dispatches += [PSCustomObject]@{
                    Offset        = $branchOffset
                    BranchOnEqual = $branchOnEqual
                    MatchTaken    = $false
                }
            }

            foreach ($dispatch in $dispatches) {
                $branchOffset = [int]$dispatch.Offset
                $selectsEquality = ($dispatch.BranchOnEqual -eq $dispatch.MatchTaken)
                if ($selectsEquality -and $branchOffset -ge ($mapperOffset + 4) -and
                    [BinaryScannerV3]::MatchBytes($Bytes, $branchOffset - 4, $cmpR8d8)) {
                    $enumValue = [int64](Read-X64SignedByte -Bytes $Bytes -Offset ($branchOffset - 1))
                    if ($enumValue -gt 0 -and $enumValue -le 0x3FF) {
                        $enumValues['{0:X}' -f $enumValue] = [uint32]$enumValue
                    }
                }
                if ($selectsEquality -and $branchOffset -ge ($mapperOffset + 7) -and
                    [BinaryScannerV3]::MatchBytes($Bytes, $branchOffset - 7, $cmpR8d32)) {
                    $enumValue = [BitConverter]::ToUInt32($Bytes, $branchOffset - 4)
                    if ($enumValue -gt 0 -and $enumValue -le 0x3FF) {
                        $enumValues['{0:X}' -f $enumValue] = $enumValue
                    }
                }

                $sequenceStart = [Math]::Max($mapperOffset, $branchOffset - 0x100)
                for ($candidateOffset = $sequenceStart; $candidateOffset -lt $branchOffset; $candidateOffset++) {
                    if (-not [BinaryScannerV3]::MatchBytes($Bytes, $candidateOffset, $movEcxR8d)) {
                        continue
                    }
                    $sequenceEnums = @(Get-X64BlockSlotsMapperSequenceEnum `
                            -Bytes $Bytes `
                            -SequenceOffset $candidateOffset `
                            -BranchOffset $branchOffset `
                            -MatchTaken $dispatch.MatchTaken)
                    foreach ($enumValue in $sequenceEnums) {
                        $enumValues['{0:X}' -f [uint32]$enumValue] = [uint32]$enumValue
                    }
                }
            }
        }
    }

    if ($enumValues.Count -ne 1) {
        throw "Expected one slot_is_disabled enum value, found $($enumValues.Count)"
    }
    return [uint32](@($enumValues.Values)[0])
}

function Get-X64BlockSlotsPredicateInfo {
    param(
        [byte[]]$Bytes,
        [object]$PeInfo,
        [object]$TextSection,
        [object]$RuntimeFunctions,
        [int64]$TargetRva
    )

    try {
        $runtimeRange = [BinaryScannerV3]::FindFunctionRange(
            $Bytes,
            [int]$RuntimeFunctions.RawPtr,
            [int]$RuntimeFunctions.RawSize,
            $TargetRva,
            [int64]$TextSection.VirtualAddress,
            [Math]::Max([int64]$TextSection.VirtualSize, [int64]$TextSection.RawSize)
        )
        if ($runtimeRange.Length -ne 2 -or [int64]$runtimeRange[0] -ne $TargetRva) {
            return $null
        }

        $functionSize = [int64]$runtimeRange[1] - [int64]$runtimeRange[0]
        if ($functionSize -lt 0x20 -or $functionSize -gt 0x100) {
            return $null
        }

        $functionOffset = Get-PEOffsetFromRva -Sections $PeInfo.Sections -Rva $TargetRva
        if ($null -eq $functionOffset) {
            return $null
        }

        $functionOffset = [int64]$functionOffset
        $functionEndOffset = $functionOffset + $functionSize
        $textStart = [int64]$TextSection.RawPtr
        $textEnd = $textStart + [int64]$TextSection.RawSize
        if ($functionOffset -lt $textStart -or $functionEndOffset -gt $textEnd -or $functionEndOffset -gt $Bytes.Length) {
            return $null
        }

        $codeOffset = [int]$functionOffset
        $endbr64 = Convert-HexStringToBytes 'F3 0F 1E FA'
        if ([BinaryScannerV3]::MatchBytes($Bytes, $codeOffset, $endbr64)) {
            $codeOffset += $endbr64.Length
        }

        $prologue = Convert-HexStringToBytes '48 89 5C 24 00 57 48 83 EC 00 32 DB'
        $prologueMask = Convert-HexStringToBytes 'FF FF FF FF 00 FF FF FF FF 00 FF FF'
        if (-not [BinaryScannerV3]::MatchMaskedBytes($Bytes, $codeOffset, $prologue, $prologueMask)) {
            return $null
        }

        $saveDisplacement = [int]$Bytes[$codeOffset + 4]
        $stackFrame = [int]$Bytes[$codeOffset + 9]
        if ($stackFrame -le 0) {
            return $null
        }

        $patchOffset = $codeOffset + $prologue.Length
        $originalPatch = Convert-HexStringToBytes '48 8B F9'
        if ([BinaryScannerV3]::MatchBytes($Bytes, $patchOffset, $originalPatch)) {
            $state = 'Original'
        }
        elseif (($patchOffset + 3) -le $functionEndOffset -and $Bytes[$patchOffset] -eq 0xEB -and $Bytes[$patchOffset + 2] -eq 0x90) {
            $state = 'Patched'
        }
        else {
            return $null
        }

        $cursor = $patchOffset + 3
        $flagField = Read-X64BlockSlotsField -Bytes $Bytes -Offset $cursor -Kind CmpRcxBl
        $cursor = $flagField.NextOffset
        $toGate = Read-X64RelativeBranch -Bytes $Bytes -Offset $cursor -Kind Je -Limit ([int]$functionEndOffset)
        $cursor = $toGate.NextOffset
        $valueField = Read-X64BlockSlotsField -Bytes $Bytes -Offset $cursor -Kind MovAlRcx
        $cursor = $valueField.NextOffset
        $toEpilogue = Read-X64RelativeBranch -Bytes $Bytes -Offset $cursor -Kind Jmp -Limit ([int]$functionEndOffset)
        $cursor = $toEpilogue.NextOffset

        if ($toGate.TargetOffset -ne $cursor) {
            return $null
        }

        $gateField = Read-X64BlockSlotsField -Bytes $Bytes -Offset $cursor -Kind CmpRcxBl
        $cursor = $gateField.NextOffset
        $gateToFalse = Read-X64RelativeBranch -Bytes $Bytes -Offset $cursor -Kind Je -Limit ([int]$functionEndOffset)
        $cursor = $gateToFalse.NextOffset

        if (($cursor + 5) -gt $functionEndOffset -or $Bytes[$cursor] -ne 0xE8) {
            return $null
        }
        $helperCallRva = Get-PERvaFromOffset -Sections $PeInfo.Sections -Offset $cursor
        if ($null -eq $helperCallRva) {
            return $null
        }
        $helperTargetRva = [int64]$helperCallRva + 5 + [BitConverter]::ToInt32($Bytes, $cursor + 1)
        $textRvaEnd = [int64]$TextSection.VirtualAddress + [Math]::Max([int64]$TextSection.VirtualSize, [int64]$TextSection.RawSize)
        if ($helperTargetRva -lt [int64]$TextSection.VirtualAddress -or $helperTargetRva -ge $textRvaEnd) {
            return $null
        }
        $cursor += 5

        $testAl = Convert-HexStringToBytes '84 C0'
        if (-not [BinaryScannerV3]::MatchBytes($Bytes, $cursor, $testAl)) {
            return $null
        }
        $cursor += $testAl.Length
        $helperToTrue = Read-X64RelativeBranch -Bytes $Bytes -Offset $cursor -Kind Jne -Limit ([int]$functionEndOffset)
        $cursor = $helperToTrue.NextOffset

        $fallbackField = Read-X64BlockSlotsField -Bytes $Bytes -Offset $cursor -Kind CmpRdiBl
        $cursor = $fallbackField.NextOffset
        $fallbackToFalse = Read-X64RelativeBranch -Bytes $Bytes -Offset $cursor -Kind Je -Limit ([int]$functionEndOffset)
        $cursor = $fallbackToFalse.NextOffset

        $setTrueOffset = $cursor
        if ($helperToTrue.TargetOffset -ne $setTrueOffset -or
            -not [BinaryScannerV3]::MatchBytes($Bytes, $setTrueOffset, (Convert-HexStringToBytes 'B3 01'))) {
            return $null
        }
        $cursor += 2

        $returnFalseOffset = $cursor
        if ($gateToFalse.TargetOffset -ne $returnFalseOffset -or $fallbackToFalse.TargetOffset -ne $returnFalseOffset -or
            -not [BinaryScannerV3]::MatchBytes($Bytes, $returnFalseOffset, (Convert-HexStringToBytes '8A C3'))) {
            return $null
        }
        $cursor += 2

        $epilogueOffset = $cursor
        if ($toEpilogue.TargetOffset -ne $epilogueOffset) {
            return $null
        }

        $epilogue = Convert-HexStringToBytes '48 8B 5C 24 00 48 83 C4 00 5F C3'
        $epilogueMask = Convert-HexStringToBytes 'FF FF FF FF 00 FF FF FF 00 FF FF'
        if (-not [BinaryScannerV3]::MatchMaskedBytes($Bytes, $epilogueOffset, $epilogue, $epilogueMask)) {
            return $null
        }

        $restoreDisplacement = [int]$Bytes[$epilogueOffset + 4]
        $restoreFrame = [int]$Bytes[$epilogueOffset + 8]
        if ($restoreFrame -ne $stackFrame -or $restoreDisplacement -ne ($saveDisplacement + $stackFrame + 8)) {
            return $null
        }
        $cursor += $epilogue.Length

        $tailLength = [int64]$functionEndOffset - $cursor
        if ($tailLength -lt 0 -or $tailLength -gt 16) {
            return $null
        }
        for ($i = $cursor; $i -lt $functionEndOffset; $i++) {
            if ($Bytes[$i] -ne 0x90 -and $Bytes[$i] -ne 0xCC) {
                return $null
            }
        }

        $jumpDisplacement = [int64]$returnFalseOffset - ([int64]$patchOffset + 2)
        if ($jumpDisplacement -lt 0 -or $jumpDisplacement -gt 0x7F) {
            return $null
        }
        $patchedBytes = [byte[]]@(0xEB, [byte]$jumpDisplacement, 0x90)
        if ($state -eq 'Patched' -and -not [BinaryScannerV3]::MatchBytes($Bytes, $patchOffset, $patchedBytes)) {
            return $null
        }

        return [PSCustomObject]@{
            PredicateRva    = $TargetRva
            FunctionOffset  = [int64]$functionOffset
            FunctionEnd     = [int64]$functionEndOffset
            PatchOffset     = [int64]$patchOffset
            ReturnOffset    = [int64]$returnFalseOffset
            OriginalBytes   = $originalPatch
            PatchedBytes    = $patchedBytes
            State           = $state
        }
    }
    catch {
        return $null
    }
}

function Find-X64BlockSlotsBinaryPatchLocation {
    param(
        [byte[]]$Bytes,
        [object]$PeInfo
    )

    $context = Get-BinaryPatchContext -PeInfo $PeInfo
    $text = $context.Text
    $runtimeFunctions = $context.RuntimeFunctions
    $anchor = Get-UniqueBinaryAnchor -Bytes $Bytes -PeInfo $PeInfo -Text 'slot_is_disabled' -NullTerminated

    $anchorRefs = @([BinaryScannerV3]::FindRipLeaRefs(
        $Bytes,
        [int]$text.RawPtr,
        [int]$text.RawSize,
        [int64]$anchor.Rva,
        $context.RawPtrs,
        $context.RawSizes,
        $context.VirtualAddresses
    ) | Select-Object -Unique)
    if ($anchorRefs.Count -eq 0) {
        throw 'slot_is_disabled code reference was not found'
    }

    $anchorFunctions = @{}
    foreach ($anchorRef in $anchorRefs) {
        $anchorRefRva = Get-PERvaFromOffset -Sections $PeInfo.Sections -Offset ([int64]$anchorRef)
        if ($null -eq $anchorRefRva) {
            throw 'slot_is_disabled reference RVA was not found'
        }
        $anchorFunction = Get-BinaryPatchFunctionRange `
            -Bytes $Bytes `
            -PeInfo $PeInfo `
            -Context $context `
            -Rva ([int64]$anchorRefRva)
        if ($anchorFunction.Length -ne 2) {
            throw 'slot_is_disabled mapper function was not found'
        }
        $anchorFunctionSize = [int64]$anchorFunction[1] - [int64]$anchorFunction[0]
        if ($anchorFunctionSize -lt 0x100 -or $anchorFunctionSize -gt 0x4000) {
            throw 'Unexpected slot_is_disabled mapper function size'
        }
        $anchorFunctions['{0:X}' -f [int64]$anchorFunction[0]] = [PSCustomObject]@{
            StartRva = [int64]$anchorFunction[0]
            EndRva   = [int64]$anchorFunction[1]
        }
    }
    if ($anchorFunctions.Count -ne 1) {
        throw "Expected one slot_is_disabled mapper function, found $($anchorFunctions.Count)"
    }

    $mapperFunction = @($anchorFunctions.Values)[0]
    $slotDisabledEnum = Get-X64BlockSlotsMapperEnumValue `
        -Bytes $Bytes `
        -PeInfo $PeInfo `
        -MapperStartRva $mapperFunction.StartRva `
        -MapperEndRva $mapperFunction.EndRva `
        -AnchorRefs $anchorRefs

    $callPatterns = @(
        [PSCustomObject]@{
            Pattern      = Convert-HexStringToBytes 'E8 00 00 00 00 84 C0 75 00 BA 00 00 00 00'
            Mask         = Convert-HexStringToBytes 'FF 00 00 00 00 FF FF FF 00 FF 00 00 00 00'
            BranchOffset = 7
            EnumOffset   = 10
        },
        [PSCustomObject]@{
            Pattern      = Convert-HexStringToBytes 'E8 00 00 00 00 84 C0 0F 85 00 00 00 00 BA 00 00 00 00'
            Mask         = Convert-HexStringToBytes 'FF 00 00 00 00 FF FF FF FF 00 00 00 00 FF 00 00 00 00'
            BranchOffset = 7
            EnumOffset   = 14
        }
    )

    $textStart = [int]$text.RawPtr
    $textEnd = [int64]$text.RawPtr + [int64]$text.RawSize
    $validatedTargets = @{}

    foreach ($callPattern in $callPatterns) {
        $searchOffset = $textStart
        while ($searchOffset -lt $textEnd) {
            $callOffset = [BinaryScannerV3]::FindMaskedBytes(
                $Bytes,
                $callPattern.Pattern,
                $callPattern.Mask,
                $searchOffset,
                [int]($textEnd - $searchOffset)
            )
            if ($callOffset -lt 0) {
                break
            }
            $searchOffset = $callOffset + 1

            try {
                $enumValue = [BitConverter]::ToUInt32($Bytes, $callOffset + $callPattern.EnumOffset)
                if ($enumValue -ne $slotDisabledEnum) {
                    continue
                }

                $callerRva = Get-PERvaFromOffset -Sections $PeInfo.Sections -Offset $callOffset
                $callNextRva = Get-PERvaFromOffset -Sections $PeInfo.Sections -Offset ($callOffset + 5)
                if ($null -eq $callerRva -or $null -eq $callNextRva) {
                    continue
                }

                $callerRange = Get-BinaryPatchFunctionRange `
                    -Bytes $Bytes `
                    -PeInfo $PeInfo `
                    -Context $context `
                    -Rva ([int64]$callerRva)
                if ($callerRange.Length -ne 2) {
                    continue
                }

                $callerBranch = Read-X64RelativeBranch `
                    -Bytes $Bytes `
                    -Offset ($callOffset + $callPattern.BranchOffset) `
                    -Kind Jne `
                    -Limit ([int]$textEnd)
                $branchTargetRva = Get-PERvaFromOffset -Sections $PeInfo.Sections -Offset $callerBranch.TargetOffset
                if ($null -eq $branchTargetRva -or $branchTargetRva -lt [int64]$callerRange[0] -or
                    $branchTargetRva -ge [int64]$callerRange[1]) {
                    continue
                }

                $targetRva = [int64]$callNextRva + [BitConverter]::ToInt32($Bytes, $callOffset + 1)
                $predicate = Get-X64BlockSlotsPredicateInfo `
                    -Bytes $Bytes `
                    -PeInfo $PeInfo `
                    -TextSection $text `
                    -RuntimeFunctions $runtimeFunctions `
                    -TargetRva $targetRva
                if ($null -eq $predicate) {
                    continue
                }

                $key = '{0:X}' -f $targetRva
                if (-not $validatedTargets.ContainsKey($key)) {
                    $validatedTargets[$key] = [PSCustomObject]@{
                        Predicate   = $predicate
                        CallerCount = 1
                        CallerOffset = [int64]$callOffset
                        EnumValue   = [uint32]$enumValue
                    }
                }
                else {
                    $validatedTargets[$key].CallerCount++
                }
            }
            catch {
                continue
            }
        }
    }

    if ($validatedTargets.Count -eq 0) {
        throw 'block_slots semantic function was not found'
    }
    if ($validatedTargets.Count -ne 1) {
        throw "Expected one block_slots semantic function, found $($validatedTargets.Count)"
    }

    $match = @($validatedTargets.Values)[0]
    return [PSCustomObject]@{
        Architecture  = 'x64'
        PredicateRva  = $match.Predicate.PredicateRva
        FunctionOffset = $match.Predicate.FunctionOffset
        FunctionEnd   = $match.Predicate.FunctionEnd
        PatchOffset   = $match.Predicate.PatchOffset
        ReturnOffset  = $match.Predicate.ReturnOffset
        OriginalBytes = $match.Predicate.OriginalBytes
        PatchedBytes  = $match.Predicate.PatchedBytes
        State         = $match.Predicate.State
        CallerOffset  = $match.CallerOffset
        CallerCount   = $match.CallerCount
        EnumValue     = $match.EnumValue
    }
}

function Get-Arm64BlockSlotsMapperEnumValue {
    param(
        [byte[]]$Bytes,
        [object]$PeInfo,
        [int64]$MapperStartRva,
        [int64]$MapperEndRva,
        [int[]]$AnchorRefs
    )

    $mapperOffset = Get-PEOffsetFromRva -Sections $PeInfo.Sections -Rva $MapperStartRva
    if ($null -eq $mapperOffset) {
        throw 'slot_is_disabled mapper offset was not found'
    }
    $mapperEndOffset = [int64]$mapperOffset + ($MapperEndRva - $MapperStartRva)
    if ($mapperEndOffset -le $mapperOffset -or $mapperEndOffset -gt $Bytes.Length) {
        throw 'slot_is_disabled mapper range is invalid'
    }

    $dispatchers = @()
    $searchEnd = [Math]::Min([int64]$mapperOffset + 0x80, $mapperEndOffset - 28)
    for ($offset = [int64]$mapperOffset; $offset -le $searchEnd; $offset += 4) {
        $cmp = Read-Arm64Instruction -Bytes $Bytes -Offset $offset
        $branch = Read-Arm64Instruction -Bytes $Bytes -Offset ($offset + 4)
        $tableAdr = Read-Arm64Instruction -Bytes $Bytes -Offset ($offset + 8)
        $load = Read-Arm64Instruction -Bytes $Bytes -Offset ($offset + 12)
        $baseAdr = Read-Arm64Instruction -Bytes $Bytes -Offset ($offset + 16)
        $add = Read-Arm64Instruction -Bytes $Bytes -Offset ($offset + 20)
        $dispatch = Read-Arm64Instruction -Bytes $Bytes -Offset ($offset + 24)

        if (($cmp -band [uint32]0xFFC003FFL) -ne [uint32]0x7100005F) { continue }
        if (($branch -band [uint32]0xFF00001FL) -ne [uint32]0x54000008) { continue }
        if (($tableAdr -band [uint32]0x9F00001FL) -ne [uint32]0x10000009) { continue }
        if ($load -ne [uint32]0xB8A25928L) { continue }
        if (($baseAdr -band [uint32]0x9F00001FL) -ne [uint32]0x10000009) { continue }
        if ($add -ne [uint32]0x8B080928L -or $dispatch -ne [uint32]0xD61F0100L) { continue }

        $dispatcherRva = Get-PERvaFromOffset -Sections $PeInfo.Sections -Offset $offset
        if ($null -eq $dispatcherRva) { continue }
        $dispatchers += [PSCustomObject]@{
            EnumLimit = [int](($cmp -shr 10) -band 0xFFF)
            TableRva  = Get-Arm64AdrTargetRva -Instruction $tableAdr -InstructionRva ($dispatcherRva + 8)
            BaseRva   = Get-Arm64AdrTargetRva -Instruction $baseAdr -InstructionRva ($dispatcherRva + 16)
        }
    }

    if ($dispatchers.Count -ne 1) {
        throw "Expected one ARM64 slot mapper dispatcher, found $($dispatchers.Count)"
    }

    $anchorRvas = @{}
    foreach ($anchorRef in $AnchorRefs) {
        $anchorRefRva = Get-PERvaFromOffset -Sections $PeInfo.Sections -Offset $anchorRef
        if ($null -ne $anchorRefRva) {
            $anchorRvas['{0:X}' -f [int64]$anchorRefRva] = $true
        }
    }

    $enumValues = @{}
    $dispatcher = $dispatchers[0]
    $tableOffset = Get-PEOffsetFromRva -Sections $PeInfo.Sections -Rva $dispatcher.TableRva
    if ($null -eq $tableOffset) {
        throw 'slot_is_disabled jump table offset was not found'
    }
    $tableSection = $PeInfo.Sections | Where-Object {
        $dispatcher.TableRva -ge $_.VirtualAddress -and
        $dispatcher.TableRva -lt ($_.VirtualAddress + $_.RawSize)
    } | Select-Object -First 1
    $tableEndOffset = [int64]$tableOffset + (([int64]$dispatcher.EnumLimit + 1) * 4)
    if (-not $tableSection -or $tableEndOffset -gt ([int64]$tableSection.RawPtr + $tableSection.RawSize) -or
        $tableEndOffset -gt $Bytes.Length) {
        throw 'slot_is_disabled jump table range is invalid'
    }
    for ($enumValue = 0; $enumValue -le $dispatcher.EnumLimit; $enumValue++) {
        $entryOffset = [int64]$tableOffset + ($enumValue * 4)
        $relative = [BitConverter]::ToInt32($Bytes, [int]$entryOffset)
        $targetRva = [int64]$dispatcher.BaseRva + ([int64]$relative * 4)
        if ($anchorRvas.ContainsKey(('{0:X}' -f $targetRva))) {
            $enumValues['{0:X}' -f $enumValue] = [uint32]$enumValue
        }
    }

    if ($enumValues.Count -ne 1) {
        throw "Expected one ARM64 slot_is_disabled enum value, found $($enumValues.Count)"
    }
    return [uint32](@($enumValues.Values)[0])
}

function Get-Arm64BlockSlotsPredicateInfo {
    param(
        [byte[]]$Bytes,
        [object]$PeInfo,
        [object]$Context,
        [int64]$TargetRva
    )

    try {
        $functionRange = Get-BinaryPatchFunctionRange -Bytes $Bytes -PeInfo $PeInfo -Context $Context -Rva $TargetRva
        if ($functionRange.Length -ne 2 -or [int64]$functionRange[0] -ne $TargetRva -or
            ([int64]$functionRange[1] - [int64]$functionRange[0]) -ne 0x54) {
            return $null
        }

        $functionOffset = Get-PEOffsetFromRva -Sections $PeInfo.Sections -Rva $TargetRva
        if ($null -eq $functionOffset -or $functionOffset + 0x54 -gt $Bytes.Length) {
            return $null
        }
        $functionOffset = [int64]$functionOffset
        $instruction = @()
        for ($relative = 0; $relative -lt 0x54; $relative += 4) {
            $instruction += Read-Arm64Instruction -Bytes $Bytes -Offset ($functionOffset + $relative)
        }

        if ($instruction[0] -ne [uint32]0xF81F0FF3L -or $instruction[1] -ne [uint32]0xA9BF7BFDL -or
            $instruction[2] -ne [uint32]0x910003FDL) {
            return $null
        }

        $returnFalseRva = $TargetRva + 0x44
        $returnFalseOffset = $functionOffset + 0x44
        $patchOffset = $functionOffset + 0x0C
        $originalBytes = Convert-HexStringToBytes 'F3 03 00 AA'
        $patchedBytes = New-Arm64BranchBytes -InstructionRva ($TargetRva + 0x0C) -TargetRva $returnFalseRva
        if ([BinaryScannerV3]::MatchBytes($Bytes, [int]$patchOffset, $originalBytes)) {
            $state = 'Original'
        }
        elseif ([BinaryScannerV3]::MatchBytes($Bytes, [int]$patchOffset, $patchedBytes)) {
            $state = 'Patched'
        }
        else {
            return $null
        }

        if (($instruction[4] -band [uint32]0xFFC003FFL) -ne [uint32]0x39400268 -or
            ($instruction[6] -band [uint32]0xFFC003FFL) -ne [uint32]0x39400260 -or
            ($instruction[8] -band [uint32]0xFFC003FFL) -ne [uint32]0x39400268 -or
            ($instruction[13] -band [uint32]0xFFC003FFL) -ne [uint32]0x39400268) {
            return $null
        }
        if ((Get-Arm64CbzW8TargetRva -Instruction $instruction[5] -InstructionRva ($TargetRva + 0x14)) -ne ($TargetRva + 0x20) -or
            (Get-Arm64BranchTargetRva -Instruction $instruction[7] -InstructionRva ($TargetRva + 0x1C) -Kind B) -ne ($TargetRva + 0x48) -or
            (Get-Arm64CbzW8TargetRva -Instruction $instruction[9] -InstructionRva ($TargetRva + 0x24)) -ne $returnFalseRva -or
            (Get-Arm64BranchTargetRva -Instruction $instruction[12] -InstructionRva ($TargetRva + 0x30) -Kind TbnzW0Bit0) -ne ($TargetRva + 0x3C) -or
            (Get-Arm64CbzW8TargetRva -Instruction $instruction[14] -InstructionRva ($TargetRva + 0x38)) -ne $returnFalseRva -or
            (Get-Arm64BranchTargetRva -Instruction $instruction[16] -InstructionRva ($TargetRva + 0x40) -Kind B) -ne ($TargetRva + 0x48)) {
            return $null
        }
        if ($instruction[10] -ne [uint32]0xAA1303E0L -or
            ($instruction[11] -band [uint32]0xFC000000L) -ne [uint32]0x94000000L -or
            $instruction[15] -ne [uint32]0x52800020L -or $instruction[17] -ne [uint32]0x52800000L -or
            $instruction[18] -ne [uint32]0xA8C17BFDL -or $instruction[19] -ne [uint32]0xF84107F3L -or
            $instruction[20] -ne [uint32]0xD65F03C0L) {
            return $null
        }

        $helperTargetRva = Get-Arm64BranchTargetRva -Instruction $instruction[11] -InstructionRva ($TargetRva + 0x2C) -Kind BL
        $textRvaEnd = [int64]$Context.Text.VirtualAddress + [Math]::Max([int64]$Context.Text.VirtualSize, [int64]$Context.Text.RawSize)
        if ($helperTargetRva -lt [int64]$Context.Text.VirtualAddress -or $helperTargetRva -ge $textRvaEnd) {
            return $null
        }

        return [PSCustomObject]@{
            PredicateRva  = $TargetRva
            FunctionOffset = $functionOffset
            FunctionEnd   = $functionOffset + 0x54
            PatchOffset   = $patchOffset
            ReturnOffset  = $returnFalseOffset
            OriginalBytes = $originalBytes
            PatchedBytes  = $patchedBytes
            State         = $state
        }
    }
    catch {
        return $null
    }
}

function Find-Arm64BlockSlotsBinaryPatchLocation {
    param(
        [byte[]]$Bytes,
        [object]$PeInfo
    )

    $context = Get-BinaryPatchContext -PeInfo $PeInfo
    $anchor = Get-UniqueBinaryAnchor -Bytes $Bytes -PeInfo $PeInfo -Text 'slot_is_disabled' -NullTerminated
    $anchorRefs = @([BinaryScannerV3]::FindXrefArm64(
        $Bytes,
        [uint64]$anchor.Rva,
        [uint64]$context.Text.VirtualAddress,
        [uint32]$context.Text.RawPtr,
        [uint32]$context.Text.RawSize
    ) | Select-Object -Unique)
    if ($anchorRefs.Count -eq 0) {
        throw 'slot_is_disabled ARM64 code reference was not found'
    }

    $mapperFunctions = @{}
    foreach ($anchorRef in $anchorRefs) {
        $anchorRefRva = Get-PERvaFromOffset -Sections $PeInfo.Sections -Offset $anchorRef
        if ($null -eq $anchorRefRva) { continue }
        $range = Get-BinaryPatchFunctionRange -Bytes $Bytes -PeInfo $PeInfo -Context $context -Rva $anchorRefRva
        if ($range.Length -ne 2) { continue }
        $size = [int64]$range[1] - [int64]$range[0]
        if ($size -lt 0x100 -or $size -gt 0x4000) { continue }
        $mapperFunctions['{0:X}' -f [int64]$range[0]] = [PSCustomObject]@{
            StartRva = [int64]$range[0]
            EndRva   = [int64]$range[1]
        }
    }
    if ($mapperFunctions.Count -ne 1) {
        throw "Expected one ARM64 slot mapper function, found $($mapperFunctions.Count)"
    }

    $mapper = @($mapperFunctions.Values)[0]
    $enumValue = Get-Arm64BlockSlotsMapperEnumValue `
        -Bytes $Bytes `
        -PeInfo $PeInfo `
        -MapperStartRva $mapper.StartRva `
        -MapperEndRva $mapper.EndRva `
        -AnchorRefs $anchorRefs

    $callers = @([BinaryScannerV3]::FindArm64BlockSlotsCallers(
        $Bytes,
        [int]$context.Text.RawPtr,
        [int]$context.Text.RawSize,
        [uint32]$enumValue
    ))
    $validatedTargets = @{}
    foreach ($callerOffset in $callers) {
        try {
            $callerRva = Get-PERvaFromOffset -Sections $PeInfo.Sections -Offset $callerOffset
            if ($null -eq $callerRva) { continue }
            $callerRange = Get-BinaryPatchFunctionRange -Bytes $Bytes -PeInfo $PeInfo -Context $context -Rva $callerRva
            if ($callerRange.Length -ne 2 -or ([int64]$callerRva + 12) -gt [int64]$callerRange[1]) { continue }

            $branch = Read-Arm64Instruction -Bytes $Bytes -Offset ($callerOffset + 4)
            $branchTargetRva = Get-Arm64BranchTargetRva -Instruction $branch -InstructionRva ($callerRva + 4) -Kind TbnzW0Bit0
            if ($branchTargetRva -lt [int64]$callerRange[0] -or $branchTargetRva -ge [int64]$callerRange[1]) { continue }

            $call = Read-Arm64Instruction -Bytes $Bytes -Offset $callerOffset
            $targetRva = Get-Arm64BranchTargetRva -Instruction $call -InstructionRva $callerRva -Kind BL
            $predicate = Get-Arm64BlockSlotsPredicateInfo -Bytes $Bytes -PeInfo $PeInfo -Context $context -TargetRva $targetRva
            if ($null -eq $predicate) { continue }

            $key = '{0:X}' -f $targetRva
            if (-not $validatedTargets.ContainsKey($key)) {
                $validatedTargets[$key] = [PSCustomObject]@{
                    Predicate   = $predicate
                    CallerCount = 1
                    CallerOffset = [int64]$callerOffset
                }
            }
            else {
                $validatedTargets[$key].CallerCount++
            }
        }
        catch {
            continue
        }
    }

    if ($validatedTargets.Count -eq 0) {
        throw 'ARM64 block_slots semantic function was not found'
    }
    if ($validatedTargets.Count -ne 1) {
        throw "Expected one ARM64 block_slots semantic function, found $($validatedTargets.Count)"
    }

    $match = @($validatedTargets.Values)[0]
    return [PSCustomObject]@{
        Architecture  = 'ARM64'
        PredicateRva  = $match.Predicate.PredicateRva
        FunctionOffset = $match.Predicate.FunctionOffset
        FunctionEnd   = $match.Predicate.FunctionEnd
        PatchOffset   = $match.Predicate.PatchOffset
        ReturnOffset  = $match.Predicate.ReturnOffset
        OriginalBytes = $match.Predicate.OriginalBytes
        PatchedBytes  = $match.Predicate.PatchedBytes
        State         = $match.Predicate.State
        CallerOffset  = $match.CallerOffset
        CallerCount   = $match.CallerCount
        EnumValue     = $enumValue
    }
}

function Find-BlockSlotsBinaryPatchLocation {
    param(
        [byte[]]$Bytes,
        [object]$PeInfo
    )

    switch ($PeInfo.Architecture) {
        'x64' { return Find-X64BlockSlotsBinaryPatchLocation -Bytes $Bytes -PeInfo $PeInfo }
        'ARM64' { return Find-Arm64BlockSlotsBinaryPatchLocation -Bytes $Bytes -PeInfo $PeInfo }
        default { throw "Architecture $($PeInfo.Architecture) is not supported for block_slots patch" }
    }
}

function Invoke-VerifiedBinaryPatch {
    param(
        [string]$FilePath,
        [string]$PatchName,
        [scriptblock]$Locator,
        [scriptblock]$DescribeLocation
    )

    $rollbackFailed = $false
    try {
        Initialize-BinaryScanner
        if (-not (Test-Path -LiteralPath $FilePath)) {
            throw 'File Spotify.dll not found'
        }

        $bytes = [System.IO.File]::ReadAllBytes($FilePath)
        $peInfo = Get-PEFileInfo -Bytes $bytes
        $location = & $Locator $bytes $peInfo
        $requiredProperties = @('Architecture', 'State', 'PatchOffset', 'OriginalBytes', 'PatchedBytes')
        $missingProperties = @($requiredProperties | Where-Object {
                $null -eq $location -or $null -eq $location.PSObject.Properties[$_]
            })
        if ($missingProperties.Count -ne 0 -or $location.Architecture -ne $peInfo.Architecture) {
            throw "Unexpected $PatchName locator result"
        }
        if ($null -eq $location.PatchedBytes -or $location.PatchedBytes.Length -eq 0 -or
            $location.PatchOffset -lt 0 -or $location.PatchOffset + $location.PatchedBytes.Length -gt $bytes.Length) {
            throw "$PatchName patch range is invalid"
        }
        if ($DescribeLocation) {
            & $DescribeLocation $location
        }

        if ($location.State -eq 'Patched') {
            if (-not [BinaryScannerV3]::MatchBytes($bytes, [int]$location.PatchOffset, $location.PatchedBytes)) {
                throw "Unexpected $PatchName patched state"
            }
            Write-Verbose ("{0} already patched at offset 0x{1:X}" -f $PatchName, $location.PatchOffset)
            return $true
        }
        if ($location.State -ne 'Original' -or
            $null -eq $location.OriginalBytes -or $location.OriginalBytes.Length -eq 0 -or
            $location.OriginalBytes.Length -ne $location.PatchedBytes.Length -or
            -not [BinaryScannerV3]::MatchBytes($bytes, [int]$location.PatchOffset, $location.OriginalBytes)) {
            throw "Unexpected $PatchName patch state"
        }

        $patchedFileBytes = [byte[]]$bytes.Clone()
        for ($i = 0; $i -lt $location.PatchedBytes.Length; $i++) {
            $patchedFileBytes[[int]$location.PatchOffset + $i] = $location.PatchedBytes[$i]
        }

        try {
            [System.IO.File]::WriteAllBytes($FilePath, $patchedFileBytes)
            $writtenBytes = [System.IO.File]::ReadAllBytes($FilePath)
            if ($writtenBytes.Length -ne $bytes.Length) {
                throw "$PatchName patch changed file length"
            }
            if (-not [BinaryScannerV3]::MatchBytes($writtenBytes, 0, $patchedFileBytes)) {
                throw "$PatchName patch changed unexpected bytes"
            }
            $writtenPeInfo = Get-PEFileInfo -Bytes $writtenBytes
            $writtenLocation = & $Locator $writtenBytes $writtenPeInfo
            if ($writtenPeInfo.Architecture -ne $peInfo.Architecture -or
                $writtenLocation.Architecture -ne $location.Architecture -or
                $writtenLocation.State -ne 'Patched' -or $writtenLocation.PatchOffset -ne $location.PatchOffset -or
                -not [BinaryScannerV3]::MatchBytes($writtenBytes, [int]$location.PatchOffset, $location.PatchedBytes)) {
                throw "$PatchName patch verification failed"
            }
        }
        catch {
            $patchError = $_.Exception.Message
            try {
                $restoredBytes = [System.IO.File]::ReadAllBytes($FilePath)
                if ($restoredBytes.Length -ne $bytes.Length -or -not [BinaryScannerV3]::MatchBytes($restoredBytes, 0, $bytes)) {
                    [System.IO.File]::WriteAllBytes($FilePath, $bytes)
                    $restoredBytes = [System.IO.File]::ReadAllBytes($FilePath)
                }
                if ($restoredBytes.Length -ne $bytes.Length -or -not [BinaryScannerV3]::MatchBytes($restoredBytes, 0, $bytes)) {
                    throw 'rollback verification failed'
                }
            }
            catch {
                $rollbackFailed = $true
                throw "$patchError; rollback failed: $($_.Exception.Message)"
            }
            throw $patchError
        }

        Write-Verbose ("{0} patched at offset 0x{1:X} with {2}" -f
            $PatchName,
            $location.PatchOffset,
            (($location.PatchedBytes | ForEach-Object { $_.ToString('X2') }) -join ' '))
        return $true
    }
    catch {
        if ($rollbackFailed) { throw }
        Write-Warning ("{0} patch was not applied: {1}" -f $PatchName, $_.Exception.Message)
        return $false
    }
}

function Set-BlockSlotsBinaryPatch {
    [CmdletBinding()]
    param (
        [string]$FilePath
    )

    return Invoke-VerifiedBinaryPatch `
        -FilePath $FilePath `
        -PatchName 'block_slots' `
        -Locator {
            param([byte[]]$Bytes, [object]$PeInfo)
            Find-BlockSlotsBinaryPatchLocation -Bytes $Bytes -PeInfo $PeInfo
        } `
        -DescribeLocation {
            param([object]$Location)
            Write-Verbose ("block_slots {0} predicate RVA 0x{1:X}, caller offset 0x{2:X}, enum 0x{3:X}" -f
                $Location.Architecture, $Location.PredicateRva, $Location.CallerOffset, $Location.EnumValue)
        }
}

function Find-X64CrossfadeEnabledBinaryPatchLocation {
    param(
        [byte[]]$Bytes,
        [object]$PeInfo
    )

    $context = Get-BinaryPatchContext -PeInfo $PeInfo
    $anchor = Get-UniqueBinaryAnchor -Bytes $Bytes -PeInfo $PeInfo -Text 'crossfade_enabled' -NullTerminated
    $anchorRefs = @([BinaryScannerV3]::FindRipLeaRefs(
        $Bytes,
        [int]$context.Text.RawPtr,
        [int]$context.Text.RawSize,
        [int64]$anchor.Rva,
        $context.RawPtrs,
        $context.RawSizes,
        $context.VirtualAddresses
    ) | Select-Object -Unique)
    if ($anchorRefs.Count -eq 0) {
        throw 'No x64 code reference to crossfade_enabled was found'
    }

    $getterFunctions = @{}
    foreach ($anchorRef in $anchorRefs) {
        $refRva = Get-PERvaFromOffset -Sections $PeInfo.Sections -Offset $anchorRef
        if ($null -eq $refRva) { continue }
        $range = Get-BinaryPatchFunctionRange -Bytes $Bytes -PeInfo $PeInfo -Context $context -Rva $refRva
        if ($range.Length -eq 2) {
            $getterFunctions['{0:X}' -f [int64]$range[0]] = [PSCustomObject]@{
                StartRva = [int64]$range[0]
                EndRva   = [int64]$range[1]
            }
        }
    }
    if ($getterFunctions.Count -ne 1) {
        throw "Expected one x64 crossfade getter function, found $($getterFunctions.Count)"
    }
    $getter = @($getterFunctions.Values)[0]

    $gateContextPattern = Convert-HexStringToBytes '48 8B 0B 00 00 00 00 00 88 45 00 48 8D 4D 00 E8'
    $gateContextMask = Convert-HexStringToBytes 'FF FF FF 00 00 00 00 00 FF FF 00 FF FF FF 00 FF'
    $hasGateContext = {
        param([int]$Candidate)

        if (-not [BinaryScannerV3]::MatchMaskedBytes($Bytes, $Candidate - 3, $gateContextPattern, $gateContextMask)) {
            return $false
        }
        $candidateRva = Get-PERvaFromOffset -Sections $PeInfo.Sections -Offset $Candidate
        if ($null -eq $candidateRva) { return $false }
        $callerRange = Get-BinaryPatchFunctionRange -Bytes $Bytes -PeInfo $PeInfo -Context $context -Rva $candidateRva
        return $callerRange.Length -eq 2 -and ([int64]$candidateRva - 3) -ge [int64]$callerRange[0] -and
            ([int64]$candidateRva + 13) -le [int64]$callerRange[1]
    }

    $originalCandidates = @([BinaryScannerV3]::FindCrossfadeGateCallsToRva(
        $Bytes,
        [int]$context.Text.RawPtr,
        [int]$context.Text.RawSize,
        $getter.StartRva,
        $context.RawPtrs,
        $context.RawSizes,
        $context.VirtualAddresses
    ) | Select-Object -Unique | Where-Object { & $hasGateContext ([int]$_) })

    $patchedBytes = Convert-HexStringToBytes 'B0 01 90 90 90'
    $patchedCandidates = @()
    $textEnd = [int64]$context.Text.RawPtr + [int64]$context.Text.RawSize
    $searchOffset = [int]$context.Text.RawPtr
    while ($searchOffset -lt $textEnd) {
        $candidate = [BinaryScannerV3]::FindBytes($Bytes, $patchedBytes, $searchOffset)
        if ($candidate -lt 0 -or $candidate + 13 -gt $textEnd) { break }
        $searchOffset = $candidate + 1
        if (-not (& $hasGateContext $candidate)) { continue }
        $patchedCandidates += [int]$candidate
    }

    if (($originalCandidates.Count + $patchedCandidates.Count) -ne 1) {
        throw "Expected one x64 crossfade gate call site, found $($originalCandidates.Count + $patchedCandidates.Count)"
    }

    if ($originalCandidates.Count -eq 1) {
        $patchOffset = [int64]$originalCandidates[0]
        $patchRva = Get-PERvaFromOffset -Sections $PeInfo.Sections -Offset $patchOffset
        if ($null -eq $patchRva) {
            throw 'x64 crossfade call site RVA was not found'
        }
        $displacement = [int64]$getter.StartRva - ([int64]$patchRva + 5)
        if ($displacement -lt [int32]::MinValue -or $displacement -gt [int32]::MaxValue) {
            throw 'x64 crossfade call target is out of range'
        }
        $originalBytes = [byte[]](@(0xE8) + [BitConverter]::GetBytes([int32]$displacement))
        if (-not [BinaryScannerV3]::MatchBytes($Bytes, [int]$patchOffset, $originalBytes)) {
            throw 'Unexpected x64 crossfade call bytes'
        }
        $state = 'Original'
    }
    else {
        $patchOffset = [int64]$patchedCandidates[0]
        $originalBytes = $null
        $state = 'Patched'
    }

    return [PSCustomObject]@{
        Architecture  = 'x64'
        FunctionRva   = $getter.StartRva
        PatchOffset   = $patchOffset
        OriginalBytes = $originalBytes
        PatchedBytes  = $patchedBytes
        State         = $state
        AnchorRefCount = $anchorRefs.Count
    }
}

function Find-Arm64CrossfadeEnabledBinaryPatchLocation {
    param(
        [byte[]]$Bytes,
        [object]$PeInfo
    )

    $context = Get-BinaryPatchContext -PeInfo $PeInfo
    $anchor = Get-UniqueBinaryAnchor -Bytes $Bytes -PeInfo $PeInfo -Text 'crossfade_enabled' -NullTerminated
    $anchorRefs = @([BinaryScannerV3]::FindXrefArm64(
        $Bytes,
        [uint64]$anchor.Rva,
        [uint64]$context.Text.VirtualAddress,
        [uint32]$context.Text.RawPtr,
        [uint32]$context.Text.RawSize
    ) | Select-Object -Unique)
    if ($anchorRefs.Count -eq 0) {
        throw 'No ARM64 code reference to crossfade_enabled was found'
    }

    $referenceFunctions = @{}
    foreach ($anchorRef in $anchorRefs) {
        $refRva = Get-PERvaFromOffset -Sections $PeInfo.Sections -Offset $anchorRef
        if ($null -eq $refRva) { continue }
        $range = Get-BinaryPatchFunctionRange -Bytes $Bytes -PeInfo $PeInfo -Context $context -Rva $refRva
        if ($range.Length -ne 2) { continue }
        $referenceFunctions['{0:X}' -f [int64]$anchorRef] = [PSCustomObject]@{
            StartRva = [int64]$range[0]
            EndRva   = [int64]$range[1]
        }
    }

    $patchedBytes = Convert-HexStringToBytes '20 00 80 52'
    $candidates = @{}
    foreach ($anchorRef in $anchorRefs) {
        $referenceKey = '{0:X}' -f [int64]$anchorRef
        if (-not $referenceFunctions.ContainsKey($referenceKey)) { continue }
        $function = $referenceFunctions[$referenceKey]
        $addOffset = [int64]$anchorRef + 4
        $addAnchor = Read-Arm64Instruction -Bytes $Bytes -Offset $addOffset
        if (($addAnchor -band [uint32]0xFFC0001FL) -ne [uint32]0x91000003L) { continue }

        $movKey = Read-Arm64Instruction -Bytes $Bytes -Offset ($addOffset + 4)
        $movOwner = Read-Arm64Instruction -Bytes $Bytes -Offset ($addOffset + 8)
        $movDefault = Read-Arm64Instruction -Bytes $Bytes -Offset ($addOffset + 12)
        $movResolver = Read-Arm64Instruction -Bytes $Bytes -Offset ($addOffset + 16)
        $addOtherKey = Read-Arm64Instruction -Bytes $Bytes -Offset ($addOffset + 20)
        $patchOffset = $addOffset + 24
        $patchInstruction = Read-Arm64Instruction -Bytes $Bytes -Offset $patchOffset
        $storeResult = Read-Arm64Instruction -Bytes $Bytes -Offset ($addOffset + 28)

        if ($movKey -ne [uint32]0xAA0003E2L -or
            ($movOwner -band [uint32]0xFFE0FFFFL) -ne [uint32]0xAA0003E0L -or
            $movDefault -ne [uint32]0x52800025L -or
            ($movResolver -band [uint32]0xFFE0FFFFL) -ne [uint32]0xAA0003E4L -or
            ($addOtherKey -band [uint32]0xFFC0001FL) -ne [uint32]0x91000001L -or
            ($storeResult -band [uint32]0xFFFFFFE0L) -ne [uint32]0x2A0003E0L) {
            continue
        }

        $patchRva = Get-PERvaFromOffset -Sections $PeInfo.Sections -Offset $patchOffset
        if ($null -eq $patchRva -or $patchRva -lt $function.StartRva -or $patchRva -ge $function.EndRva) { continue }
        if (($patchInstruction -band [uint32]0xFC000000L) -eq [uint32]0x94000000L) {
            $targetRva = Get-Arm64BranchTargetRva -Instruction $patchInstruction -InstructionRva $patchRva -Kind BL
            $textRvaEnd = [int64]$context.Text.VirtualAddress + [Math]::Max([int64]$context.Text.VirtualSize, [int64]$context.Text.RawSize)
            if ($targetRva -lt [int64]$context.Text.VirtualAddress -or $targetRva -ge $textRvaEnd) { continue }
            $state = 'Original'
            $originalBytes = [BitConverter]::GetBytes([uint32]$patchInstruction)
        }
        elseif ($patchInstruction -eq [uint32]0x52800020L) {
            $state = 'Patched'
            $originalBytes = $null
        }
        else {
            continue
        }

        $candidates['{0:X}' -f [int64]$patchOffset] = [PSCustomObject]@{
            FunctionRva  = $function.StartRva
            PatchOffset   = $patchOffset
            OriginalBytes = $originalBytes
            State         = $state
        }
    }

    if ($candidates.Count -ne 1) {
        throw "Expected one ARM64 crossfade boolean call site, found $($candidates.Count)"
    }
    $candidate = @($candidates.Values)[0]
    return [PSCustomObject]@{
        Architecture  = 'ARM64'
        FunctionRva   = $candidate.FunctionRva
        PatchOffset   = $candidate.PatchOffset
        OriginalBytes = $candidate.OriginalBytes
        PatchedBytes  = $patchedBytes
        State         = $candidate.State
        AnchorRefCount = $anchorRefs.Count
    }
}

function Find-CrossfadeEnabledBinaryPatchLocation {
    param(
        [byte[]]$Bytes,
        [object]$PeInfo
    )

    switch ($PeInfo.Architecture) {
        'x64' { return Find-X64CrossfadeEnabledBinaryPatchLocation -Bytes $Bytes -PeInfo $PeInfo }
        'ARM64' { return Find-Arm64CrossfadeEnabledBinaryPatchLocation -Bytes $Bytes -PeInfo $PeInfo }
        default { throw "Architecture $($PeInfo.Architecture) is not supported for crossfade_enabled patch" }
    }
}

function Set-CrossfadeEnabledBinaryPatch {
    [CmdletBinding()]
    param (
        [string]$FilePath
    )

    return Invoke-VerifiedBinaryPatch `
        -FilePath $FilePath `
        -PatchName 'crossfade_enabled' `
        -Locator {
            param([byte[]]$Bytes, [object]$PeInfo)
            Find-CrossfadeEnabledBinaryPatchLocation -Bytes $Bytes -PeInfo $PeInfo
        } `
        -DescribeLocation {
            param([object]$Location)
            Write-Verbose ("crossfade_enabled {0} function RVA 0x{1:X}, references {2}" -f
                $Location.Architecture, $Location.FunctionRva, $Location.AnchorRefCount)
        }
}

function Remove-Sign {
    [CmdletBinding()]
    param([string]$filePath)
    try {
        $bytes = [System.IO.File]::ReadAllBytes($filePath)
        $peInfo = Get-PEFileInfo -Bytes $bytes
        if ($peInfo.DataDirectoryOffset -eq $null) {
            Write-Warning "Unsupported architecture type ($($peInfo.MachineType.ToString('X'))) in file '$(Split-Path $filePath -Leaf)'."
            return $false
        }
        $dataDirectoryOffsetWithinOptionalHeader = $peInfo.DataDirectoryOffset
        $securityDirectoryIndex = 4
        $certificateTableEntryOffset = $peInfo.OptionalHeaderOffset + $dataDirectoryOffsetWithinOptionalHeader + ($securityDirectoryIndex * 8)
        if ($certificateTableEntryOffset + 8 -gt $bytes.Length) {
            Write-Warning "Could not find Data Directory in file '$(Split-Path $filePath -Leaf)'. Header is corrupted or has non-standard format."
            return $false
        }
        $rva = [System.BitConverter]::ToUInt32($bytes, $certificateTableEntryOffset)
        $size = [System.BitConverter]::ToUInt32($bytes, $certificateTableEntryOffset + 4)
        if ($rva -eq 0 -and $size -eq 0) {
            Write-Host "Signature in file '$(Split-Path $filePath -Leaf)' is already absent." -ForegroundColor Yellow
            return $true
        }
        for ($i = 0; $i -lt 8; $i++) {
            $bytes[$certificateTableEntryOffset + $i] = 0
        }
        [System.IO.File]::WriteAllBytes($filePath, $bytes)
        return $true
    }
    catch {
        if ($_.Exception.Message -eq 'Invalid PE file') {
            Write-Warning "File '$(Split-Path $filePath -Leaf)' is not a valid PE file."
        }
        else {
            Write-Error "Error processing file '$filePath': $_"
        }
        return $false
    }
}

function Remove-Signature-FromFiles {
    [CmdletBinding()]
    param([string[]]$fileNames)
    foreach ($fileName in $fileNames) {
        $fullPath = Join-Path -Path $spotifyDirectory -ChildPath $fileName
        if (-not (Test-Path $fullPath)) {
            Write-Error "File not found: $fullPath"
            Stop-Script
        }
        try {
            Write-Verbose "Processing file: $fileName"
            if (Remove-Sign -filePath $fullPath) {
                Write-Verbose "  -> Signature entry successfully zeroed."
            }
        }
        catch {
            Write-Error "Failed to process file '$fileName': $_"
            Stop-Script
        }
    }
}


function Update-ZipEntry {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [System.IO.Compression.ZipArchive]$archive,
        [Parameter(Mandatory)]
        [string]$entryName,
        [string]$newEntryName = $null,
        [string]$prepend = $null,
        [scriptblock]$contentTransform = $null
    )

    $entry = $archive.GetEntry($entryName)
    if ($entry) {
        Write-Verbose "Updating entry: $entryName"
        $streamReader = $null
        $content = ''
        try {
            $streamReader = New-Object System.IO.StreamReader($entry.Open(), [System.Text.Encoding]::UTF8)
            $content = $streamReader.ReadToEnd()
        }
        finally {
            if ($null -ne $streamReader) {
                $streamReader.Close()
            }
        }

        $entry.Delete()

        if ($prepend) { $content = "$prepend`n$content" }
        if ($contentTransform) { $content = & $contentTransform $content }

        $finalEntryName = if ($newEntryName) { $newEntryName } else { $entryName }
        Write-Verbose "Creating new entry: $finalEntryName"

        $newEntry = $archive.CreateEntry($finalEntryName)
        $streamWriter = $null
        try {
            $streamWriter = New-Object System.IO.StreamWriter($newEntry.Open(), [System.Text.Encoding]::UTF8)
            $streamWriter.Write($content)
            $streamWriter.Flush()
        }
        finally {
            if ($null -ne $streamWriter) {
                $streamWriter.Close()
            }
        }
        Write-Verbose "Entry $finalEntryName updated successfully."
    }
    else {
        Write-Warning "Entry '$entryName' not found in archive."
    }
}


Write-Host ($lang).ModSpoti`n

Remove-TempDirectory -Directory $tempDirectory

$xpui_js_patch = Join-Path (Join-Path (Join-Path $spotifyDirectory 'Apps') 'xpui') 'xpui.js'
$test_spa = Test-Path -Path $xpui_spa_patch
$test_js = Test-Path -Path $xpui_js_patch

if ($test_spa -and $test_js) {
    Write-Host ($lang).Error -ForegroundColor Red
    Write-Host ($lang).FileLocBroken
    Stop-Script
}

if ($test_js) {

    do {
        $ch = Read-Host -Prompt ($lang).Spicetify
        Write-Host
        if (!($ch -eq 'n' -or $ch -eq 'y')) { incorrectValue }
    }
    while ($ch -notmatch '^y$|^n$')

    if ($ch -eq 'y') {
        $Url = "https://telegra.ph/SpotX-FAQ-09-19#Can-I-use-SpotX-and-Spicetify-together?"
        Start-Process $Url
    }

    Stop-Script
}

if (!($test_js) -and !($test_spa)) {
    Write-Host "xpui.spa not found, reinstall Spotify"
    Stop-Script
}

if ($test_spa) {

    Add-Type -Assembly 'System.IO.Compression.FileSystem'

    # Check for the presence of xpui.js in the xpui.spa archive

    $archive_spa = $null
    $xpuiJsEntry = $null
    $v8_snapshot = $null
    $archiveError = $null

    try {
        $archive_spa = [System.IO.Compression.ZipFile]::OpenRead($xpui_spa_patch)
        $xpuiJsEntry = $archive_spa.GetEntry('xpui.js')
        $xpuiSnapshotEntry = $archive_spa.GetEntry('xpui-snapshot.js')

        if (($null -eq $xpuiJsEntry) -and ($null -ne $xpuiSnapshotEntry)) {

            $snapshot_x64 = Join-Path $spotifyDirectory 'v8_context_snapshot.bin'
            $snapshot_arm64 = Join-Path $spotifyDirectory 'v8_context_snapshot.arm64.bin'

            $v8_snapshot = switch ($true) {
                { Test-Path $snapshot_x64 } { $snapshot_x64; break }
                { Test-Path $snapshot_arm64 } { $snapshot_arm64; break }
                default { $null }
            }

            if ($v8_snapshot) {
                $modules = Extract-WebpackModules -InputFile $v8_snapshot

                $archive_spa.Dispose()
                $archive_spa = [System.IO.Compression.ZipFile]::Open($xpui_spa_patch, [System.IO.Compression.ZipArchiveMode]::Update)

                Update-ZipEntry -archive $archive_spa -entryName 'xpui-snapshot.js' -prepend $modules -newEntryName 'xpui.js' -Verbose:$VerbosePreference

                Update-ZipEntry -archive $archive_spa -entryName 'xpui-snapshot.css' -newEntryName 'xpui.css' -Verbose:$VerbosePreference

                Update-ZipEntry -archive $archive_spa -entryName 'index.html' -contentTransform {
                    param($c)
                    $c = $c -replace 'xpui-snapshot.js', 'xpui.js'
                    $c = $c -replace 'xpui-snapshot.css', 'xpui.css'
                    return $c
                } -Verbose:$VerbosePreference
            }

        }
    }
    catch {
        $archiveError = $_.Exception
    }
    finally {
        if ($null -ne $archive_spa) {
            $archive_spa.Dispose()
        }
    }

    if ($archiveError) {
        Stop-BrokenSpotifyFiles -Details "Error: $($archiveError.Message)"
    }

    if (-not $v8_snapshot -and $null -eq $xpuiJsEntry) {
        Write-Warning "v8_context_snapshot file not found, cannot create xpui.js"
        Stop-Script
    }

    $bak_spa = Join-Path (Join-Path $spotifyDirectory 'Apps') 'xpui.bak'
    $test_bak_spa = Test-Path -Path $bak_spa

    # Make a backup copy of xpui.spa if it is original
    $zip = $null
    $reader = $null

    try {
        $zip = [System.IO.Compression.ZipFile]::Open($xpui_spa_patch, 'update')
        $entry = $zip.GetEntry('xpui.js')
        if ($null -eq $entry) { throw "Archive entry not found: xpui.js" }

        $reader = New-Object System.IO.StreamReader($entry.Open())
        $patched_by_spotx = $reader.ReadToEnd()
    }
    catch {
        Stop-BrokenSpotifyFiles -Details "Error: $($_.Exception.Message)"
    }
    finally {
        if ($null -ne $reader) { $reader.Dispose() }
        if ($null -ne $zip) { $zip.Dispose() }
    }


    if ($offline -ge [version]'1.2.70.253') {

        $spotify_binary_bak = $dll_bak
        $spotify_binary = $spotifyDll
    }
    else {
        $spotify_binary_bak = $exe_bak
        $spotify_binary = $spotifyExecutable
    }

    If ($patched_by_spotx -match 'patched by spotx') {
        if ($test_bak_spa) {
            Remove-Item $xpui_spa_patch -Recurse -Force
            Rename-Item $bak_spa $xpui_spa_patch

            if (Test-Path -Path $spotify_binary_bak) {
                Remove-Item $spotify_binary -Recurse -Force
                Rename-Item $spotify_binary_bak $spotify_binary
            }
            if ($spotify_binary_bak -eq $dll_bak) {

                if (Test-Path -Path $exe_bak) {
                    Remove-Item $spotifyExecutable -Recurse -Force
                    Rename-Item $exe_bak $spotifyExecutable
                }
                else {
                    $binary_exe_bak = [System.IO.Path]::GetFileName($exe_bak)
                    Write-Warning ("Backup copy {0} not found. Please reinstall Spotify and run SpotX again" -f $binary_exe_bak)
                    if (-not $no_pause) { Pause }
                    Exit
                }

                if (Test-Path -Path $chrome_elf_bak) {
                    Remove-Item $chrome_elf -Recurse -Force
                    Rename-Item $chrome_elf_bak $chrome_elf
                }
                else {
                    $binary_chrome_elf_bak = [System.IO.Path]::GetFileName($chrome_elf_bak)
                    Write-Warning ("Backup copy {0} not found. Please reinstall Spotify and run SpotX again" -f $binary_chrome_elf_bak)
                    if (-not $no_pause) { Pause }
                    Exit
                }

            }
        }
        else {
            Write-Host ($lang).NoRestore`n
            if (-not $no_pause) { Pause }
            Exit
        }

    }
    Copy-Item $xpui_spa_patch $bak_spa

    if ($spotify_binary_bak -eq $dll_bak) {
        Copy-Item $spotifyExecutable $exe_bak
        Copy-Item $chrome_elf $chrome_elf_bak

    }

    # Remove all languages except En and Ru from xpui.spa
    if ($ru) {
        $null = [Reflection.Assembly]::LoadWithPartialName('System.IO.Compression')
        $stream = $null
        $zip_xpui = $null

        try {
            $stream = New-Object IO.FileStream($xpui_spa_patch, [IO.FileMode]::Open)
            $mode = [IO.Compression.ZipArchiveMode]::Update
            $zip_xpui = New-Object IO.Compression.ZipArchive($stream, $mode)

            ($zip_xpui.Entries | Where-Object { $_.FullName -match "i18n" -and $_.FullName -inotmatch "(ru|en.json|longest)" }) | foreach { $_.Delete() }
        }
        catch {
            Stop-BrokenSpotifyFiles -Details "Error: $($_.Exception.Message)"
        }
        finally {
            if ($null -ne $zip_xpui) { $zip_xpui.Dispose() }
            if ($null -ne $stream) { $stream.Dispose() }
        }
    }

    # Full screen mode activation and removing "Upgrade to premium" menu, upgrade button, disabling a playlist sponsor
    if (!($premium)) {
        extract -counts 'one' -method 'zip' -name 'xpui.js' -helper 'OffadsonFullscreen'
    }

    # Forced exp
    extract -counts 'one' -method 'zip' -name 'xpui.js' -helper 'ForcedExp' -add $webjson.others.byspotx.add

    # Send new versions
    if (!($sendversion_off)) {
        $checkVersion = Get -Url (Get-Link -e "/js-helper/checkVersion.js")

        if ($checkVersion -ne $null) {
            injection -p $xpui_spa_patch -f "spotx-helper" -n "checkVersion.js" -c $checkVersion
        }
    }

    # Hiding Ad-like sections or turn off podcasts from the homepage
    if ($podcast_off -or $adsections_off -or $canvashome_off) {

        $section = Get -Url (Get-Link -e "/js-helper/sectionBlock.js")

        if ($section -ne $null) {

            $calltype = switch ($true) {
                ($podcast_off -and $adsections_off -and $canvashome_off) { "'all'"; break }
                ($podcast_off -and $adsections_off) { "['podcast', 'section']"; break }
                ($podcast_off -and $canvashome_off) { "['podcast', 'canvas']"; break }
                ($adsections_off -and $canvashome_off) { "['section', 'canvas']"; break }
                $podcast_off { "'podcast'"; break }
                $adsections_off { "'section'"; break }
                $canvashome_off { "'canvas'"; break }
                default { $null }
            }

            if (!($calltype -eq "'canvas'" -and [version]$offline -le [version]"1.2.44.405")) {
                $section = $section -replace "sectionBlock\(data, ''\)", "sectionBlock(data, $calltype)"
                injection -p $xpui_spa_patch -f "spotx-helper" -n "sectionBlock.js" -c $section
            }
        }

    }

    # goofy History
    if ($urlform_goofy -and $idbox_goofy) {

        $goofy = Get -Url (Get-Link -e "/js-helper/goofyHistory.js")

        if ($goofy -ne $null) {

            injection -p $xpui_spa_patch -f "spotx-helper" -n "goofyHistory.js" -c $goofy
        }
    }

    # Static color for lyrics
    if ($lyrics_stat) {
        $rulesContent = Get -Url (Get-Link -e "/css-helper/lyrics-color/rules.css")
        $colorsContent = Get -Url (Get-Link -e "/css-helper/lyrics-color/colors.css")

        $colorsContent = $colorsContent -replace '{{past}}', "$($webjson.others.themelyrics.theme.$lyrics_stat.pasttext)"
        $colorsContent = $colorsContent -replace '{{current}}', "$($webjson.others.themelyrics.theme.$lyrics_stat.current)"
        $colorsContent = $colorsContent -replace '{{next}}', "$($webjson.others.themelyrics.theme.$lyrics_stat.next)"
        $colorsContent = $colorsContent -replace '{{hover}}', "$($webjson.others.themelyrics.theme.$lyrics_stat.hover)"
        $colorsContent = $colorsContent -replace '{{background}}', "$($webjson.others.themelyrics.theme.$lyrics_stat.background)"
        $colorsContent = $colorsContent -replace '{{musixmatch}}', "$($webjson.others.themelyrics.theme.$lyrics_stat.maxmatch)"

        injection -p $xpui_spa_patch -f "spotx-helper/lyrics-color" -n @("rules.css", "colors.css") -c @($rulesContent, $colorsContent) -i "rules.css"

    }
    extract -counts 'one' -method 'zip' -name 'home-v2.js' -helper 'HomeV2-js'
    extract -counts 'one' -method 'zip' -name 'xpui.js' -helper 'VariousofXpui-js'

    if ([version]$offline -ge [version]"1.1.85.884" -and [version]$offline -le [version]"1.2.57.463") {

        if ([version]$offline -ge [version]"1.2.45.454") { $typefile = "xpui.js" }

        else { $typefile = "xpui-routes-search.js" }

        extract -counts 'one' -method 'zip' -name $typefile -helper "Fixjs"
    }


    if ($devtools -and [version]$offline -ge [version]"1.2.35.663") {
        extract -counts 'one' -method 'zip' -name 'xpui-routes-desktop-settings.js' -helper 'Dev'
    }

    # Hide Collaborators icon
    if (!($hide_col_icon_off) -and !($exp_spotify)) {
        extract -counts 'one' -method 'zip' -name 'xpui-routes-playlist.js' -helper 'Collaborators'
    }

    # Add discriptions (xpui-desktop-modals.js)
    extract -counts 'one' -method 'zip' -name 'xpui-desktop-modals.js' -helper 'Discriptions'

    # Disable Sentry
    if ( [version]$offline -le [version]"1.2.56.502" ) {
        $fileName = 'vendor~xpui.js'

    }
    else { $fileName = 'xpui.js' }

    extract -counts 'one' -method 'zip' -name $fileName -helper 'DisableSentry'

    # Minification of all *.js
    extract -counts 'more' -name '*.js' -helper 'MinJs'

    # xpui.css
    if (!($premium)) {
        # Hide download block
        if ([version]$offline -ge [version]"1.2.30.1135") {
            $css += $webjson.others.downloadquality.add
        }
        # Hide download icon on different pages
        $css += $webjson.others.downloadicon.add
        # Hide submenu item "download"
        $css += $webjson.others.submenudownload.add
        # Hide very high quality streaming
        if ([version]$offline -le [version]"1.2.29.605") {
            $css += $webjson.others.veryhighstream.add
        }
    }
    # block subfeeds
    if ($calltype -match "all" -or $calltype -match "podcast") {
        $css += $webjson.others.block_subfeeds.add
    }
    # scrollbar indent fixes
    $css += $webjson.others.'fix-scrollbar'.add

    if ($null -ne $css ) { extract -counts 'one' -method 'zip' -name 'xpui.css' -add $css }

    # Old UI fix
    extract -counts 'one' -method 'zip' -name 'xpui.css' -helper "FixCss"

    # Remove RTL and minification of all *.css
    extract -counts 'more' -name '*.css' -helper 'Cssmin'

    # Licenses HTML minification

    $licensesFileName = if ([version]$offline -ge [version]'1.2.93') { 'ui-licenses.html' } else { 'licenses.html' }
    extract -counts 'one' -method 'zip' -name $licensesFileName -helper 'HtmlLicMin'
    # blank.html minification
    extract -counts 'one' -method 'zip' -name 'blank.html' -helper 'HtmlBlank'

    if ($ru) {
        # Additional translation of the ru.json file
        extract -counts 'more' -name '*ru.json' -helper 'RuTranslate'
    }
    # Minification of all *.json
    extract -counts 'more' -name '*.json' -helper 'MinJson'

    if ($patched_by_spotx.StartsWith('var __webpack_modules__={')) {
        # Skip snapshot creation in Spicetify
        Get-ChildItem -LiteralPath $spotifyDirectory -Filter 'v8_context_snapshot*.bin' -File |
            Rename-Item -NewName { 'V' + $_.Name.Substring(1) } -ErrorAction Stop
    }
}

# Delete all files except "en" and "ru"
if ($ru) {
    $patch_lang = "$spotifyDirectory\locales"
    Remove-Item $patch_lang -Exclude *en*, *ru* -Recurse
}

# Create a desktop shortcut
$ErrorActionPreference = 'SilentlyContinue'

if (!($no_shortcut)) {

    $desktop_folder = DesktopFolder

    If (!(Test-Path $desktop_folder\Spotify.lnk)) {
        $source = $spotifyExecutable
        $target = "$desktop_folder\Spotify.lnk"
        $WorkingDir = $spotifyDirectory
        $WshShell = New-Object -comObject WScript.Shell
        $Shortcut = $WshShell.CreateShortcut($target)
        $Shortcut.WorkingDirectory = $WorkingDir
        $Shortcut.TargetPath = $source
        $Shortcut.Save()
    }
}

# Create shortcut in start menu
If (!(Test-Path $start_menu)) {
    $source = $spotifyExecutable
    $target = $start_menu
    $WorkingDir = $spotifyDirectory
    $WshShell = New-Object -comObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut($target)
    $Shortcut.WorkingDirectory = $WorkingDir
    $Shortcut.TargetPath = $source
    $Shortcut.Save()
}

$ANSI = [Text.Encoding]::GetEncoding(1251)
$old = [IO.File]::ReadAllText($spotify_binary, $ANSI)

$regex1 = $old -notmatch $webjson.others.binary.block_update.add
$regex2 = $old -notmatch $webjson.others.binary.block_slots.add
$regex3 = $old -notmatch $webjson.others.binary.block_slots_2.add
$regex4 = $old -notmatch $webjson.others.binary.block_slots_3.add
$regex5 = $old -notmatch $(
    if ([version]$offline -gt [version]'1.2.73.474') { $webjson.others.binary.block_gabo2.add }
    else { $webjson.others.binary.block_gabo.add }
)

if ($regex1 -and $regex2 -and $regex3 -and $regex4 -and $regex5) {

    if (Test-Path -LiteralPath $spotify_binary_bak) {
        Remove-Item $spotify_binary_bak -Recurse -Force
        Start-Sleep -Milliseconds 150
    }
    copy-Item $spotify_binary $spotify_binary_bak
}

if (-not (Test-Path -LiteralPath $spotify_binary_bak)) {
    $name_binary = [System.IO.Path]::GetFileName($spotify_binary_bak)
    Write-Warning ("Backup copy {0} not found. Please reinstall Spotify and run SpotX again" -f $name_binary)
    if (-not $no_pause) { Pause }
    Exit
}

# disable signature verification
if ($spotify_binary_bak -eq $dll_bak) {
    Reset-Dll-Sign -FilePath $spotifyDll

    $files = @("Spotify.dll", "Spotify.exe", "chrome_elf.dll")
    Remove-Signature-FromFiles $files
}

# binary patch
extract -counts 'exe' -helper 'Binary'

if ($spotify_binary_bak -eq $dll_bak -and !$premium -and [version]$offline -ge [version]'1.2.94') {
    $null = Set-BlockSlotsBinaryPatch -FilePath $spotifyDll
}

if ($spotify_binary_bak -eq $dll_bak -and !$premium -and [version]$offline -ge [version]'1.2.89') {
    $null = Set-CrossfadeEnabledBinaryPatch -FilePath $spotifyDll
}

# fix login for old versions
if ([version]$offline -ge [version]"1.1.87.612" -and [version]$offline -le [version]"1.2.5.1006") {
    $login_spa = Join-Path (Join-Path $spotifyDirectory 'Apps') 'login.spa'
    Get -Url (Get-Link -e "/res/login.spa") -OutputPath $login_spa
}

# Disable Startup client
if ($DisableStartup) {
    $prefsPath = Join-Path $spotifyDirectory 'prefs'
    $keyPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
    $keyName = "Spotify"

    # delete key in registry
    if (Get-ItemProperty -Path $keyPath -Name $keyName -ErrorAction SilentlyContinue) {
        Remove-ItemProperty -Path $keyPath -Name $keyName -Force
    }

    # create new prefs
    if (-not (Test-Path $prefsPath)) {
        $content = @"
app.autostart-configured=true
app.autostart-mode="off"
"@
        [System.IO.File]::WriteAllLines($prefsPath, $content, [System.Text.UTF8Encoding]::new($false))
    }

    # update prefs
    else {
        $content = [System.IO.File]::ReadAllText($prefsPath)
        if (-not $content.EndsWith("`n")) {
            $content += "`n"
        }
        $content += 'app.autostart-mode="off"'
        [System.IO.File]::WriteAllText($prefsPath, $content, [System.Text.UTF8Encoding]::new($false))
    }

}

# Start Spotify
if ($start_spoti) { Start-Process -WorkingDirectory $spotifyDirectory -FilePath $spotifyExecutable }

Write-Host ($lang).InstallComplete`n -ForegroundColor Green
