[CmdletBinding()]
param
(
    [Parameter(HelpMessage = 'Latest recommended Spotify version for Windows 10+.')]
    [string]$latest_full = "1.2.86.502.g8cd7fb22",

    [Parameter(HelpMessage = 'Latest supported Spotify version for Windows 7-8.1')]
    [string]$last_win7_full = "1.2.5.1006.g22820f93",

    [Parameter(HelpMessage = 'Latest supported Spotify version for x86')]
    [string]$last_x86_full = "1.2.53.440.g7b2f582a",


    [Parameter(HelpMessage = 'Force a specific download method. Default is automatic selection.')]
    [Alias('dm')]
    [ValidateSet('curl', 'webclient')]
    [string]$download_method,

    [Parameter(HelpMessage = "Change recommended Spotify version. Example: 1.2.85.519.g549a528b.")]
    [Alias("v")]
    [string]$version,

    [Parameter(HelpMessage = 'Custom path to Spotify installation directory. Default is %APPDATA%\Spotify.')]
    [string]$SpotifyPath,

    [Parameter(HelpMessage = 'Custom local path to patches.json')]
    [Alias('cp')]
    [string]$CustomPatchesPath,

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
    
    [Parameter(HelpMessage = 'Returns old lyrics')]
    [switch]$old_lyrics,

    [Parameter(HelpMessage = 'Disable native lyrics')]
    [switch]$lyrics_block,

    [Parameter(HelpMessage = 'Do not create desktop shortcut.')]
    [switch]$no_shortcut,

    [Parameter(HelpMessage = 'Disable sending new versions')]
    [switch]$sendversion_off,

    [Parameter(HelpMessage = 'Static color for lyrics.')]
    [string]$lyrics_stat,

    [Parameter(HelpMessage = 'Accumulation of track listening history with Goofy.')]
    [string]$urlform_goofy = $null,

    [Parameter(HelpMessage = 'Accumulation of track listening history with Goofy.')]
    [string]$idbox_goofy = $null,

    [Parameter(HelpMessage = 'Error log ru string.')]
    [switch]$err_ru,

    [Parameter(HelpMessage = 'Proxy Host IP or Hostname')]
    [string]$ProxyHost,

    [Parameter(HelpMessage = 'Proxy Port')]
    [string]$ProxyPort,

    [Parameter(HelpMessage = 'Proxy Type (http, https, socks4, socks5). Default: http')]
    [ValidateSet('http', 'https', 'socks4', 'socks5')]
    [string]$ProxyType = 'http',
    
    [Parameter(HelpMessage = 'Select the desired language to use for installation. Default is the detected system language.')]
    [Alias('l')]
    [string]$language,

    [Parameter(HelpMessage = 'Enable Spicetify integration.')]
    [switch]$spicetify,

    [Parameter(HelpMessage = 'Disable Outline VPN configuration prompt.')]
    [switch]$no_vpn,

    [Parameter(HelpMessage = 'Disable BlockTheSpot (DLL Injection) and use native binary patching instead.')]
    [switch]$no_bts
)

# Ignore errors from `Stop-Process`
$PSDefaultParameterValues['Stop-Process:ErrorAction'] = [System.Management.Automation.ActionPreference]::SilentlyContinue

# Set Tls12
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12;

$spotifyDirectory = Join-Path $env:APPDATA 'Spotify'
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
$xpuiSpa = Join-Path (Join-Path $env:APPDATA 'Spotify\Apps') 'xpui.spa'
$xpuiBak = Join-Path (Join-Path $env:APPDATA 'Spotify\Apps') 'xpui.bak'
$start_menu = Join-Path $env:APPDATA 'Microsoft\Windows\Start Menu\Programs\Spotify.lnk'

# Function to show VPN Server Selection UI
# This launches an interactive HTML UI to help users browse and select VPN servers
# The UI is informative and displays all available servers from vpnbook.com
# Note: Opens in default browser as a visual guide; users still configure via PowerShell prompts
function Show-VPNServerUI {
    $vpnHtmlPath = Join-Path $PSScriptRoot "vpn-selector.html"
    
    try {
        $response = (iwr -Uri (Get-Link -e "/scripts/installer-lang/$clg.ps1") -UseBasicParsing).Content
        if ($mirror) { $response = [System.Text.Encoding]::UTF8.GetString($response) }
        Invoke-Expression $response
    }
    catch {
        Write-Host "Error loading $clg language"
        Pause
        Exit
    }
}

# Set language code for script.
$langCode = Format-LanguageCode -LanguageCode $Language

$lang = CallLang -clg $langCode

Write-Host ($lang).Welcome
Write-Host

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

$spotifyDownloadBaseUrl = "https://loadspot.amd64fox1.workers.dev/download"
$systemArchitecture = Get-SystemArchitecture

$match_v = "^(?<version>\d+\.\d+\.\d+\.\d+\.g[0-9a-f]{8})(?:-\d+)?$"
$versionIsSupported = $false
if ($version) {
    if ($version -match $match_v) {
        $onlineFull = $Matches.version
        $versionIsSupported = $true
    }
    else {      
        Write-Warning "Invalid $($version) format. Example: 1.2.13.661.ga588f749 (legacy -4064 suffix is optional)"
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
            # Open the HTML file in default browser as an informative visual guide
            Start-Process $vpnHtmlPath
            Write-Host "`nPlease review the VPN servers in the UI that just opened." -ForegroundColor Green
            Write-Host "Copy your chosen server's access key, then return here to continue..." -ForegroundColor Yellow
            return $true
        }
        catch {
            Write-Host "Could not launch VPN UI: $_" -ForegroundColor Red
            return $false
        }
    }
    else {
        Write-Host "VPN selector UI not found at: $vpnHtmlPath" -ForegroundColor Red
        return $false
    }
}

