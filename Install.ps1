param (
    [Parameter()]
    [switch]
    $podcasts_off = $false,
    [Parameter()]
    [switch]
    $podcasts_on = $false,
    [Parameter()]
    [switch]
    $block_update_on = $false,
    [Parameter()]
    [switch]
    $block_update_off = $false,
    [Parameter()]
    [switch]
    $cache_on = $false,
    [int] $number_days = 7,
    [Parameter()]
    [switch]
    $cache_off = $false,
    [Parameter()]
    [switch]
    $confirm_uninstall_ms_spoti = $false,
    [Parameter()]
    [switch]
    $confirm_spoti_recomended_over = $false,
    [Parameter()]
    [switch]
    $confirm_spoti_recomended_unistall = $false,
    [Parameter()]
    [switch]
    $premium = $false,
    [Parameter()]
    [switch]
    $start_spoti = $false,
    [Parameter()]
    [switch]
    $exp_off = $false,
    [Parameter()]
    [switch]
    $hide_col_icon_off = $false,
    [Parameter()]
    [switch]
    $made_for_you_off = $false,
    [Parameter()]
    [switch]
    $new_search_off = $false,
    [Parameter()]
    [switch]
    $enhance_playlist_off = $false,
    [Parameter()]
    [switch]
    $enhance_like_off = $false,
    [Parameter()]
    [switch]
    $new_artist_pages_off = $false,
    [Parameter()]
    [switch]
    $new_lyrics_off = $false,
    [Parameter()]
    [switch]
    $ignore_in_recommendations_off = $false
    
)

# Ignore errors from `Stop-Process`
$PSDefaultParameterValues['Stop-Process:ErrorAction'] = [System.Management.Automation.ActionPreference]::SilentlyContinue

Write-Host "*****************"
Write-Host "Author: " -NoNewline
Write-Host "@Amd64fox" -ForegroundColor DarkYellow
Write-Host "*****************"`n

$ErrorActionPreference = 'SilentlyContinue'
$cutt_url = "https://cutt.ly/AKH7MQ6"
try {  
    Invoke-WebRequest -Uri $cutt_url | Out-Null
}
catch [System.Management.Automation.MethodInvocationException] {

    try { 
        Invoke-WebRequest -Uri $cutt_url | Out-Null
    }
    catch [System.Management.Automation.MethodInvocationException] {
    }
}

$spotifyDirectory = "$env:APPDATA\Spotify"
$spotifyDirectory2 = "$env:LOCALAPPDATA\Spotify"
$spotifyExecutable = "$spotifyDirectory\Spotify.exe"
$chrome_elf = "$spotifyDirectory\chrome_elf.dll"
$chrome_elf_bak = "$spotifyDirectory\chrome_elf_bak.dll"
$cache_folder = "$env:APPDATA\Spotify\cache"
$spotifyUninstall = "$env:TEMP\SpotifyUninstall.exe"
$verPS = $PSVersionTable.PSVersion.major
$upgrade_client = $false

function incorrectValue {

    Write-Host "Oops, an incorrect value, " -ForegroundColor Red -NoNewline
    Write-Host "enter again through " -NoNewline
    Start-Sleep -Milliseconds 1000
    Write-Host "3" -NoNewline 
    Start-Sleep -Milliseconds 1000
    Write-Host " 2" -NoNewline
    Start-Sleep -Milliseconds 1000
    Write-Host " 1"
    Start-Sleep -Milliseconds 1000     
    Clear-Host
}     

function Check_verison_clients($param2) {

    # checking the recommended version for spotx
    if ($param2 -eq "online") {
        $ProgressPreference = 'SilentlyContinue' # Hiding Progress Bars
        $readme = Invoke-WebRequest -UseBasicParsing -Uri https://raw.githubusercontent.com/amd64fox/SpotX/main/README.md
        $v = $readme.RawContent | Select-String "Recommended official version \[\d+\.\d+\.\d+\.\d+\]" -AllMatches
        $ver = $v.Matches.Value
        $ver = $ver -replace 'Recommended official version \[(\d+\.\d+\.\d+\.\d+)\]', '$1'
        return $ver
    }
    # Check version Spotify offline
    if ($param2 -eq "offline") {
        $check_offline = (Get-Item $spotifyExecutable).VersionInfo.FileVersion
        return $check_offline
    }
}
function unlockFolder {

    $ErrorActionPreference = 'SilentlyContinue'
    $block_File_update = "$env:LOCALAPPDATA\Spotify\Update"
    $Check_folder = Get-ItemProperty -Path $block_File_update | Select-Object Attributes 
    $folder_update_access = Get-Acl $block_File_update

    # Check folder Update if it exists
    if ($Check_folder -match '\bDirectory\b') {  

        # If the rights of the Update folder are blocked, then unblock 
        if ($folder_update_access.AccessToString -match 'Deny') {
                ($ACL = Get-Acl $block_File_update).access | ForEach-Object {
                $Users = $_.IdentityReference 
                $ACL.PurgeAccessRules($Users) }
            $ACL | Set-Acl $block_File_update
        }
    }
}     

function downloadScripts($param1) {

    $webClient = New-Object -TypeName System.Net.WebClient

    if ($param1 -eq "Desktop") {
        Import-Module BitsTransfer
        
        $ver = Check_verison_clients -param2 "online"
        $l = "$PWD\links.tsv"
        $old = [IO.File]::ReadAllText($l)
        $links = $old -match "https:\/\/upgrade.scdn.co\/upgrade\/client\/win32-x86\/spotify_installer-$ver\.g[0-9a-f]{8}-[0-9]{1,3}\.exe" 
        $links = $Matches.Values
    }
    
    $web_Url_prev = "https://github.com/mrpond/BlockTheSpot/releases/latest/download/chrome_elf.zip", $links, `
        "https://raw.githubusercontent.com/amd64fox/SpotX/main/Cache/cache_spotify.ps1", "https://raw.githubusercontent.com/amd64fox/SpotX/main/Cache/hide_window.vbs", `
        "https://raw.githubusercontent.com/amd64fox/SpotX/main/Cache/run_ps.bat", "https://docs.google.com/spreadsheets/d/e/2PACX-1vSFN2hWu4UO-ZWyVe8wlP9c0JsrduA49xBnRmSLOt8SWaOfIpCwjDLKXMTWJQ5aKj3WakQv6-Hnv9rz/pub?gid=0&single=true&output=tsv"

    $local_Url_prev = "$PWD\chrome_elf.zip", "$PWD\SpotifySetup.exe", "$cache_folder\cache_spotify.ps1", "$cache_folder\hide_window.vbs", "$cache_folder\run_ps.bat", "$PWD\links.tsv"
    $web_name_file_prev = "chrome_elf.zip", "SpotifySetup.exe", "cache_spotify.ps1", "hide_window.vbs", "run_ps.bat", "links.tsv"

    switch ( $param1 ) {
        "BTS" { $web_Url = $web_Url_prev[0]; $local_Url = $local_Url_prev[0]; $web_name_file = $web_name_file_prev[0] }
        "Desktop" { $web_Url = $web_Url_prev[1]; $local_Url = $local_Url_prev[1]; $web_name_file = $web_name_file_prev[1] }
        "cache-spotify" { $web_Url = $web_Url_prev[2]; $local_Url = $local_Url_prev[2]; $web_name_file = $web_name_file_prev[2] }
        "hide_window" { $web_Url = $web_Url_prev[3]; $local_Url = $local_Url_prev[3]; $web_name_file = $web_name_file_prev[3] }
        "run_ps" { $web_Url = $web_Url_prev[4]; $local_Url = $local_Url_prev[4]; $web_name_file = $web_name_file_prev[4] } 
        "links.tsv" { $web_Url = $web_Url_prev[5]; $local_Url = $local_Url_prev[5]; $web_name_file = $web_name_file_prev[5] }
    }

    if ($param1 -eq "Desktop") {
        try { if (curl.exe -V) { $curl_check = $true } }
        catch { $curl_check = $false }
        $vernew = Check_verison_clients -param2 "online"
    }
    try { 
        if ($param1 -eq "Desktop" -and $curl_check) {
            curl.exe $web_Url -o $local_Url --progress-bar --retry 3 --ssl-no-revoke
        }
        if ($param1 -eq "Desktop" -and $null -ne (Get-Module -Name BitsTransfer -ListAvailable) -and !($curl_check )) {
            Start-BitsTransfer -Source  $web_Url -Destination $local_Url  -DisplayName "Downloading Spotify" -Description "$vernew "
        }
        if ($param1 -eq "Desktop" -and $null -eq (Get-Module -Name BitsTransfer -ListAvailable) -and !($curl_check )) {
            $webClient.DownloadFile($web_Url, $local_Url) 
        }
        if ($param1 -ne "Desktop") {
            $ProgressPreference = 'SilentlyContinue' # Hiding Progress Bars
            $webClient.DownloadFile($web_Url, $local_Url) 
        }
    }

    catch [System.Management.Automation.MethodInvocationException] {
        Write-Host ""
        Write-Host "Error downloading" $web_name_file -ForegroundColor RED
        $Error[0].Exception
        Write-Host ""
        Write-Host "Will re-request in 5 seconds..."`n
        Start-Sleep -Milliseconds 5000 
        try { 

            if ($param1 -eq "Desktop" -and $curl_check) {
                curl.exe $web_Url -o $local_Url --progress-bar --retry 3 --ssl-no-revoke
            }
            if ($param1 -eq "Desktop" -and $null -ne (Get-Module -Name BitsTransfer -ListAvailable) -and !($curl_check )) {
                Start-BitsTransfer -Source  $web_Url -Destination $local_Url  -DisplayName "Downloading Spotify" -Description "$vernew "
            }
            if ($param1 -eq "Desktop" -and $null -eq (Get-Module -Name BitsTransfer -ListAvailable) -and !($curl_check )) {
                $webClient.DownloadFile($web_Url, $local_Url) 
            }
            if ($param1 -ne "Desktop") {
                $ProgressPreference = 'SilentlyContinue' # Hiding Progress Bars
                $webClient.DownloadFile($web_Url, $local_Url) 
            }

        }
        
        catch [System.Management.Automation.MethodInvocationException] {
            Write-Host "Error again, script stopped"`n -ForegroundColor RED
            $Error[0].Exception
            Write-Host "Try to check your internet connection and run the installation again."`n
            $tempDirectory = $PWD
            Pop-Location
            Start-Sleep -Milliseconds 200
            Remove-Item -Recurse -LiteralPath $tempDirectory 
            exit
        }
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

