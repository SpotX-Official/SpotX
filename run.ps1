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

    [Parameter(HelpMessage = 'Enable Outline VPN configuration (Presets Socks5 localhost).')]
    [switch]$outline,

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
if ($outline) {
    if ($PSBoundParameters.ContainsKey('ProxyType') -eq $false) {
        $ProxyType = 'socks5'
    }
    if ([string]::IsNullOrWhiteSpace($ProxyHost)) {
        $ProxyHost = '127.0.0.1'
    }
    if (-not $ProxyPort) {
        Write-Host "Outline VPN detected." -ForegroundColor Yellow
        Write-Host "You can use one of these free Access Keys with your Outline Client:" -ForegroundColor Cyan
        Write-Host "Poland Server 1: ss://Y2hhY2hhMjAtaWV0Zi1wb2x5MTMwNTpwdmd6OXBx@pl134.vpnbook.com:443/?outline=1" -ForegroundColor White
        Write-Host "Poland Server 2: ss://Y2hhY2hhMjAtaWV0Zi1wb2x5MTMwNTpwdmd6OXBx@pl140.vpnbook.com:443/?outline=1" -ForegroundColor White
        Write-Host "Canada Server 1: ss://Y2hhY2hhMjAtaWV0Zi1wb2x5MTMwNTpwdmd6OXBx@ca225.vpnbook.com:443/?outline=1" -ForegroundColor White
        Write-Host "Please enter the local SOCKS5 port from your Outline Client." -ForegroundColor Yellow
        $ProxyPort = Read-Host "Port"
    }
}

function Stop-Spotify {
    Write-Host "Stopping Spotify..." -ForegroundColor Yellow
    Get-Process -Name Spotify -ErrorAction SilentlyContinue | Stop-Process -Force
    Get-Process -Name SpotifyWebHelper -ErrorAction SilentlyContinue | Stop-Process -Force
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

    # Restore xpui.spa (Fixes 'Black Screen' errors caused by bad JS patching)
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
    if (Test-Path $spotifyExecutable) {
        try {
            $bytes = [System.IO.File]::ReadAllBytes($spotifyExecutable)
            $peHeader = [System.BitConverter]::ToUInt16($bytes, 0x3C)
            $machine = [System.BitConverter]::ToUInt16($bytes, $peHeader + 4)
            $is64Bit = $machine -eq 0x8664
        } catch {
            $is64Bit = $true # Default to x64 if check fails
        }
    } else {
        Write-Warning "Spotify.exe not found. Is Spotify installed?"
        return
    }

    $btsZip = Join-Path ([System.IO.Path]::GetTempPath()) 'chrome_elf.zip'
    
    if ($is64Bit) {
        $btsUrl = 'https://github.com/mrpond/BlockTheSpot/releases/latest/download/chrome_elf.zip'
        Write-Host "Detected x64 architecture." -ForegroundColor Green
    } else {
        $btsUrl = 'https://github.com/mrpond/BlockTheSpot/releases/download/2023.5.20.80/chrome_elf.zip'
        Write-Warning "Detected x86 architecture. Using legacy BlockTheSpot."
    }

    try {
        Invoke-WebRequest -Uri $btsUrl -OutFile $btsZip -UseBasicParsing
        
        if (Test-Path $btsZip) {
            Expand-Archive -Force -LiteralPath $btsZip -DestinationPath $spotifyDirectory
            Write-Host "BlockTheSpot installed successfully." -ForegroundColor Green
            Remove-Item $btsZip -Force -ErrorAction SilentlyContinue
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

# --- Main Execution ---

Stop-Spotify
Restore-Backups

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