# Outline VPN configuration
if (-not $no_vpn) {
    if ($PSBoundParameters.ContainsKey('ProxyType') -eq $false) {
        $ProxyType = 'socks5'
    }
    if ([string]::IsNullOrWhiteSpace($ProxyHost)) {
        $ProxyHost = '127.0.0.1'
    }
    if (-not $ProxyPort) {
        Write-Host "`n================================================" -ForegroundColor Cyan
        Write-Host "        VPN Configuration (VPNBook.com)" -ForegroundColor Yellow
        Write-Host "================================================" -ForegroundColor Cyan
        
        # Try to show the UI first
        $uiLaunched = Show-VPNServerUI
        
        if ($uiLaunched) {
            Write-Host "`n🌐 Available VPN Servers from VPNBook.com:" -ForegroundColor Green
        }
        else {
            Write-Host "`nFalling back to text-based selection..." -ForegroundColor Yellow
        }
        
        Write-Host "`nOutline/Shadowsocks Servers (Recommended):" -ForegroundColor Cyan
        Write-Host "  Poland Server 1: ss://Y2hhY2hhMjAtaWV0Zi1wb2x5MTMwNTpwdmd6OXBx@pl134.vpnbook.com:443/?outline=1" -ForegroundColor White
        Write-Host "  Poland Server 2: ss://Y2hhY2hhMjAtaWV0Zi1wb2x5MTMwNTpwdmd6OXBx@pl140.vpnbook.com:443/?outline=1" -ForegroundColor White
        Write-Host "  Canada Server 3: ss://Y2hhY2hhMjAtaWV0Zi1wb2x5MTMwNTpwdmd6OXBx@ca225.vpnbook.com:443/?outline=1" -ForegroundColor White

        Write-Host "`nOpenVPN/WireGuard Servers (Requires separate client):" -ForegroundColor Gray
        Write-Host "  US: US16, US178 | Canada: CA149, CA196" -ForegroundColor Gray
        Write-Host "  UK: UK205, UK68 | Germany: DE20, DE220 | France: FR200, FR231" -ForegroundColor Gray
        Write-Host "  Get credentials at: https://www.vpnbook.com/freevpn" -ForegroundColor Gray

        Write-Host "`n📝 Enter the local SOCKS5 port from your Outline Client" -ForegroundColor Yellow
        Write-Host "   (Leave empty to skip proxy setup)" -ForegroundColor Gray
        $ProxyPort = Read-Host "Port"
    }
}

function Stop-Spotify {
    Write-Host "Stopping Spotify..." -ForegroundColor Yellow
    Stop-Process -Name Spotify -Force -ErrorAction SilentlyContinue
    Stop-Process -Name SpotifyWebHelper -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2
}

function Restore-Backups {
    Write-Host "Checking for backups to restore..." -ForegroundColor Cyan
    
    # Restore binaries (Fixes 'Bad Image' errors)
    if (Test-Path $exe_bak) {
        Write-Host "Restoring Spotify.exe..." -ForegroundColor Green
        Remove-Item $spotifyExecutable -Force -ErrorAction SilentlyContinue
        Move-Item $exe_bak $spotifyExecutable -Force
    }
    if (Test-Path $dll_bak) {
        Write-Host "Restoring Spotify.dll..." -ForegroundColor Green
        Remove-Item $spotifyDll -Force -ErrorAction SilentlyContinue
        Move-Item $dll_bak $spotifyDll -Force
    }
    if (Test-Path $chrome_elf_bak) {
        Write-Host "Restoring chrome_elf.dll..." -ForegroundColor Green
        Remove-Item $chrome_elf -Force -ErrorAction SilentlyContinue
        Move-Item $chrome_elf_bak $chrome_elf -Force
    }

    # Restore xpui.spa (UI Resource)
    if (Test-Path $xpuiBak) {
        Write-Host "Restoring xpui.spa (UI Resource)..." -ForegroundColor Green
        Remove-Item $xpuiSpa -Force -ErrorAction SilentlyContinue
        Move-Item $xpuiBak $xpuiSpa -Force
    }

    # Clean up extracted folders if any
    $xpuiExtracted = Join-Path (Join-Path $env:APPDATA 'Spotify\Apps') 'xpui'
    if (Test-Path $xpuiExtracted) {
        Remove-Item $xpuiExtracted -Recurse -Force -ErrorAction SilentlyContinue
    }
}

function Remove-BlockTheSpot {
    Write-Host "Checking for BlockTheSpot files..." -ForegroundColor Cyan
    $btsFiles = @('dpapi.dll', 'config.ini')
    foreach ($file in $btsFiles) {
        $path = Join-Path $spotifyDirectory $file
        if (Test-Path $path) {
            Write-Host "Removing legacy file: $file" -ForegroundColor Yellow
            Remove-Item $path -Force -ErrorAction SilentlyContinue
        }
    }
}

function Install-BlockTheSpot {
    Remove-BlockTheSpot
    Write-Host "Installing BlockTheSpot (Ads & Premium Features)..." -ForegroundColor Cyan

    # Detect Architecture
    $is64Bit = $true
    if (Test-Path $spotifyExecutable) {
        try {
            $bytes = [System.IO.File]::ReadAllBytes($spotifyExecutable)
            $peHeader = [System.BitConverter]::ToUInt16($bytes, 0x3C)
            $machine = [System.BitConverter]::ToUInt16($bytes, $peHeader + 4)
            $is64Bit = $machine -eq 0x8664
        } catch {
            Write-Warning "Architecture detection failed. Defaulting to x64."
            $is64Bit = $true
        }
    } else {
        Write-Warning "Spotify.exe not found. Is Spotify installed?"
        return
    }

    # Cache Configuration
    $cacheDir = Join-Path $env:LOCALAPPDATA 'SpotFreedom'
    if (-not (Test-Path $cacheDir)) {
        New-Item -Path $cacheDir -ItemType Directory -Force | Out-Null
    }

    if ($is64Bit) {
        $btsUrl = 'https://github.com/mrpond/BlockTheSpot/releases/latest/download/chrome_elf.zip'
        Write-Host "Detected x64 architecture." -ForegroundColor Green

        # Resolve 'latest' redirect to get versioned URL
        try {
            $req = [System.Net.WebRequest]::Create($btsUrl)
            $req.Method = "HEAD"
            $req.AllowAutoRedirect = $false
            $resp = $req.GetResponse()

            if ($resp.StatusCode -eq [System.Net.HttpStatusCode]::Found -or
                $resp.StatusCode -eq [System.Net.HttpStatusCode]::MovedPermanently -or
                $resp.StatusCode -eq [System.Net.HttpStatusCode]::Redirect) {
                $btsUrl = $resp.Headers["Location"]
            }
            $resp.Close()
        } catch {
            Write-Warning "Could not resolve BlockTheSpot version. Cache may be ineffective."
        }
    } else {
        $btsUrl = 'https://github.com/mrpond/BlockTheSpot/releases/download/2023.5.20.80/chrome_elf.zip'
        Write-Warning "Detected x86 architecture. Using legacy BlockTheSpot."
    }

    # Determine Cache Filename
    $cacheFileName = 'chrome_elf.zip'
    if ($btsUrl -match 'releases/download/([^/]+)/chrome_elf.zip') {
        $version = $matches[1]
        $cacheFileName = "chrome_elf_$version.zip"
    } elseif ($is64Bit) {
         $cacheFileName = "chrome_elf_latest_x64.zip"
    } else {
         $cacheFileName = "chrome_elf_legacy_x86.zip"
    }

    $btsZip = Join-Path $cacheDir $cacheFileName

    try {
        if (-not (Test-Path $btsZip)) {
            Write-Host "Downloading BlockTheSpot..." -ForegroundColor Cyan
            Invoke-WebRequest -Uri $btsUrl -OutFile $btsZip -UseBasicParsing
        } else {
            Write-Host "Using cached BlockTheSpot: $cacheFileName" -ForegroundColor Green
        }
        
        if (Test-Path $btsZip) {
            try {
                Expand-Archive -Force -LiteralPath $btsZip -DestinationPath $spotifyDirectory -ErrorAction Stop
                Write-Host "BlockTheSpot installed successfully." -ForegroundColor Green
            } catch {
                Write-Warning "Failed to extract BlockTheSpot. Deleting corrupt cache file..."
                Remove-Item $btsZip -Force -ErrorAction SilentlyContinue
                throw $_
            }
        } else {
            Write-Error "Failed to download BlockTheSpot."
        }
    } catch {
        Write-Error "Error installing BlockTheSpot: $_"
    }
}