# add Tls12
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Stop-Process -Name Spotify

if ($verPS -lt 3) {
    do {
        Write-Host "Your version of PowerShell $verPS is not supported"`n
        $ch = Read-Host -Prompt "Please read the instruction 'Outdated versions of PowerShell' `nOpen a page with instructions ? (Y/N)"
        Write-Host ""
        if (!($ch -eq 'n' -or $ch -eq 'y')) { incorrectValue }
    }
    while ($ch -notmatch '^y$|^n$')
    if ($ch -eq 'y') {
        Start-Process "https://github.com/amd64fox/SpotX#possible-problems"
        Write-Host "script is stopped" 
        exit
    }
    if ($ch -eq 'n') {
        Write-Host "script is stopped" 
        exit
    }
}
if ($verPS -ge 7) {
    Import-Module Appx -UseWindowsPowerShell -WarningAction:SilentlyContinue
}

# Check version Windows
$win_os = (get-itemproperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name ProductName).ProductName
$win11 = $win_os -match "\windows 11\b"
$win10 = $win_os -match "\windows 10\b"
$win8_1 = $win_os -match "\windows 8.1\b"
$win8 = $win_os -match "\windows 8\b"

if ($win11 -or $win10 -or $win8_1 -or $win8) {

    # Remove Spotify Windows Store If Any
    if (Get-AppxPackage -Name SpotifyAB.SpotifyMusic) {
        Write-Host 'The Microsoft Store version of Spotify has been detected which is not supported.'`n
        
        if (!($confirm_uninstall_ms_spoti)) {
            do {
                $ch = Read-Host -Prompt "Uninstall Spotify Windows Store edition (Y/N) "
                Write-Host ""
                if (!($ch -eq 'n' -or $ch -eq 'y')) {
                    incorrectValue
                }
            }
    
            while ($ch -notmatch '^y$|^n$')
        }
        if ($confirm_uninstall_ms_spoti) { $ch = 'y' }
        if ($ch -eq 'y') {      
            $ProgressPreference = 'SilentlyContinue' # Hiding Progress Bars
            if ($confirm_uninstall_ms_spoti) { Write-Host 'Automatic uninstalling Spotify MS...'`n }
            if (!($confirm_uninstall_ms_spoti)) { Write-Host 'Uninstalling Spotify MS...'`n }
            Get-AppxPackage -Name SpotifyAB.SpotifyMusic | Remove-AppxPackage
        }
        if ($ch -eq 'n') {
            Write-Host "script is stopped" 
            exit
        }
    }
}

# Unique directory name based on time
Push-Location -LiteralPath $env:TEMP
New-Item -Type Directory -Name "SpotX_Temp-$(Get-Date -UFormat '%Y-%m-%d_%H-%M-%S')" | Convert-Path | Set-Location

if ($premium) {
    Write-Host 'Modification for premium account...'`n
}
if (!($premium)) {
    Write-Host 'Downloading latest patch BTS...'`n
    downloadScripts -param1 "BTS"
    Add-Type -Assembly 'System.IO.Compression.FileSystem'
    $zip = [System.IO.Compression.ZipFile]::Open("$PWD\chrome_elf.zip", 'read')
    [System.IO.Compression.ZipFileExtensions]::ExtractToDirectory($zip, $PWD)
    $zip.Dispose()
}
downloadScripts -param1 "links.tsv"


$online = Check_verison_clients -param2 "online"

$spotifyInstalled = (Test-Path -LiteralPath $spotifyExecutable)

if ($spotifyInstalled) {

    $offline = Check_verison_clients -param2 "offline"

    if ($online -gt $offline) {
        if ($confirm_spoti_recomended_over -or $confirm_spoti_recomended_unistall) {
            Write-Host "Found outdated version of Spotify"`n
        }
        if (!($confirm_spoti_recomended_over) -and !($confirm_spoti_recomended_unistall)) {
            do {
                $ch = Read-Host -Prompt "Your Spotify $offline version is outdated, it is recommended to upgrade to $online `nWant to update ? (Y/N)"
                Write-Host ""
                if (!($ch -eq 'n' -or $ch -eq 'y')) {
                    incorrectValue
                }
            }
            while ($ch -notmatch '^y$|^n$')
        }
        if ($confirm_spoti_recomended_over -or $confirm_spoti_recomended_unistall) { 
            $ch = 'y' 
            Write-Host "Automatic update to the recommended version"`n
        }
        if ($ch -eq 'y') { 
            $upgrade_client = $true 

            if (!($confirm_spoti_recomended_over) -and !($confirm_spoti_recomended_unistall)) {
                do {
                    $ch = Read-Host -Prompt "Do you want to uninstall the current version of $offline or install over it? Y [Uninstall] / N [Install Over]"
                    Write-Host ""
                    if (!($ch -eq 'n' -or $ch -eq 'y')) {
                        incorrectValue
                    }
                }
                while ($ch -notmatch '^y$|^n$')
            }
            if ($confirm_spoti_recomended_unistall) { $ch = 'y' }
            if ($confirm_spoti_recomended_over) { $ch = 'n' }
            if ($ch -eq 'y') {
                Write-Host "Uninstalling old Spotify..."`n
                unlockFolder
                cmd /c $spotifyExecutable /UNINSTALL /SILENT
                wait-process -name SpotifyUninstall
                Start-Sleep -Milliseconds 200
                if (Test-Path $spotifyDirectory) { Remove-Item -Recurse -Force -LiteralPath $spotifyDirectory }
                if (Test-Path $spotifyDirectory2) { Remove-Item -Recurse -Force -LiteralPath $spotifyDirectory2 }
                if (Test-Path $spotifyUninstall ) { Remove-Item -Recurse -Force -LiteralPath $spotifyUninstall }
            }
            if ($ch -eq 'n') { $ch = $null }
        }
        if ($ch -eq 'n') { 
            $downgrading = $true
        }
    }

    if ($online -lt $offline) {

        if ($confirm_spoti_recomended_over -or $confirm_spoti_recomended_unistall) {
            Write-Host "Unsupported version of Spotify found"`n
        }
        if (!($confirm_spoti_recomended_over) -and !($confirm_spoti_recomended_unistall)) {
            do {
                $ch = Read-Host -Prompt "Your Spotify $offline version hasn't been tested yet, currently it's a stable $online version. `nDo you want to continue with $offline  version (errors possible) ? (Y/N)"
                Write-Host ""
                if (!($ch -eq 'n' -or $ch -eq 'y')) {
                    incorrectValue
                }
            }
            while ($ch -notmatch '^y$|^n$')
        }
        if ($confirm_spoti_recomended_over -or $confirm_spoti_recomended_unistall) { $ch = 'n' }
        if ($ch -eq 'y') { $upgrade_client = $false }
        if ($ch -eq 'n') {
            if (!($confirm_spoti_recomended_over) -or !($confirm_spoti_recomended_unistall)) {
                do {
                    $ch = Read-Host -Prompt "Do you want to install the recommended $online version ? (Y/N)"
                    Write-Host ""
                    if (!($ch -eq 'n' -or $ch -eq 'y')) {
                        incorrectValue
                    }
                }
                while ($ch -notmatch '^y$|^n$')
            }
            if ($confirm_spoti_recomended_over -or $confirm_spoti_recomended_unistall) { 
                $ch = 'y' 
                Write-Host "Automatic update to the recommended version"`n
            }
            if ($ch -eq 'y') {
                $upgrade_client = $true
                $downgrading = $true
                if (!($confirm_spoti_recomended_over) -and !($confirm_spoti_recomended_unistall)) {
                    do {
                        $ch = Read-Host -Prompt "Do you want to uninstall the current version of $offline or install over it? Y [Uninstall] / N [Install Over]"
                        Write-Host ""
                        if (!($ch -eq 'n' -or $ch -eq 'y')) {
                            incorrectValue
                        }
                    }
                    while ($ch -notmatch '^y$|^n$')
                }
                if ($confirm_spoti_recomended_unistall) { $ch = 'y' }
                if ($confirm_spoti_recomended_over) { $ch = 'n' }
                if ($ch -eq 'y') {
                    Write-Host "Uninstalling an untested Spotify..."`n
                    unlockFolder
                    cmd /c $spotifyExecutable /UNINSTALL /SILENT
                    wait-process -name SpotifyUninstall
                    Start-Sleep -Milliseconds 200
                    if (Test-Path $spotifyDirectory) { Remove-Item -Recurse -Force -LiteralPath $spotifyDirectory }
                    if (Test-Path $spotifyDirectory2) { Remove-Item -Recurse -Force -LiteralPath $spotifyDirectory2 }
                    if (Test-Path $spotifyUninstall ) { Remove-Item -Recurse -Force -LiteralPath $spotifyUninstall }
                }
                if ($ch -eq 'n') { $ch = $null }
            }

            if ($ch -eq 'n') {
                Write-Host "script is stopped"
                $tempDirectory = $PWD
                Pop-Location
                Start-Sleep -Milliseconds 200
                Remove-Item -Recurse -LiteralPath $tempDirectory 
                Exit
            }
        }
    }
}
# If there is no client or it is outdated, then install
if (-not $spotifyInstalled -or $upgrade_client) {

    Write-Host "Downloading and installing Spotify " -NoNewline
    Write-Host  $online -ForegroundColor Green
    Write-Host "Please wait..."`n
    
    # Delete the files of the previous version of Spotify before installing, leave only the profile files
    $ErrorActionPreference = 'SilentlyContinue'  # extinguishes light mistakes
    Stop-Process -Name Spotify 
    Start-Sleep -Milliseconds 600
    unlockFolder
    Start-Sleep -Milliseconds 200
    Get-ChildItem $spotifyDirectory -Exclude 'Users', 'prefs', 'cache' | Remove-Item -Recurse -Force 
    Start-Sleep -Milliseconds 200

    # Client download
    downloadScripts -param1 "Desktop"
    Write-Host ""

    Start-Sleep -Milliseconds 200

    # Client installation
    Start-Process -FilePath explorer.exe -ArgumentList $PWD\SpotifySetup.exe
    while (-not (get-process | Where-Object { $_.ProcessName -eq 'SpotifySetup' })) {}
    wait-process -name SpotifySetup


    wait-process -name SpotifySetup
    Stop-Process -Name Spotify 

}

# Delete the leveldb folder (Fixes bug with incorrect experimental features for some accounts)
$leveldb = (Test-Path -LiteralPath "$spotifyDirectory2\Browser\Local Storage\leveldb")

if ($leveldb) {
    $ErrorActionPreference = 'SilentlyContinue'
    remove-item "$spotifyDirectory2\Browser\Local Storage\leveldb" -Recurse -Force
}

# Create backup chrome_elf.dll
if (!(Test-Path -LiteralPath $chrome_elf_bak) -and !($premium)) {
    Move-Item $chrome_elf $chrome_elf_bak 
}

$ch = $null

if ($podcasts_off) { 
    Write-Host "Off Podcasts"`n 
    $ch = 'y'
}
if ($podcasts_on) {
    Write-Host "On Podcasts"`n
    $ch = 'n'
}
if (!($podcasts_off) -and !($podcasts_on)) {

    do {
        $ch = Read-Host -Prompt "Want to turn off podcasts ? (Y/N)"
        Write-Host ""
        if (!($ch -eq 'n' -or $ch -eq 'y')) { incorrectValue }
    }
    while ($ch -notmatch '^y$|^n$')
}
if ($ch -eq 'y') { $podcast_off = $true }

$ch = $null

if ($downgrading) { $upd = "`nYou have had a downgrade of Spotify, it is recommended to block" }

else { $upd = "" }

if ($block_update_on) { 
    Write-Host "Updates blocked"`n
    $ch = 'y'
}
if ($block_update_off) {
    Write-Host "Updates are not blocked"`n
    $ch = 'n'
}
if (!($block_update_on) -and !($block_update_off)) {
    do {
        $ch = Read-Host -Prompt "Want to block updates ? (Y/N)$upd"
        Write-Host ""
        if (!($ch -eq 'n' -or $ch -eq 'y')) { incorrectValue } 
    }
    while ($ch -notmatch '^y$|^n$')
}
if ($ch -eq 'y') { $block_update = $true }

$ch = $null

if ($cache_on) { 
    Write-Host "Clear cache enabled ($number_days)"`n
    $cache_install = $true
}
if ($cache_off) { 
    Write-Host "Clearing the cache is not enabled"`n
    $ErrorActionPreference = 'SilentlyContinue'
    $desktop_folder = DesktopFolder
    if (Test-Path -LiteralPath $cache_folder) {
        remove-item $cache_folder -Recurse -Force
        remove-item $desktop_folder\Spotify.lnk -Recurse -Force
    } 
}
if (!($cache_on) -and !($cache_off)) {

    do {
        $ch = Read-Host -Prompt "Want to set up automatic cache cleanup? (Y/N)"
        Write-Host ""
        if (!($ch -eq 'n' -or $ch -eq 'y')) { incorrectValue }
    }
    while ($ch -notmatch '^y$|^n$')

    if ($ch -eq 'y') {
        $cache_install = $true 

        do {
            $ch = Read-Host -Prompt "Cache files that have not been used for more than XX days will be deleted.
    Enter the number of days from 1 to 100"
            Write-Host ""
            if (!($ch -match "^[1-9][0-9]?$|^100$")) { incorrectValue }
        }
        while ($ch -notmatch '^[1-9][0-9]?$|^100$')

        if ($ch -match "^[1-9][0-9]?$|^100$") { $number_days = $ch }
    }
    if ($ch -eq 'n') {
        $ErrorActionPreference = 'SilentlyContinue'
        $desktop_folder = DesktopFolder
        if (Test-Path -LiteralPath $cache_folder) {
            remove-item $cache_folder -Recurse -Force
            remove-item $desktop_folder\Spotify.lnk -Recurse -Force
        }
    }
}

function OffPodcasts {

    # Turn off podcasts
    $podcasts_off1 = 'withQueryParameters\(e\){return this.queryParameters=e,this}', 'withQueryParameters(e){return this.queryParameters=(e.types?{...e, types: e.types.split(",").filter(_ => !["episode","show"].includes(_)).join(",")}:e),this}'
    $podcasts_off2 = ',this[.]enableShows=[a-z]'

    if ($xpui_js -match $podcasts_off1[0]) { $xpui_js = $xpui_js -replace $podcasts_off1[0], $podcasts_off1[1] } else { Write-Host "Didn't find variable " -ForegroundColor red -NoNewline; Write-Host "`$podcasts_off1[0] in xpui.js" }
    if ($xpui_js -match $podcasts_off2) { $xpui_js = $xpui_js -replace $podcasts_off2, "" } else { Write-Host "Didn't find variable " -ForegroundColor red -NoNewline; Write-Host "`$podcasts_off2 in xpui.js" }
    $xpui_js
}

function OffAdsOnFullscreen {

    # Removing an empty block
    $empty_block_ad = 'adsEnabled:!0', 'adsEnabled:!1'

    # Full screen mode activation and removing "Upgrade to premium" menu, upgrade button
    $full_screen = '(return|.=.=>)"free"===(.+?)(return|.=.=>)"premium"===', '$1"premium"===$2$3"free"==='

    # Disabling a playlist sponsor
    $playlist_ad_off = "allSponsorships"

    if ($xpui_js -match $empty_block_ad[0]) { $xpui_js = $xpui_js -replace $empty_block_ad[0], $empty_block_ad[1] } else { Write-Host "Didn't find variable " -ForegroundColor red -NoNewline; Write-Host "`$empty_block_ad[0] in xpui.js" }
    if ($xpui_js -match $full_screen[0]) { $xpui_js = $xpui_js -replace $full_screen[0], $full_screen[1] } else { Write-Host "Didn't find variable " -ForegroundColor red -NoNewline; Write-Host "`$full_screen[0] in xpui.js" }
    if ($xpui_js -match $playlist_ad_off) { $xpui_js = $xpui_js -replace $playlist_ad_off, "" } else { Write-Host "Didn't find variable " -ForegroundColor red -NoNewline; Write-Host "`$playlist_ad_off in xpui.js" }
    $xpui_js
}
function ExpFeature {

    # Experimental Feature

    if (!($made_for_you_off)) { $exp_features1 = '(Show "Made For You" entry point in the left sidebar.,default:)(!1)', '$1!0' }
    if (!($new_search_off)) { $exp_features2 = '(Enable the new Search with chips experience",default:)(!1)', '$1!0' }
    $exp_features3 = '(Enable Liked Songs section on Artist page",default:)(!1)', '$1!0' 
    $exp_features4 = '(Enable block users feature in clientX",default:)(!1)', '$1!0' 
    $exp_features5 = '(Enables quicksilver in-app messaging modal",default:)(!0)', '$1!1' 
    $exp_features6 = '(With this enabled, clients will check whether tracks have lyrics available",default:)(!1)', '$1!0' 
    $exp_features7 = '(Enables new playlist creation flow in Web Player and DesktopX",default:)(!1)', '$1!0' 
    if (!($enhance_playlist_off)) { $exp_features8 = '(Enable Enhance Playlist UI and functionality for end-users",default:)(!1)', '$1!0' }
    if (!($new_artist_pages_off)) { $exp_features9 = '(Enable a condensed disography shelf on artist pages",default:)(!1)', '$1!0' }
    if (!($new_lyrics_off)) { $exp_features10 = '(Enable Lyrics match labels in search results",default:)(!1)', '$1!0' }
    if (!($ignore_in_recommendations_off)) { $exp_features11 = '(Enable Ignore In Recommendations for desktop and web",default:)(!1)', '$1!0' }
    $exp_features12 = '(Enable Playlist Permissions flows for Prod",default:)(!1)', '$1!0'
    #if (!($enhance_like_off)) {$exp_features13 = '(Enable Enhance Liked Songs UI and functionality",default:)(!1)', '$1!0'}

    if (!($made_for_you_off)) {
        if ($xpui_js -match $exp_features1[0]) { $xpui_js = $xpui_js -replace $exp_features1[0], $exp_features1[1] } else { Write-Host "Didn't find variable " -ForegroundColor red -NoNewline; Write-Host "`$exp_features1[0] in xpui.js" }
    }
    if (!($new_search_off)) {
        if ($xpui_js -match $exp_features2[0]) { $xpui_js = $xpui_js -replace $exp_features2[0], $exp_features2[1] } else { Write-Host "Didn't find variable " -ForegroundColor red -NoNewline; Write-Host "`$exp_features2[0] in xpui.js" }
    }
    if ($xpui_js -match $exp_features3[0]) { $xpui_js = $xpui_js -replace $exp_features3[0], $exp_features3[1] } else { Write-Host "Didn't find variable " -ForegroundColor red -NoNewline; Write-Host "`$exp_features3[0] in xpui.js" }
    if ($xpui_js -match $exp_features4[0]) { $xpui_js = $xpui_js -replace $exp_features4[0], $exp_features4[1] } else { Write-Host "Didn't find variable " -ForegroundColor red -NoNewline; Write-Host "`$exp_features4[0] in xpui.js" }
    if ($xpui_js -match $exp_features5[0]) { $xpui_js = $xpui_js -replace $exp_features5[0], $exp_features5[1] } else { Write-Host "Didn't find variable " -ForegroundColor red -NoNewline; Write-Host "`$exp_features5[0] in xpui.js" }
    if ($xpui_js -match $exp_features6[0]) { $xpui_js = $xpui_js -replace $exp_features6[0], $exp_features6[1] } else { Write-Host "Didn't find variable " -ForegroundColor red -NoNewline; Write-Host "`$exp_features6[0] in xpui.js" }
    if ($xpui_js -match $exp_features7[0]) { $xpui_js = $xpui_js -replace $exp_features7[0], $exp_features7[1] } else { Write-Host "Didn't find variable " -ForegroundColor red -NoNewline; Write-Host "`$exp_features7[0] in xpui.js" }
    if (!($enhance_playlist_off)) {
        if ($xpui_js -match $exp_features8[0]) { $xpui_js = $xpui_js -replace $exp_features8[0], $exp_features8[1] } else { Write-Host "Didn't find variable " -ForegroundColor red -NoNewline; Write-Host "`$exp_features8[0] in xpui.js" }
    }
    if (!($new_artist_pages_off)) {
        if ($xpui_js -match $exp_features9[0]) { $xpui_js = $xpui_js -replace $exp_features9[0], $exp_features9[1] } else { Write-Host "Didn't find variable " -ForegroundColor red -NoNewline; Write-Host "`$exp_features9[0] in xpui.js" }
    }
    if (!($new_lyrics_off)) {
        if ($xpui_js -match $exp_features10[0]) { $xpui_js = $xpui_js -replace $exp_features10[0], $exp_features10[1] } else { Write-Host "Didn't find variable " -ForegroundColor red -NoNewline; Write-Host "`$exp_features10[0] in xpui.js" }
    }
    if (!($ignore_in_recommendations_off)) {
        if ($xpui_js -match $exp_features11[0]) { $xpui_js = $xpui_js -replace $exp_features11[0], $exp_features11[1] } else { Write-Host "Didn't find variable " -ForegroundColor red -NoNewline; Write-Host "`$exp_features11[0] in xpui.js" }
    }
    if ($xpui_js -match $exp_features12[0]) { $xpui_js = $xpui_js -replace $exp_features12[0], $exp_features12[1] } else { Write-Host "Didn't find variable " -ForegroundColor red -NoNewline; Write-Host "`$exp_features12[0] in xpui.js" }
    #if(!($enhance_like_off)){
    #if ($xpui_js -match $exp_features13[0]) { $xpui_js = $xpui_js -replace $exp_features13[0], $exp_features13[1] } else { Write-Host "Didn't find variable " -ForegroundColor red -NoNewline; Write-Host "`$exp_features13[0] in xpui.js" }
    #}
    $xpui_js
}

function ContentsHtml {

    # Minification
    $html_lic_min1 = '<li><a href="#6eef7">zlib<\/a><\/li>\n(.|\n)*<\/p><!-- END CONTAINER DEPS LICENSES -->(<\/div>)'
    $html_lic_min2 = "	"
    $html_lic_min3 = "  "
    $html_lic_min4 = "(?m)(^\s*\r?\n)"
    $html_lic_min5 = "\r?\n(?!\(1|\d)"
    if ($xpuiContents_html -match $html_lic_min1) { $xpuiContents_html = $xpuiContents_html -replace $html_lic_min1, '$2' } else { Write-Host "Didn't find variable " -ForegroundColor red -NoNewline; Write-Host "`$html_lic_min1 in licenses.html" }
    if ($xpuiContents_html -match $html_lic_min2) { $xpuiContents_html = $xpuiContents_html -replace $html_lic_min2, "" } else { Write-Host "Didn't find variable " -ForegroundColor red -NoNewline; Write-Host "`$html_lic_min2 in licenses.html" }
    if ($xpuiContents_html -match $html_lic_min3) { $xpuiContents_html = $xpuiContents_html -replace $html_lic_min3, "" } else { Write-Host "Didn't find variable " -ForegroundColor red -NoNewline; Write-Host "`$html_lic_min3 in licenses.html" }
    if ($xpuiContents_html -match $html_lic_min4) { $xpuiContents_html = $xpuiContents_html -replace $html_lic_min4, "" } else { Write-Host "Didn't find variable " -ForegroundColor red -NoNewline; Write-Host "`$html_lic_min4 in licenses.html" }
    if ($xpuiContents_html -match $html_lic_min5) { $xpuiContents_html = $xpuiContents_html -replace $html_lic_min5, "" } else { Write-Host "Didn't find variable " -ForegroundColor red -NoNewline; Write-Host "`$html_lic_min5 in licenses.html" }
    $xpuiContents_html
}

Write-Host 'Patching Spotify...'`n

# Patching files
if (!($premium)) {
    $patchFiles = "$PWD\chrome_elf.dll", "$PWD\config.ini"
    Copy-Item -LiteralPath $patchFiles -Destination "$spotifyDirectory"
}
$tempDirectory = $PWD
Pop-Location

Start-Sleep -Milliseconds 200
Remove-Item -Recurse -LiteralPath $tempDirectory 

$xpui_spa_patch = "$env:APPDATA\Spotify\Apps\xpui.spa"
$xpui_js_patch = "$env:APPDATA\Spotify\Apps\xpui\xpui.js"
$xpui_css_patch = "$env:APPDATA\Spotify\Apps\xpui\xpui.css"
$xpui_lic_patch = "$env:APPDATA\Spotify\Apps\xpui\licenses.html"
$test_spa = Test-Path -Path $env:APPDATA\Spotify\Apps\xpui.spa
$test_js = Test-Path -Path $xpui_js_patch
$xpui_js_bak_patch = "$env:APPDATA\Spotify\Apps\xpui\xpui.js.bak"
$xpui_css_bak_patch = "$env:APPDATA\Spotify\Apps\xpui\xpui.css.bak"
$xpui_lic_bak_patch = "$env:APPDATA\Spotify\Apps\xpui\licenses.html.bak"
$spotify_exe_bak_patch = "$env:APPDATA\Spotify\Spotify.bak"


if ($test_spa -and $test_js) {
    Write-Host "Error" -ForegroundColor Red
    Write-Host "The location of Spotify files is broken, uninstall the client and run the script again."
    Write-Host "script is stopped."`n
    exit
}

