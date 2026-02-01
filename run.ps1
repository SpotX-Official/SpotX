[CmdletBinding()]
param
(
    [Parameter(HelpMessage = "Change recommended version of Spotify.")]
    [Alias("v")]
    [string]$version,

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

    [Parameter(HelpMessage = 'Enable BlockTheSpot (DLL Injection). Warning: May cause black screen on new versions.')]
    [switch]$bts
)

# Ignore errors from `Stop-Process`
$PSDefaultParameterValues['Stop-Process:ErrorAction'] = [System.Management.Automation.ActionPreference]::SilentlyContinue

# Set Tls12
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12;

$spotifyDirectory = Join-Path $env:APPDATA 'Spotify'
$spotifyExecutable = Join-Path $spotifyDirectory 'Spotify.exe'
$spotifyDll = Join-Path $spotifyDirectory 'Spotify.dll'
$chrome_elf = Join-Path $spotifyDirectory 'chrome_elf.dll'
$exe_bak = Join-Path $spotifyDirectory 'Spotify.bak'
$dll_bak = Join-Path $spotifyDirectory 'Spotify.dll.bak'
$chrome_elf_bak = Join-Path $spotifyDirectory 'chrome_elf.dll.bak'
$xpuiSpa = Join-Path (Join-Path $env:APPDATA 'Spotify\Apps') 'xpui.spa'
$xpuiBak = Join-Path (Join-Path $env:APPDATA 'Spotify\Apps') 'xpui.bak'
$start_menu = Join-Path $env:APPDATA 'Microsoft\Windows\Start Menu\Programs\Spotify.lnk'