function DesktopFolder {
    $ErrorActionPreference = 'SilentlyContinue' 
    if (Test-Path "$env:USERPROFILE\Desktop") {  
        return "$env:USERPROFILE\Desktop"
    }
    $regedit_desktop_folder = Get-ItemProperty -Path "Registry::HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders\"
    return $regedit_desktop_folder.'{754AC886-DF64-4CBA-86B5-F7FBF4FBCEF5}'
}

function Get-SpotifyVersion {
    if (Test-Path $spotifyExecutable) {
        try {
            return (Get-Item $spotifyExecutable).VersionInfo.ProductVersion
        } catch {
            return $null
        }
    }
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

            Write-Host ("Using local patches.json: {0}" -f $resolvedPath)

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
    
    .DESCRIPTION
    Fetches version information from loadspot.pages.dev to determine 
    the latest available Spotify version and download URL.
    
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
    $arch = Get-SpotifyInstallerArchitecture `
        -SystemArchitecture $systemArchitecture `
        -SpotifyVersion $spotifyVersion `
        -LastX86SupportedVersion $last_x86

    $web_Url = "$spotifyDownloadBaseUrl/spotify_installer-$onlineFull-$arch.exe"
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
        if ($confirm_spoti_recomended_over -or $confirm_spoti_recomended_uninstall) {
            Write-Host ($lang).OldV`n
        }
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
            Write-Host ($lang).AutoUpd`n
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
                Write-Host ($lang).DelOld`n 
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

        if ($confirm_spoti_recomended_over -or $confirm_spoti_recomended_uninstall) {
            Write-Host ($lang).NewV`n
        }
        if (!($confirm_spoti_recomended_over) -and !($confirm_spoti_recomended_uninstall)) {
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
        if ($confirm_spoti_recomended_over -or $confirm_spoti_recomended_uninstall) { $ch = 'n' }
        if ($ch -eq 'y') { $upgrade_client = $false }
        if ($ch -eq 'n') {
            if (!($confirm_spoti_recomended_over) -and !($confirm_spoti_recomended_uninstall)) {
                do {
                    $ch = Read-Host -Prompt (($lang).Recom -f $online)
                    Write-Host
                    if (!($ch -eq 'n' -or $ch -eq 'y')) {
                        incorrectValue
                    }
                }
                while ($ch -notmatch '^y$|^n$')
            }
            if ($confirm_spoti_recomended_over -or $confirm_spoti_recomended_uninstall) { 
                $ch = 'y' 
                Write-Host ($lang).AutoUpd`n
            }
            if ($ch -eq 'y') {
                $upgrade_client = $true
                $downgrading = $true
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
                    Write-Host ($lang).DelNew`n
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


function Helper($paramname) {


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
            # licenses.html minification
            $name = "patches.json.others."
            $n = "licenses.html"
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

            $svg_tg = $webjson.others.discriptions.svgtg
            $svg_git = $webjson.others.discriptions.svggit
            $svg_faq = $webjson.others.discriptions.svgfaq
            $replace = $webjson.others.discriptions.replace

            $replacedText = $replace -f $svg_git, $svg_tg, $svg_faq

            $webjson.others.discriptions.replace = '$1"' + $replacedText + '"})'

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
                    
                    if ($old_lyrics) { 
                        Remove-Json -j $Enable -p 'RightSidebarLyrics' 
                        $Custom.LyricsVariationsInNPV.value = "CONTROL"
                    } 
                }
            }
            if (!$premium) { Remove-Json -j $Enable -p 'RemoteDownloads', 'Magpie', 'MagpiePrompting', 'MagpieScheduling', 'MagpieCuration' }

            # Disable unimportant exp
            if ($exp_spotify) {
                $objects = @(
                    @{
                        Object           = $webjson.others.CustomExp.psobject.properties
                        PropertiesToKeep = @('LyricsUpsell')
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
        "VariousofXpui-js" { 

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
    $offline_patch = $offline -replace '(\d+\.\d+\.\d+)(.\d+)', '$1'

    $contents | foreach { 

        if ( $json.$PSItem.version.to ) { $to = [version]$json.$PSItem.version.to -ge [version]$offline_patch } else { $to = $true }
        if ( $json.$PSItem.version.fr ) { $fr = [version]$json.$PSItem.version.fr -le [version]$offline_patch } else { $fr = $false }
        
        $checkVer = $fr -and $to; $translate = $paramname -eq "RuTranslate"

        if ($checkVer -or $translate) {

            if ($json.$PSItem.match.Count -gt 1) {

                $count = $json.$PSItem.match.Count - 1
                $numbers = 0

                While ($numbers -le $count) {

                    if ($paramdata -match $json.$PSItem.match[$numbers]) { 
                        $paramdata = $paramdata -replace $json.$PSItem.match[$numbers], $json.$PSItem.replace[$numbers] 
                    }
                    else { 
                        $notlog = "MinJs", "MinJson", "Cssmin"
                        if ($paramname -notin $notlog) {
    
                            Write-Host $novariable -ForegroundColor red -NoNewline 
                            Write-Host "$name$PSItem $numbers"'in'$n
                        }
                    }  
                    $numbers++
                }
            }
            if ($json.$PSItem.match.Count -eq 1) {
                if ($paramdata -match $json.$PSItem.match) { 
                    $paramdata = $paramdata -replace $json.$PSItem.match, $json.$PSItem.replace 
                }
                else { 
                    if (!($translate) -or $err_ru) {
                        Write-Host $novariable -ForegroundColor red -NoNewline 
                        Write-Host "$name$PSItem"'in'$n
                    }
                }
            }   
        }
    }
    $paramdata
}

function extract ($counts, $method, $name, $helper, $add, $patch) {
    switch ( $counts ) {
        "one" { 
            if ($method -eq "zip") {
                Add-Type -Assembly 'System.IO.Compression.FileSystem'
                $xpui_spa_patch = Join-Path (Join-Path $spotifyDirectory 'Apps') 'xpui.spa'
                $zip = [System.IO.Compression.ZipFile]::Open($xpui_spa_patch, 'update')   
                $file = $zip.GetEntry($name)
                $reader = New-Object System.IO.StreamReader($file.Open())
            }
            if ($method -eq "nonezip") {
                $file = Get-Item (Join-Path (Join-Path (Join-Path $spotifyDirectory 'Apps') 'xpui') $name)
                $reader = New-Object -TypeName System.IO.StreamReader -ArgumentList $file
            }
            $xpui = $reader.ReadToEnd()
            $reader.Close()
            if ($helper) { $xpui = Helper -paramname $helper } 
            if ($method -eq "zip") { $writer = New-Object System.IO.StreamWriter($file.Open()) }
            if ($method -eq "nonezip") { $writer = New-Object System.IO.StreamWriter -ArgumentList $file }
            $writer.BaseStream.SetLength(0)
            $writer.Write($xpui)
            if ($add) { $add | foreach { $writer.Write([System.Environment]::NewLine + $PSItem ) } }
            $writer.Close()  
            if ($method -eq "zip") { $zip.Dispose() }
        }
        "more" {  
            Add-Type -Assembly 'System.IO.Compression.FileSystem'
            $xpui_spa_patch = Join-Path (Join-Path $spotifyDirectory 'Apps') 'xpui.spa'
            $zip = [System.IO.Compression.ZipFile]::Open($xpui_spa_patch, 'update') 
            $zip.Entries | Where-Object { $_.FullName -like $name -and $_.FullName.Split('/') -notcontains 'spotx-helper' } | foreach { 
                $reader = New-Object System.IO.StreamReader($_.Open())
                $xpui = $reader.ReadToEnd()
                $reader.Close()
                $xpui = Helper -paramname $helper 
                $writer = New-Object System.IO.StreamWriter($_.Open())
                $writer.BaseStream.SetLength(0)
                $writer.Write($xpui)
                $writer.Close()
            }
            $zip.Dispose()
        }
        "exe" {
            $ANSI = [Text.Encoding]::GetEncoding(1251)
            $xpui = [IO.File]::ReadAllText($spotify_binary, $ANSI)
            $xpui = Helper -paramname $helper
            [IO.File]::WriteAllText($spotify_binary, $xpui, $ANSI)
        }
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
    $archive = [System.IO.Compression.ZipFile]::Open($ArchivePath, 'Update')
    
    try {
        # Check cache first
        if (Test-Path $cacheFile) {
            $cacheTime = (Get-Item $cacheFile).LastWriteTime
            if ((Get-Date) - $cacheTime -lt [TimeSpan]::FromSeconds($cacheAge)) {
                $cached = Get-Content $cacheFile -Raw | ConvertFrom-Json
                Write-Host "Using cached version info: $($cached.Version)" -ForegroundColor Cyan
                return $cached
            }
        }
        
        Write-Host "Checking for latest Spotify version from loadspot.pages.dev..." -ForegroundColor Cyan
        
        # Try to fetch the latest version info
        # The site may provide JSON API, HTML with version info, or redirect to download
        $response = Invoke-WebRequest -Uri $updateUrl -UseBasicParsing -TimeoutSec 10 -ErrorAction Stop
        
        # Try to extract version from various patterns
        $version = $null
        $downloadUrl = $null
        
        # Pattern 1: JSON response with version field
        try {
            $json = $response.Content | ConvertFrom-Json
            if ($json.version) { $version = $json.version }
            if ($json.downloadUrl -or $json.url) { $downloadUrl = ($json.downloadUrl ?? $json.url) }
        } catch {}
        
        # Pattern 2: HTML content with version in meta tags or specific elements
        if (-not $version) {
            if ($response.Content -match 'version["\s:=]+([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)') {
                $version = $matches[1]
            }
        }
        
        # Pattern 3: Check for download links that might contain version
        if ($response.Content -match 'href="([^"]*SpotifySetup[^"]*)"') {
            $downloadUrl = $matches[1]
            if ($downloadUrl -match '([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)') {
                if (-not $version) { $version = $matches[1] }
            }
        }
        
        if ($version) {
            $result = @{
                Version = $version
                Url = if ($downloadUrl) { $downloadUrl } else { $updateUrl }
                CheckedAt = Get-Date
            }
            
            # Cache the result
            $result | ConvertTo-Json | Set-Content $cacheFile -Force
            
            Write-Host "Latest Spotify version available: $version" -ForegroundColor Green
            return $result
        } else {
            Write-Warning "Could not parse version from loadspot.pages.dev"
            return $null
        }
    } catch {
        Write-Warning "Failed to check for latest version: $_"
        # Try to return cached data even if expired
        if (Test-Path $cacheFile) {
            try {
                $cached = Get-Content $cacheFile -Raw | ConvertFrom-Json
                Write-Host "Using stale cached version info: $($cached.Version)" -ForegroundColor Yellow
                return $cached
            } catch {}
        }
        return $null
    }
}

function Is-Ver-Compatible ($ver, $fr, $to) {
    if (-not $ver) { return $true }
    try {
        $v = $null
        if ($ver -is [System.Version]) {
            $v = $ver
        } else {
            # Normalize version string (1.2.3.4.g123 -> 1.2.3.4)
            if ($ver -match "^(\d+\.\d+\.\d+\.\d+)") { $ver = $matches[1] }
            $v = [System.Version]$ver
        }

        if (-not [string]::IsNullOrWhiteSpace($fr)) {
            $vFr = [System.Version]$fr
            if ($v -lt $vFr) { return $false }
        }
        if (-not [string]::IsNullOrWhiteSpace($to)) {
            $vTo = [System.Version]$to
            if ($v -gt $vTo) { return $false }
        }
    } catch {
        # If parsing fails, leniently assume compatible
        return $true
    }
    return $true
}

# --- SpotX Native Functions ---

function Reset-Dll-Sign {
    [CmdletBinding()]
    param (
        [string]$FilePath
    )

    $TargetStringText = "Check failed: sep_pos != std::wstring::npos."

    $Patch_x64 = "B8 01 00 00 00 C3"
    $Patch_ARM64 = "20 00 80 52 C0 03 5F D6"

    $Patch_x64 = [byte[]]($Patch_x64 -split ' ' | ForEach-Object { [Convert]::ToByte($_, 16) })
    $Patch_ARM64 = [byte[]]($Patch_ARM64 -split ' ' | ForEach-Object { [Convert]::ToByte($_, 16) })

    $csharpCode = @"
using System;
using System.Collections.Generic;

public class ScannerCore {
    public static int FindBytes(byte[] data, byte[] pattern) {
        for (int i = 0; i < data.Length - pattern.Length; i++) {
            bool match = true;
            for (int j = 0; j < pattern.Length; j++) {
                if (data[i + j] != pattern[j]) { match = false; break; }
            }
            if (match) return i;
        }
        return -1;
    }

    public static List<int> FindXref_ARM64(byte[] data, ulong stringRVA, ulong sectionRVA, uint sectionRawPtr, uint sectionSize) {
        List<int> results = new List<int>();
        for (uint i = 0; i < sectionSize; i += 4) {
            uint fileOffset = sectionRawPtr + i;
            if (fileOffset + 8 > data.Length) break;
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
                if ((inst2 & 0xFF800000) == 0x91000000) {
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

    public static int FindStart(byte[] data, int startOffset, bool isArm) {
        int step = isArm ? 4 : 1;
        if (isArm && (startOffset % 4 != 0)) { startOffset -= (startOffset % 4); }

        for (int i = startOffset; i > 0; i -= step) {
            if (isArm) {
                if (i < 4) break;
                uint currInst = BitConverter.ToUInt32(data, i);
                // ARM64 Prologue: STP X29, X30, [SP, -imm]! -> FD 7B .. A9
                if ((currInst & 0xFF00FFFF) == 0xA9007BFD) { return i; }
            } else {
                // x64: Look for at least 2 bytes of padding (CC or 90) followed by a valid function start
                if (i >= 2) {
                    if ((data[i-1] == 0xCC && data[i-2] == 0xCC) || (data[i-1] == 0x90 && data[i-2] == 0x90)) {
                        if (data[i] != 0xCC && data[i] != 0x90) {
                            // Check for common function start bytes:
                            // 0x48 (REX.W), 0x40 (REX), 0x55 (push rbp), 0x53-0x57 (push reg)
                            byte b = data[i];
                            if (b == 0x48 || b == 0x40 || b == 0x55 || (b >= 0x53 && b <= 0x57)) {
                                return i;
                            }
                        }
                    }
                }
            }
            if (startOffset - i > 20000) break;
        }
        return 0;
    }
}
"@

    if (-not ([System.Management.Automation.PSTypeName]'ScannerCore').Type) {
        Add-Type -TypeDefinition $csharpCode
    }

    Write-Verbose "Loading file: $FilePath"
    if (-not (Test-Path $FilePath)) {
        Write-Warning "File Spotify.dll not found"
        return
    }
    $bytes = [System.IO.File]::ReadAllBytes($FilePath)

    try {
        $e_lfanew = [BitConverter]::ToInt32($bytes, 0x3C)
        $Machine = [BitConverter]::ToUInt16($bytes, $e_lfanew + 4)
        $IsArm64 = $false
        $ArchName = "Unknown"

        if ($Machine -eq 0x8664) { $ArchName = "x64"; $IsArm64 = $false }
        elseif ($Machine -eq 0xAA64) { $ArchName = "ARM64"; $IsArm64 = $true }
        else {
            Write-Warning "Architecture not supported for patching Spotify.dll"
            return
        }

        $NumberOfSections = [BitConverter]::ToUInt16($bytes, $e_lfanew + 0x06)
        $SizeOfOptionalHeader = [BitConverter]::ToUInt16($bytes, $e_lfanew + 0x14)
        $SectionTableStart = $e_lfanew + 0x18 + $SizeOfOptionalHeader

        $Sections = @(); $CodeSection = $null
        for ($i = 0; $i -lt $NumberOfSections; $i++) {
            $secEntry = $SectionTableStart + ($i * 40)
            $VA = [BitConverter]::ToUInt32($bytes, $secEntry + 12)
            $RawSize = [BitConverter]::ToUInt32($bytes, $secEntry + 16)
            $RawPtr = [BitConverter]::ToUInt32($bytes, $secEntry + 20)
            $Chars = [BitConverter]::ToUInt32($bytes, $secEntry + 36)
            $SecObj = [PSCustomObject]@{ VA = $VA; RawPtr = $RawPtr; RawSize = $RawSize }
            $Sections += $SecObj
            if (($Chars -band 0x20) -ne 0 -and $CodeSection -eq $null) { $CodeSection = $SecObj }
        }
    }
    catch {
        Write-Warning "PE Error in Spotify.dll"
        return
    }

    function Get-RVA($FileOffset) {
        foreach ($sec in $Sections) {
            if ($FileOffset -ge $sec.RawPtr -and $FileOffset -lt ($sec.RawPtr + $sec.RawSize)) {
                return ($FileOffset - $sec.RawPtr) + $sec.VA
            }
        }
        return 0
    }

    Write-Host "Searching for function in Spotify.dll..." -ForegroundColor Cyan
    $StringBytes = [System.Text.Encoding]::ASCII.GetBytes($TargetStringText)
    $StringOffset = [ScannerCore]::FindBytes($bytes, $StringBytes)
    if ($StringOffset -eq -1) {
        Write-Warning "String not found in Spotify.dll"
        return
    }
    $StringRVA = Get-RVA $StringOffset

    $PatchOffset = 0
    if (-not $IsArm64) {
        $RawStart = $CodeSection.RawPtr; $RawEnd = $RawStart + $CodeSection.RawSize
        for ($i = $RawStart; $i -lt $RawEnd; $i++) {
            if ($bytes[$i] -eq 0x48 -and $bytes[$i + 1] -eq 0x8D -and $bytes[$i + 2] -eq 0x15) {
                $Rel = [BitConverter]::ToInt32($bytes, $i + 3)
                $Target = (Get-RVA $i) + 7 + $Rel
                if ($Target -eq $StringRVA) {
                    $PatchOffset = [ScannerCore]::FindStart($bytes, $i, $false)
                    if ($PatchOffset -gt 0) { break }
                }
            }
        }
    }
    else {
        $Results = [ScannerCore]::FindXref_ARM64($bytes, [uint64]$StringRVA, [uint64]$CodeSection.VA, [uint32]$CodeSection.RawPtr, [uint32]$CodeSection.RawSize)
        if ($Results.Count -gt 0) {
            $PatchOffset = [ScannerCore]::FindStart($bytes, $Results[0], $true)
        }
    }

    if ($PatchOffset -eq 0) {
        Write-Warning "Function not found in Spotify.dll"
        return
    }

    $BytesToWrite = if ($IsArm64) { $Patch_ARM64 } else { $Patch_x64 }

    $CurrentBytes = @(); for ($i = 0; $i -lt $BytesToWrite.Length; $i++) { $CurrentBytes += $bytes[$PatchOffset + $i] }

    if ($CurrentBytes[0] -eq $BytesToWrite[0] -and $CurrentBytes[$BytesToWrite.Length - 1] -eq $BytesToWrite[$BytesToWrite.Length - 1]) {
        Write-Host "File Spotify.dll already patched" -ForegroundColor Yellow
        return
    }

    Write-Host "Applying patch to Spotify.dll..." -ForegroundColor Green
    for ($i = 0; $i -lt $BytesToWrite.Length; $i++) { $bytes[$PatchOffset + $i] = $BytesToWrite[$i] }

    try {
        [System.IO.File]::WriteAllBytes($FilePath, $bytes)
        Write-Host "Spotify.dll patched successfully." -ForegroundColor Green
    }
    catch {
        Write-Warning "Write error in Spotify.dll $($_.Exception.Message)"
    }
}

function Get-PEArchitectureOffsets {
    param(
        [byte[]]$bytes,
        [int]$fileHeaderOffset
    )
    $machineType = [System.BitConverter]::ToUInt16($bytes, $fileHeaderOffset)
    $result = @{ Architecture = $null; DataDirectoryOffset = 0 }
    switch ($machineType) {
        0x8664 { $result.Architecture = 'x64'; $result.DataDirectoryOffset = 112 }
        0xAA64 { $result.Architecture = 'ARM64'; $result.DataDirectoryOffset = 112 }
        0x014c { $result.Architecture = 'x86'; $result.DataDirectoryOffset = 96 }
        default { $result.Architecture = 'Unknown'; $result.DataDirectoryOffset = $null }
    }
    $result.MachineType = $machineType
    return $result
}

function Remove-Sign {
    [CmdletBinding()]
    param([string]$filePath)
    try {
        $bytes = [System.IO.File]::ReadAllBytes($filePath)
        $peHeaderOffset = [System.BitConverter]::ToUInt32($bytes, 0x3C)
        if ($bytes[$peHeaderOffset] -ne 0x50 -or $bytes[$peHeaderOffset + 1] -ne 0x45) {
            Write-Warning "File '$(Split-Path $filePath -Leaf)' is not a valid PE file."
            return $false
        }
        $fileHeaderOffset = $peHeaderOffset + 4
        $optionalHeaderOffset = $fileHeaderOffset + 20
        $archInfo = Get-PEArchitectureOffsets -bytes $bytes -fileHeaderOffset $fileHeaderOffset
        if ($archInfo.DataDirectoryOffset -eq $null) {
            Write-Warning "Unsupported architecture type ($($archInfo.MachineType.ToString('X'))) in file '$(Split-Path $filePath -Leaf)'."
            return $false
        }
        $dataDirectoryOffsetWithinOptionalHeader = $archInfo.DataDirectoryOffset
        $securityDirectoryIndex = 4
        $certificateTableEntryOffset = $optionalHeaderOffset + $dataDirectoryOffsetWithinOptionalHeader + ($securityDirectoryIndex * 8)
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
        Write-Error "Error processing file '$filePath': $_"
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
            continue
        }
        try {
            if (Remove-Sign -filePath $fullPath) {
                Write-Host "Signature removed from $fileName" -ForegroundColor Green
            }
        }
        catch {
            Write-Error "Failed to process file '$fileName': $_"
        }
    }
}

function Patch-Binary ($patchesJson) {
    if (-not $patchesJson.binary) { return }

    Write-Host "Patching Spotify.exe..." -ForegroundColor Cyan

    # 1251 is used by upstream
    $ANSI = [Text.Encoding]::GetEncoding(1251)

    if (Test-Path $spotifyExecutable) {
        $content = [IO.File]::ReadAllText($spotifyExecutable, $ANSI)
        $modified = $false

        $patchesJson.binary | Get-Member -MemberType NoteProperty | ForEach-Object {
            $name = $_.Name
            $patch = $patchesJson.binary.$name

            # Checks based on parameters
            if ($name -eq "block_update" -and $block_update_off) { return } # Skip if updates allowed
            if ($name -match "block_slots" -and $premium) { return } # Skip ad blocks if premium
            if ($name -match "block_gabo" -and $premium) { return } # Skip gabo if premium (?) - upstream uses complex logic

            # Upstream logic for block_gabo: matches version. Assuming safe to apply if not matched?
            # Actually upstream logic iterates and replaces.

            if ($patch.match -and $patch.replace) {
                 if ($content -match $patch.match) {
                     $content = $content -replace $patch.match, $patch.replace
                     $modified = $true
                     Write-Host "  Applied binary patch: $name" -ForegroundColor Gray
                 }
            }
        }

        if ($modified) {
            [IO.File]::WriteAllText($spotifyExecutable, $content, $ANSI)
            Write-Host "Spotify.exe patched successfully." -ForegroundColor Green
        } else {
            Write-Host "No binary patches needed or applied." -ForegroundColor Gray
        }
    }
}

function Patch-XPUI ($patchesJson) {
    Write-Host "Patching XPUI..." -ForegroundColor Cyan

Write-Host ($lang).ModSpoti`n

Remove-TempDirectory -Directory $tempDirectory 

$xpui_spa_patch = Join-Path (Join-Path $spotifyDirectory 'Apps') 'xpui.spa'
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

    # Create Backup if not exists
    if (-not (Test-Path $xpuiBak)) {
        Write-Host "Creating backup of xpui.spa..." -ForegroundColor Yellow
        Copy-Item $xpuiSpa $xpuiBak -Force
    }

    # Extract
    $tempDir = Join-Path $env:TEMP "SpotFreedom_Temp_$(Get-Random)"
    New-Item -ItemType Directory -Path $tempDir -Force | Out-Null

    try {
        Expand-Archive -LiteralPath $xpuiSpa -DestinationPath $tempDir -Force
    } catch {
        Write-Error "Failed to extract xpui.spa"
        return
    }

    $clientVerStr = Get-SpotifyVersion
    if (-not $clientVerStr) {
        Write-Warning "Could not detect Spotify version. Assuming latest."
        $clientVerStr = "9.9.9.9" # High version
    }
    Write-Host "Detected Spotify Version: $clientVerStr" -ForegroundColor Green

    # Optimization: Parse version once to avoid repeated parsing in loop
    $clientVerForCheck = $clientVerStr
    try {
        $tempVer = $clientVerStr
        if ($tempVer -match "^(\d+\.\d+\.\d+\.\d+)") { $tempVer = $matches[1] }
        $clientVerForCheck = [System.Version]$tempVer
    } catch {
        # Fallback to string if parsing failed
        $clientVerForCheck = $clientVerStr
    }

    # Locate xpui.js / css
    $xpuiJsPath = Join-Path $tempDir "xpui.js"
    $xpuiCssPath = Join-Path $tempDir "xpui.css"

    # Handle subdirectory extraction
    if (-not (Test-Path $xpuiJsPath)) {
        if (Test-Path (Join-Path $tempDir "xpui")) {
            $tempDir = Join-Path $tempDir "xpui"
            $xpuiJsPath = Join-Path $tempDir "xpui.js"
            $xpuiCssPath = Join-Path $tempDir "xpui.css"
        }
    }

    if (-not (Test-Path $xpuiJsPath)) {
        Write-Error "xpui.js not found in extracted archive."
        return
    }

    $jsContent = Get-Content $xpuiJsPath -Raw
    $cssContent = Get-Content $xpuiCssPath -Raw

    # 1. Apply 'free' patches
    if (-not $premium) {
        Write-Host "Applying 'free' patches..." -ForegroundColor Gray
        $patchesJson.free | Get-Member -MemberType NoteProperty | ForEach-Object {
            $name = $_.Name
            $patch = $patchesJson.free.$name

            if (Is-Ver-Compatible $clientVerForCheck $patch.version.fr $patch.version.to) {
                $match = $patch.match
                $replace = $patch.replace

                if ($match -is [array]) {
                     for ($i=0; $i -lt $match.Count; $i++) {
                        $m = $match[$i]
                        $r = $replace[$i]
                        try { $jsContent = $jsContent -replace $m, $r } catch {}
                     }
                } else {
                    try { $jsContent = $jsContent -replace $match, $replace } catch {}
                }
            }
        }
    }

    # 2. Apply 'podcasts' patches
    if ($podcasts_off) {
        Write-Host "Applying 'podcasts' patches..." -ForegroundColor Gray
        $patchesJson.podcasts | Get-Member -MemberType NoteProperty | ForEach-Object {
            $name = $_.Name
            $patch = $patchesJson.podcasts.$name
            if (Is-Ver-Compatible $clientVerForCheck $patch.version.fr $patch.version.to) {
                try { $jsContent = $jsContent -replace $patch.match, $patch.replace } catch {}
            }
        }
    }

    $bak_spa = Join-Path (Join-Path $spotifyDirectory 'Apps') 'xpui.bak'
    $test_bak_spa = Test-Path -Path $bak_spa

    # Collect EnableExp
    $patchesJson.EnableExp | Get-Member -MemberType NoteProperty | ForEach-Object {
        $name = $_.Name
        $patch = $patchesJson.EnableExp.$name
        if (Is-Ver-Compatible $clientVerForCheck $patch.version.fr $patch.version.to) {
            # Use 'name' property from JSON object, fallback to key name
            $expName = if ($patch.name) { $patch.name } else { $name }
            $enableExpList += "'$expName'"
        }
    }

    # Collect DisableExp
    $patchesJson.DisableExp | Get-Member -MemberType NoteProperty | ForEach-Object {
        $name = $_.Name
        $patch = $patchesJson.DisableExp.$name
        if (Is-Ver-Compatible $clientVerForCheck $patch.version.fr $patch.version.to) {
             $expName = if ($patch.name) { $patch.name } else { $name }
             $disableExpList += "'$expName'"
        }
    }

    if ($offline -ge [version]'1.2.70.253') {
        
        # Compare versions
        try {
            # Strip git suffix if present (e.g., 1.2.3.4.g123abc -> 1.2.3.4)
            $currentVerStr = if ($currentVersion -match '^(\d+\.\d+\.\d+\.\d+)') { $matches[1] } else { $currentVersion }
            $latestVerStr = if ($latestVersionInfo.Version -match '^(\d+\.\d+\.\d+\.\d+)') { $matches[1] } else { $latestVersionInfo.Version }
            
            $currentVer = [System.Version]$currentVerStr
            $latestVer = [System.Version]$latestVerStr
            
            if ($latestVer -gt $currentVer) {
                Write-Host "A newer version of Spotify is available: $($latestVersionInfo.Version)" -ForegroundColor Yellow
                Write-Host "Download from: $($latestVersionInfo.Url)" -ForegroundColor Yellow
                Write-Host "Consider updating to ensure patches work correctly with the latest version." -ForegroundColor Yellow
            } elseif ($latestVer -eq $currentVer) {
                Write-Host "You are running the latest version of Spotify." -ForegroundColor Green
            } else {
                Write-Host "You are running a newer version than the one listed on loadspot.pages.dev" -ForegroundColor Cyan
            }
        } catch {
            Write-Host "Version comparison skipped (parsing error)" -ForegroundColor Gray
        }
    } else {
        Write-Host "Latest Spotify version from loadspot.pages.dev: $($latestVersionInfo.Version)" -ForegroundColor Green
        Write-Host "Download from: $($latestVersionInfo.Url)" -ForegroundColor Green
    }
}