if (Test-Path $xpui_js_patch) {
    Write-Host "Spicetify detected"`n

    $reader = New-Object -TypeName System.IO.StreamReader -ArgumentList $xpui_js_patch
    $xpui_test_js = $reader.ReadToEnd()
    $reader.Close()
        
    If ($xpui_test_js -match 'patched by spotx') {

        $test_xpui_js_bak = Test-Path -Path $xpui_js_bak_patch
        $test_xpui_css_bak = Test-Path -Path $xpui_css_bak_patch
        $test_xpui_lic_bak = Test-Path -Path $xpui_lic_bak_patch
        $test_spotify_exe_bak = Test-Path -Path $spotify_exe_bak_patch

        if ($test_xpui_js_bak -or $test_xpui_css_bak) {

            if ($test_xpui_js_bak) { 
                Remove-Item $xpui_js_patch -Recurse -Force
                Rename-Item $xpui_js_bak_patch $xpui_js_patch
            }
            if ($test_xpui_css_bak) {
                Remove-Item $xpui_css_patch -Recurse -Force
                Rename-Item $xpui_css_bak_patch $xpui_css_patch
            }
            if ($test_xpui_lic_bak) {
                Remove-Item $xpui_lic_patch -Recurse -Force
                Rename-Item $xpui_lic_bak_patch $xpui_lic_patch
            }
            if ($test_spotify_exe_bak) {
                Remove-Item $spotifyExecutable -Recurse -Force
                Rename-Item $spotify_exe_bak_patch $spotifyExecutable
            }
        }
        else {
            Write-Host "SpotX has already been installed, xpui.js and xpui.css not found. `nPlease uninstall Spotify client and run Install.bat again, script is stopped."`n
            exit
        }

    }

    Copy-Item $xpui_js_patch $xpui_js_bak_patch
    Copy-Item $xpui_css_patch $xpui_css_bak_patch
    Copy-Item $xpui_lic_patch $xpui_lic_bak_patch

    $reader = New-Object -TypeName System.IO.StreamReader -ArgumentList $xpui_js_patch
    $xpui_js = $reader.ReadToEnd()
    $reader.Close()

    # Turn off podcasts
    if ($Podcast_off) { $xpui_js = OffPodcasts }
    
    # Full screen mode activation and removing "Upgrade to premium" menu, upgrade button, disabling a playlist sponsor
    if (!($premium)) {
        $xpui_js = OffAdsOnFullscreen
    }
    # Experimental Feature
    if ($exp_off) { Write-Host "Experimental features disabled"`n }
    if (!($exp_off)) { $xpui_js = ExpFeature }

    $writer = New-Object System.IO.StreamWriter -ArgumentList $xpui_js_patch
    $writer.BaseStream.SetLength(0)
    $writer.Write($xpui_js)
    $writer.Write([System.Environment]::NewLine + '// Patched by SpotX') 
    $writer.Close()  

    # xpui.css
    $file_xpui_css = get-item $env:APPDATA\Spotify\Apps\xpui\xpui.css
    $reader = New-Object -TypeName System.IO.StreamReader -ArgumentList $file_xpui_css
    $xpuiContents_xpui_css = $reader.ReadToEnd()
    $reader.Close()

    $writer = New-Object System.IO.StreamWriter -ArgumentList $file_xpui_css
    $writer.BaseStream.SetLength(0)
    $writer.Write($xpuiContents_xpui_css)
    if (!($premium)) {
        # Hide download icon on different pages
        $writer.Write([System.Environment]::NewLine + ' .BKsbV2Xl786X9a09XROH{display:none}')
        # Hide submenu item "download"
        $writer.Write([System.Environment]::NewLine + ' button.wC9sIed7pfp47wZbmU6m.pzkhLqffqF_4hucrVVQA{display:none}')
    }
    # Hide Collaborators icon
    if (!($hide_col_icon_off) -and !($exp_off)) {
        $writer.Write([System.Environment]::NewLine + ' .X1lXSiVj0pzhQCUo_72A{display:none}')
    }
    # Hide broken podcast menu
    if ($podcast_off) { 
        $writer.Write([System.Environment]::NewLine + ' li.OEFWODerafYHGp09iLlA [href="/collection/podcasts"]{display:none}')
    }
    $writer.Close()

    # licenses.html minification
    $file_licenses = get-item $env:APPDATA\Spotify\Apps\xpui\licenses.html
    $reader = New-Object -TypeName System.IO.StreamReader -ArgumentList $file_licenses
    $xpuiContents_html = $reader.ReadToEnd()
    $reader.Close()
    $xpuiContents_html = ContentsHtml
    $writer = New-Object System.IO.StreamWriter -ArgumentList $file_licenses
    $writer.BaseStream.SetLength(0)
    $writer.Write($xpuiContents_html)
    $writer.Close()
}  

If (Test-Path $xpui_spa_patch) {

    $bak_spa = "$env:APPDATA\Spotify\Apps\xpui.bak"
    $test_bak_spa = Test-Path -Path $bak_spa

    # Make a backup copy of xpui.spa if it is original
    Add-Type -Assembly 'System.IO.Compression.FileSystem'
    $zip = [System.IO.Compression.ZipFile]::Open($xpui_spa_patch, 'update')
    $entry = $zip.GetEntry('xpui.js')
    $reader = New-Object System.IO.StreamReader($entry.Open())
    $patched_by_spotx = $reader.ReadToEnd()
    $reader.Close()

    If ($patched_by_spotx -match 'patched by spotx') {
        $zip.Dispose()  
        
        if ($test_bak_spa) {
            Remove-Item $xpui_spa_patch -Recurse -Force
            Rename-Item $bak_spa $xpui_spa_patch

            $spotify_exe_bak_patch = "$env:APPDATA\Spotify\Spotify.bak"
            $test_spotify_exe_bak = Test-Path -Path $spotify_exe_bak_patch
            if ($test_spotify_exe_bak) {
                Remove-Item $spotifyExecutable -Recurse -Force
                Rename-Item $spotify_exe_bak_patch $spotifyExecutable
            }
        }
        else {
            Write-Host "SpotX has already been installed, xpui.bak not found, please uninstall Spotify client and run Install.bat again, script is stopped."`n
            exit
        }
        $spotify_exe_bak_patch = "$env:APPDATA\Spotify\Spotify.bak"
        $test_spotify_exe_bak = Test-Path -Path $spotify_exe_bak_patch
        if ($test_spotify_exe_bak) {
            Remove-Item $spotifyExecutable -Recurse -Force
            Rename-Item $spotify_exe_bak_patch $spotifyExecutable
        }
    }
    $zip.Dispose()
    Copy-Item $xpui_spa_patch $env:APPDATA\Spotify\Apps\xpui.bak

    Add-Type -Assembly 'System.IO.Compression.FileSystem'
    $zip = [System.IO.Compression.ZipFile]::Open($xpui_spa_patch, 'update')
    
    # xpui.js
    $entry_xpui = $zip.GetEntry('xpui.js')
    $reader = New-Object System.IO.StreamReader($entry_xpui.Open())
    $xpui_js = $reader.ReadToEnd()
    $reader.Close()

    # Turn off podcasts
    if ($podcast_off) { $xpui_js = OffPodcasts }
        
    if (!($premium)) {
        # Full screen mode activation and removing "Upgrade to premium" menu, upgrade button, disabling a playlist sponsor
        $xpui_js = OffAdsOnFullscreen
    }
    # Experimental Feature
    if ($exp_off) { Write-Host "Experimental features disabled"`n }
    if (!($exp_off)) { $xpui_js = ExpFeature }

    # Disabled logging
    $xpui_js = $xpui_js -replace "sp://logging/v3/\w+", ""
   
    $writer = New-Object System.IO.StreamWriter($entry_xpui.Open())
    $writer.BaseStream.SetLength(0)
    $writer.Write($xpui_js)
    $writer.Write([System.Environment]::NewLine + '// Patched by SpotX') 
    $writer.Close()

    # vendor~xpui.js
    $entry_vendor_xpui = $zip.GetEntry('vendor~xpui.js')
    $reader = New-Object System.IO.StreamReader($entry_vendor_xpui.Open())
    $xpuiContents_vendor = $reader.ReadToEnd()
    $reader.Close()

    $xpuiContents_vendor = $xpuiContents_vendor `
        <# Disable Sentry" #> -replace "prototype\.bindClient=function\(\w+\)\{", '${0}return;'
    $writer = New-Object System.IO.StreamWriter($entry_vendor_xpui.Open())
    $writer.BaseStream.SetLength(0)
    $writer.Write($xpuiContents_vendor)
    $writer.Close()

    # js all
    $zip.Entries | Where-Object FullName -like '*.js' | ForEach-Object {
        $readerjs = New-Object System.IO.StreamReader($_.Open())
        $xpuiContents_js = $readerjs.ReadToEnd()
        $readerjs.Close()

        # js minification
        $xpuiContents_js = $xpuiContents_js `
            -replace "[/][/][#] sourceMappingURL=.*[.]map", "" -replace "\r?\n(?!\(1|\d)", ""

        $writer = New-Object System.IO.StreamWriter($_.Open())
        $writer.BaseStream.SetLength(0)
        $writer.Write($xpuiContents_js)
        $writer.Close()
    }

    # xpui.css
    $entry_xpui_css = $zip.GetEntry('xpui.css')
    $reader = New-Object System.IO.StreamReader($entry_xpui_css.Open())
    $xpuiContents_xpui_css = $reader.ReadToEnd()
    $reader.Close()
        
    $writer = New-Object System.IO.StreamWriter($entry_xpui_css.Open())
    $writer.BaseStream.SetLength(0)
    $writer.Write($xpuiContents_xpui_css)
    if (!($premium)) {
        # Hide download icon on different pages
        $writer.Write([System.Environment]::NewLine + ' .BKsbV2Xl786X9a09XROH{display:none}')
        # Hide submenu item "download"
        $writer.Write([System.Environment]::NewLine + ' button.wC9sIed7pfp47wZbmU6m.pzkhLqffqF_4hucrVVQA{display:none}')
    }
    # Hide Collaborators icon
    if (!($hide_col_icon_off) -and !($exp_off)) {
        $writer.Write([System.Environment]::NewLine + ' .X1lXSiVj0pzhQCUo_72A{display:none}')
    }
    # Hide broken podcast menu
    if ($podcast_off) { 
        $writer.Write([System.Environment]::NewLine + ' li.OEFWODerafYHGp09iLlA [href="/collection/podcasts"]{display:none}')
    }
    $writer.Close()

    # *.Css
    $zip.Entries | Where-Object FullName -like '*.css' | ForEach-Object {
        $readercss = New-Object System.IO.StreamReader($_.Open())
        $xpuiContents_css = $readercss.ReadToEnd()
        $readercss.Close()

        $xpuiContents_css = $xpuiContents_css `
            <# Remove RTL #>`
            -replace "}\[dir=ltr\]\s?([.a-zA-Z\d[_]+?,\[dir=ltr\])", '}[dir=str] $1' -replace "}\[dir=ltr\]\s?", "} " -replace "html\[dir=ltr\]", "html" `
            -replace ",\s?\[dir=rtl\].+?(\{.+?\})", '$1' -replace "[\w\-\.]+\[dir=rtl\].+?\{.+?\}", "" -replace "\}\[lang=ar\].+?\{.+?\}", "}" `
            -replace "\}\[dir=rtl\].+?\{.+?\}", "}" -replace "\}html\[dir=rtl\].+?\{.+?\}", "}" -replace "\}html\[lang=ar\].+?\{.+?\}", "}" `
            -replace "\[lang=ar\].+?\{.+?\}", "" -replace "html\[dir=rtl\].+?\{.+?\}", "" -replace "html\[lang=ar\].+?\{.+?\}", "" `
            -replace "\[dir=rtl\].+?\{.+?\}", "" -replace "\[dir=str\]", "[dir=ltr]" `
            <# Css minification #>`
            -replace "[/]\*([^*]|[\r\n]|(\*([^/]|[\r\n])))*\*[/]", "" -replace "[/][/]#\s.*", "" -replace "\r?\n(?!\(1|\d)", ""
    
        $writer = New-Object System.IO.StreamWriter($_.Open())
        $writer.BaseStream.SetLength(0)
        $writer.Write($xpuiContents_css)
        $writer.Close()
    }
    
    # licenses.html minification
    $zip.Entries | Where-Object FullName -like '*licenses.html' | ForEach-Object {
        $reader = New-Object System.IO.StreamReader($_.Open())
        $xpuiContents_html = $reader.ReadToEnd()
        $reader.Close()      
        $xpuiContents_html = ContentsHtml
        $writer = New-Object System.IO.StreamWriter($_.Open())
        $writer.BaseStream.SetLength(0)
        $writer.Write($xpuiContents_html)
        $writer.Close()
    }

    # blank.html minification
    $entry_blank_html = $zip.GetEntry('blank.html')
    $reader = New-Object System.IO.StreamReader($entry_blank_html.Open())
    $xpuiContents_html_blank = $reader.ReadToEnd()
    $reader.Close()

    $html_min1 = "  "
    $html_min2 = "(?m)(^\s*\r?\n)"
    $html_min3 = "\r?\n(?!\(1|\d)"
    if ($xpuiContents_html_blank -match $html_min1) { $xpuiContents_html_blank = $xpuiContents_html_blank -replace $html_min1, "" } else { Write-Host "Didn't find variable " -ForegroundColor red -NoNewline; Write-Host "`$html_min1 in html" }
    if ($xpuiContents_html_blank -match $html_min2) { $xpuiContents_html_blank = $xpuiContents_html_blank -replace $html_min2, "" } else { Write-Host "Didn't find variable " -ForegroundColor red -NoNewline; Write-Host "`$html_min2 in html" }
    if ($xpuiContents_html_blank -match $html_min3) { $xpuiContents_html_blank = $xpuiContents_html_blank -replace $html_min3, "" } else { Write-Host "Didn't find variable " -ForegroundColor red -NoNewline; Write-Host "`$html_min3 in html" }

    $xpuiContents_html_blank = $xpuiContents_html_blank
    $writer = New-Object System.IO.StreamWriter($entry_blank_html.Open())
    $writer.BaseStream.SetLength(0)
    $writer.Write($xpuiContents_html_blank)
    $writer.Close()
    
    # Json
    $zip.Entries | Where-Object FullName -like '*.json' | ForEach-Object {
        $readerjson = New-Object System.IO.StreamReader($_.Open())
        $xpuiContents_json = $readerjson.ReadToEnd()
        $readerjson.Close()

        # json minification
        $xpuiContents_json = $xpuiContents_json `
            -replace "  ", "" -replace "    ", "" -replace '": ', '":' -replace "\r?\n(?!\(1|\d)", "" 

        $writer = New-Object System.IO.StreamWriter($_.Open())
        $writer.BaseStream.SetLength(0)
        $writer.Write($xpuiContents_json)
        $writer.Close()
    }
    $zip.Dispose()   
}

# Shortcut Spotify.lnk
$ErrorActionPreference = 'SilentlyContinue' 

$desktop_folder = DesktopFolder

If (!(Test-Path $desktop_folder\Spotify.lnk)) {
    $source = "$env:APPDATA\Spotify\Spotify.exe"
    $target = "$desktop_folder\Spotify.lnk"
    $WorkingDir = "$env:APPDATA\Spotify"
    $WshShell = New-Object -comObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut($target)
    $Shortcut.WorkingDirectory = $WorkingDir
    $Shortcut.TargetPath = $source
    $Shortcut.Save()      
}

# Block updates
$ErrorActionPreference = 'SilentlyContinue'
$update_test_exe = Test-Path -Path $spotifyExecutable

if ($block_update) {

    if ($update_test_exe) {
        $exe = "$env:APPDATA\Spotify\Spotify.exe"
        $exe_bak = "$env:APPDATA\Spotify\Spotify.bak"
        $ANSI = [Text.Encoding]::GetEncoding(1251)
        $old = [IO.File]::ReadAllText($exe, $ANSI)

        if ($old -match "(?<=wg:\/\/desktop-update\/.)7(\/update)") {
            Write-Host "Spotify updates are already blocked"`n
        }
        elseif ($old -match "(?<=wg:\/\/desktop-update\/.)2(\/update)") {
            copy-Item $exe $exe_bak
            $new = $old -replace "(?<=wg:\/\/desktop-update\/.)2(\/update)", '7/update'
            [IO.File]::WriteAllText($exe, $new, $ANSI)
        }
        else {
            Write-Host "Failed to block updates"`n -ForegroundColor Red
        }
    }
    else {
        Write-Host "Could not find Spotify.exe"`n -ForegroundColor Red 
    }
}

