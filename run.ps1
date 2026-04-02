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

    [Parameter(HelpMessage = 'Disable BlockTheSpot (DLL Injection) and use native binary patching instead.')]
    [switch]$no_bts
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

# Function to show VPN Server Selection UI
# This launches an interactive HTML UI to help users browse and select VPN servers
# The UI is informative and displays all available servers from vpnbook.com
# Note: Opens in default browser as a visual guide; users still configure via PowerShell prompts
function Show-VPNServerUI {
    $vpnHtmlPath = Join-Path $PSScriptRoot "vpn-selector.html"
    
    if (Test-Path $vpnHtmlPath) {
        Write-Host "`nLaunching VPN Server Selection UI..." -ForegroundColor Cyan
        Write-Host "Opening VPN selector in your default browser..." -ForegroundColor Yellow
        
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

function Get-LatestSpotifyVersion {
    <#
    .SYNOPSIS
    Checks loadspot.pages.dev for the latest Spotify version
    
    .DESCRIPTION
    Fetches version information from loadspot.pages.dev to determine 
    the latest available Spotify version and download URL.
    
    .OUTPUTS
    Hashtable with 'Version' and 'Url' properties, or $null if check fails
    #>
    
    $updateUrl = 'https://loadspot.pages.dev/'
    $tempPath = if ($env:TEMP) { $env:TEMP } else { [System.IO.Path]::GetTempPath() }
    $cacheFile = Join-Path $tempPath 'spotfreedom_version_cache.txt'
    $cacheAge = 3600 # Cache for 1 hour
    
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
    $enableExpList = [System.Collections.Generic.List[string]]::new()
    $disableExpList = [System.Collections.Generic.List[string]]::new()

    # Collect EnableExp
    $patchesJson.EnableExp | Get-Member -MemberType NoteProperty | ForEach-Object {
        $name = $_.Name
        $patch = $patchesJson.EnableExp.$name
        if (Is-Ver-Compatible $clientVerForCheck $patch.version.fr $patch.version.to) {
            # Use 'name' property from JSON object, fallback to key name
            $expName = if ($patch.name) { $patch.name } else { $name }
            $enableExpList.Add("'$expName'")
        }
    }

    # Collect DisableExp
    $patchesJson.DisableExp | Get-Member -MemberType NoteProperty | ForEach-Object {
        $name = $_.Name
        $patch = $patchesJson.DisableExp.$name
        if (Is-Ver-Compatible $clientVerForCheck $patch.version.fr $patch.version.to) {
             $expName = if ($patch.name) { $patch.name } else { $name }
             $disableExpList.Add("'$expName'")
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

# Load Patches
$patchesPath = Join-Path $PSScriptRoot "patches\patches.json"
if (-not (Test-Path $patchesPath)) {
    Write-Error "patches.json not found locally at $patchesPath."
    exit 1
}
try {
    $patchesJson = Get-Content $patchesPath -Raw -Encoding UTF8 | ConvertFrom-Json
} catch {
    Write-Error "Failed to parse patches.json: $_"
    exit 1
}

# Check for latest Spotify version from loadspot.pages.dev
$latestVersionInfo = Get-LatestSpotifyVersion
if ($latestVersionInfo) {
    $currentVersion = Get-SpotifyVersion
    if ($currentVersion) {
        Write-Host "Current Spotify version: $currentVersion" -ForegroundColor Cyan
        
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