# New: Apply Native Patches (Fixes Black Screen & Integrity)
# We do this before or after Restore-Backups (Restore-Backups restores original binaries, so we must patch after)
# Always apply signature fixes to prevent black screen issues
Reset-Dll-Sign -FilePath $spotifyDll
Remove-Signature-FromFiles @("Spotify.exe", "Spotify.dll", "chrome_elf.dll")

if ($no_bts) {
    # If not using BlockTheSpot, apply binary patches to allow modified XPUI
    Patch-Binary $patchesJson
} else {
    Write-Host "Using BlockTheSpot mode (Signature fixes applied, skipping binary patching)..." -ForegroundColor Yellow
}

# Always patch XPUI unless specifically disabled
Patch-XPUI $patchesJson

if (-not $no_bts) {
    Install-BlockTheSpot
} else {
    Remove-BlockTheSpot
}

# Update Shortcuts with Proxy if requested
if ($ProxyHost -and $ProxyPort) {
    Write-Host "Configuring Proxy Shortcuts..." -ForegroundColor Cyan
    $desktop_folder = DesktopFolder
    $shortcuts = @("$desktop_folder\Spotify.lnk", $start_menu)
    
    $WshShell = New-Object -comObject WScript.Shell
    
    foreach ($path in $shortcuts) {
        if (Test-Path $path) {
            $Shortcut = $WshShell.CreateShortcut($path)
            $Shortcut.Arguments = "--proxy-server=`"$($ProxyType)://$($ProxyHost):$($ProxyPort)`""
            $Shortcut.Save()
        }
    }
}