# Automatic cache clearing
if ($cache_install) {
    Start-Sleep -Milliseconds 200
    New-Item -Path $env:APPDATA\Spotify\ -Name "cache" -ItemType "directory" | Out-Null

    # Download cache script
    downloadScripts -param1 "cache-spotify"
    downloadScripts -param1 "hide_window"
    downloadScripts -param1 "run_ps"

    # Spotify.lnk
    $source2 = "$cache_folder\hide_window.vbs"
    $target2 = "$desktop_folder\Spotify.lnk"
    $WorkingDir2 = "$cache_folder"
    $WshShell2 = New-Object -comObject WScript.Shell
    $Shortcut2 = $WshShell2.CreateShortcut($target2)
    $Shortcut2.WorkingDirectory = $WorkingDir2
    $Shortcut2.IconLocation = "$env:APPDATA\Spotify\Spotify.exe"
    $Shortcut2.TargetPath = $source2
    $Shortcut2.Save()

    if ($number_days -match "^[1-9][0-9]?$|^100$") {
        $file_cache_spotify_ps1 = Get-Content $cache_folder\cache_spotify.ps1 -Raw
        $new_file_cache_spotify_ps1 = $file_cache_spotify_ps1 -replace '7', $number_days
        Set-Content -Path $cache_folder\cache_spotify.ps1 -Force -Value $new_file_cache_spotify_ps1
        $contentcache_spotify_ps1 = [System.IO.File]::ReadAllText("$cache_folder\cache_spotify.ps1")
        $contentcache_spotify_ps1 = $contentcache_spotify_ps1.Trim()
        [System.IO.File]::WriteAllText("$cache_folder\cache_spotify.ps1", $contentcache_spotify_ps1)

        $infile = "$cache_folder\cache_spotify.ps1"
        $outfile = "$cache_folder\cache_spotify2.ps1"

        $sr = New-Object System.IO.StreamReader($infile) 
        $sw = New-Object System.IO.StreamWriter($outfile, $false, [System.Text.Encoding]::Default)
        $sw.Write($sr.ReadToEnd())
        $sw.Close()
        $sr.Close() 
        $sw.Dispose()
        $sr.Dispose()

        Start-Sleep -Milliseconds 200
        Remove-item $infile -Recurse -Force
        Rename-Item -path $outfile -NewName $infile
    }
}

if ($start_spoti) { Start-Process -WorkingDirectory $spotifyDirectory -FilePath $spotifyExecutable }

Write-Host "installation completed"`n -ForegroundColor Green
exit