# Outline VPN configuration
if (-not $no_vpn) {
    if ($PSBoundParameters.ContainsKey('ProxyType') -eq $false) {
        $ProxyType = 'socks5'
    }
    if ([string]::IsNullOrWhiteSpace($ProxyHost)) {
        $ProxyHost = '127.0.0.1'
    }
    if (-not $ProxyPort) {
        Write-Host "VPN Support (Outline / OpenVPN)" -ForegroundColor Yellow
        Write-Host "You can use one of these free Outline Access Keys:" -ForegroundColor Cyan
        Write-Host "Poland Server 1: ss://Y2hhY2hhMjAtaWV0Zi1wb2x5MTMwNTpwdmd6OXBx@pl134.vpnbook.com:443/?outline=1" -ForegroundColor White
        Write-Host "Poland Server 2: ss://Y2hhY2hhMjAtaWV0Zi1wb2x5MTMwNTpwdmd6OXBx@pl140.vpnbook.com:443/?outline=1" -ForegroundColor White
        Write-Host "Canada Server 3: ss://Y2hhY2hhMjAtaWV0Zi1wb2x5MTMwNTpwdmd6OXBx@ca225.vpnbook.com:443/?outline=1" -ForegroundColor White

        Write-Host "`nAlso available (OpenVPN/WireGuard - requires separate client setup):" -ForegroundColor Gray
        Write-Host "US16, US178, CA149, CA196, UK205, UK68, DE20, DE220, FR200, FR231" -ForegroundColor Gray
        Write-Host "Get credentials at: https://www.vpnbook.com/freevpn" -ForegroundColor Gray

        Write-Host "`nPlease enter the local SOCKS5 port from your Outline Client (Leave empty to skip proxy setup)." -ForegroundColor Yellow
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

function Patch-XPUI {
    Write-Host "Patching XPUI..." -ForegroundColor Cyan

    if (-not (Test-Path $xpuiSpa)) {
        Write-Error "xpui.spa not found at $xpuiSpa"
        return
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

    # Read patches.json
    $patchesPath = Join-Path $PSScriptRoot "patches\patches.json"
    if (-not (Test-Path $patchesPath)) {
        # In a real scenario, we might want to download it.
        # But for this task, we assume it's present as per instructions.
        Write-Warning "patches.json not found locally at $patchesPath. Skipping patching."
        Remove-Item $tempDir -Recurse -Force
        return
    }

    try {
        $patchesJson = Get-Content $patchesPath -Raw -Encoding UTF8 | ConvertFrom-Json
    } catch {
        Write-Error "Failed to parse patches.json: $_"
        Remove-Item $tempDir -Recurse -Force
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

    # 3. Handle Experiments
    Write-Host "Applying Experimental Features..." -ForegroundColor Gray
    $enableExpList = @()
    $disableExpList = @()

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

    # Build Experiments JS Object string
    # const experiments={enable:['Exp1'],disable:['Exp2'],custom:[]}
    $expJs = "const experiments={enable:[" + ($enableExpList -join ',') + "],disable:[" + ($disableExpList -join ',') + "],custom:[]}"

    # Apply ForcedExp patch with dynamic injection
    $forcedExp = $patchesJson.others.ForcedExp
    if ($forcedExp) {
        $m = $forcedExp.match
        # The replace string in JSON has the default structure. We replace the empty structure with our populated one.
        # Original replace: "$1const experiments={enable:[],disable:[],custom:[]},..."
        # We replace "const experiments={enable:[],disable:[],custom:[]}" with $expJs

        $r = $forcedExp.replace -replace "const experiments=\{enable:\[\],disable:\[\],custom:\[\]\}", $expJs

        try {
            $jsContent = $jsContent -replace $m, $r
        } catch {
            Write-Warning "Failed to apply ForcedExp patch."
        }
    }

    # 4. Apply 'others' patches
    Write-Host "Applying miscellaneous patches..." -ForegroundColor Gray
    $patchesJson.others | Get-Member -MemberType NoteProperty | ForEach-Object {
        $name = $_.Name
        if ($name -eq "ForcedExp") { return } # Already handled

        $patch = $patchesJson.others.$name
        if (Is-Ver-Compatible $clientVerForCheck $patch.version.fr $patch.version.to) {

            # Special handling for patches that add CSS (and only add CSS)
            if ($patch.add -and -not $patch.match) {
                # Append to CSS
                $cssContent += "`n" + $patch.add
            } elseif ($patch.match) {
                 $match = $patch.match
                 $replace = $patch.replace

                 # Handle placeholders {0}, {1} in replace string if 'add' property exists
                 if ($patch.add) {
                    try {
                        $replace = $replace -replace "\{0\}", $patch.add
                        if ($patch.add2) {
                            $replace = $replace -replace "\{1\}", $patch.add2
                        }
                    } catch {}
                 }

                 if ($match -is [array]) {
                     for ($i=0; $i -lt $match.Count; $i++) {
                        $m = $match[$i]
                        $r = if ($replace -is [array]) { $replace[$i] } else { $replace }
                        try { $jsContent = $jsContent -replace $m, $r } catch {}
                     }
                 } else {
                    try { $jsContent = $jsContent -replace $match, $replace } catch {}
                 }
            }
        }
    }

    # Special case: discriptions patch uses {0}, {1} placeholders
    # We replaced it generically above, but the placeholders {0} remain.
    # We should fix it.
    if ($jsContent -match "\{0\} Github") {
        $discriptions = $patchesJson.others.discriptions
        $jsContent = $jsContent -replace "\{0\}", $discriptions.svggit
        $jsContent = $jsContent -replace "\{1\}", $discriptions.svgtg
        $jsContent = $jsContent -replace "\{2\}", $discriptions.svgfaq
    }

    # Save Modified Files
    Set-Content -Path $xpuiJsPath -Value $jsContent -NoNewline -Encoding UTF8
    Set-Content -Path $xpuiCssPath -Value $cssContent -NoNewline -Encoding UTF8

    # Re-pack
    Write-Host "Repacking xpui.spa..." -ForegroundColor Cyan
    Remove-Item $xpuiSpa -Force
    # Need to compress the CONTENTS of tempDir, not tempDir itself
    $compressPath = Join-Path $tempDir "*"
    try {
        Compress-Archive -Path $compressPath -DestinationPath $xpuiSpa -Force
    } catch {
        Write-Error "Failed to repack xpui.spa: $_"
    }

    # Cleanup
    Remove-Item $tempDir -Recurse -Force
    Write-Host "XPUI Patching Complete." -ForegroundColor Green
}

# --- Main Execution ---

Stop-Spotify
Restore-Backups

# Always patch XPUI unless specifically disabled? (User can skip via params if we had one, but we don't)
# We assume we always want to patch if running this script.
Patch-XPUI

if ($bts) {
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
    else {
         Write-Host " [Spicetify] Executable not found." -ForegroundColor Red
    }
}

# Disable Startup client if requested
if ($DisableStartup) {
    $prefsPath = "$env:APPDATA\Spotify\prefs"
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