# Spicetify Integration
if ($spicetify) {
    Write-Host " [Spicetify] Integration started..." -ForegroundColor Cyan

    $spicetifyPath = "$env:LOCALAPPDATA\spicetify\spicetify.exe"
    if (-not (Test-Path $spicetifyPath)) {
        Write-Host " [Spicetify] Installing Spicetify..." -ForegroundColor Yellow
        try {
            iwr -useb https://raw.githubusercontent.com/spicetify/cli/main/install.ps1 | iex
        }
        catch {
            Write-Host " [Spicetify] Installation failed: $_" -ForegroundColor Red
        }
    }
    else {
        Write-Host " [Spicetify] Updating Spicetify..." -ForegroundColor Yellow
        & $spicetifyPath upgrade
    }

    if (Test-Path $spicetifyPath) {
        Write-Host " [Spicetify] Applying changes..." -ForegroundColor Yellow

        $spicetifyBackup = Join-Path $env:USERPROFILE '.spicetify\Backup'
        if (Test-Path $spicetifyBackup) {
            Remove-Item -Recurse -Force $spicetifyBackup -ErrorAction SilentlyContinue
        }

        & $spicetifyPath backup apply

        Write-Host " [Spicetify] Integration complete." -ForegroundColor Green
    }
    $zip.Dispose()
    Copy-Item $xpui_spa_patch $bak_spa

    if ($spotify_binary_bak -eq $dll_bak) {
        Copy-Item $spotifyExecutable $exe_bak
        Copy-Item $chrome_elf $chrome_elf_bak

    }

    # Remove all languages except En and Ru from xpui.spa
    if ($ru) {
        $null = [Reflection.Assembly]::LoadWithPartialName('System.IO.Compression')
        $stream = New-Object IO.FileStream($xpui_spa_patch, [IO.FileMode]::Open)
        $mode = [IO.Compression.ZipArchiveMode]::Update
        $zip_xpui = New-Object IO.Compression.ZipArchive($stream, $mode)

        ($zip_xpui.Entries | Where-Object { $_.FullName -match "i18n" -and $_.FullName -inotmatch "(ru|en.json|longest)" }) | foreach { $_.Delete() }

        $zip_xpui.Dispose()
        $stream.Close()
        $stream.Dispose()
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
    $contents = "fix-old-theme"
    extract -counts 'one' -method 'zip' -name 'xpui.css' -helper "FixCss"

    # Remove RTL and minification of all *.css
    extract -counts 'more' -name '*.css' -helper 'Cssmin'
    
    # licenses.html minification

    extract -counts 'one' -method 'zip' -name 'licenses.html' -helper 'HtmlLicMin'
    # blank.html minification
    extract -counts 'one' -method 'zip' -name 'blank.html' -helper 'HtmlBlank'
    
    if ($ru) {
        # Additional translation of the ru.json file
        extract -counts 'more' -name '*ru.json' -helper 'RuTranslate'
    }
    # Minification of all *.json
    extract -counts 'more' -name '*.json' -helper 'MinJson'
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
    Pause
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

    if (Get-ItemProperty -Path $keyPath -Name $keyName -ErrorAction SilentlyContinue) {
        Remove-ItemProperty -Path $keyPath -Name $keyName -Force
    } 

    if (-not (Test-Path $prefsPath)) {
        $content = "app.autostart-configured=true`napp.autostart-mode=`"off`""
        [System.IO.File]::WriteAllLines($prefsPath, $content, [System.Text.UTF8Encoding]::new($false))
    }
    else {
        $content = [System.IO.File]::ReadAllText($prefsPath)
        if (-not $content.EndsWith("`n")) { $content += "`n" }
        $content += 'app.autostart-mode="off"'
        [System.IO.File]::WriteAllText($prefsPath, $content, [System.Text.UTF8Encoding]::new($false))
    }
}

if ($start_spoti) {
    Start-Process -WorkingDirectory $spotifyDirectory -FilePath $spotifyExecutable
}

Write-Host "Installation Completed Successfully." -ForegroundColor Green
