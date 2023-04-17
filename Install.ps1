param
(
    [Parameter(HelpMessage = 'Hiding podcasts/episodes/audiobooks from homepage.')]
    [switch]$podcasts_off,

    [Parameter(HelpMessage = 'Hiding Ad-like sections from the homepage')]
    [switch]$adsections_off,
    
    [Parameter(HelpMessage = 'Do not hiding podcasts/episodes/audiobooks from homepage.')]
    [switch]$podcasts_on,
    
    [Parameter(HelpMessage = 'Block Spotify automatic updates.')]
    [switch]$block_update_on,
    
    [Parameter(HelpMessage = 'Do not block Spotify automatic updates.')]
    [switch]$block_update_off,
    
    [Parameter(HelpMessage = 'Enable clear cache.')]
    [switch]$cache_on,
    
    [Parameter(HelpMessage = 'Specify the number of days. Default is 7 days.')]
    [int16]$number_days = 7,
    
    [Parameter(HelpMessage = 'Do not enable cache clearing.')]
    [switch]$cache_off,
    
    [Parameter(HelpMessage = 'Automatic uninstallation of Spotify MS if it was found.')]
    [switch]$confirm_uninstall_ms_spoti,
    
    [Parameter(HelpMessage = 'Overwrite outdated or unsupported version of Spotify with the recommended version.')]
    [switch]$confirm_spoti_recomended_over,
    
    [Parameter(HelpMessage = 'Uninstall outdated or unsupported version of Spotify and install the recommended version.')]
    [switch]$confirm_spoti_recomended_unistall,
    
    [Parameter(HelpMessage = 'Installation without ad blocking for premium accounts.')]
    [switch]$premium,
    
    [Parameter(HelpMessage = 'Automatic launch of Spotify after installation is complete.')]
    [switch]$start_spoti,
    
    [Parameter(HelpMessage = 'Experimental features operated by Spotify.')]
    [switch]$exp_spotify,
    
    [Parameter(HelpMessage = 'Do not hide the icon of collaborations in playlists.')]
    [switch]$hide_col_icon_off,
    
    [Parameter(HelpMessage = 'Do not enable the Made For You button on the left sidebar.')]
    [switch]$made_for_you_off,
    
    [Parameter(HelpMessage = 'Do not enable enhance playlist.')]
    [switch]$enhance_playlist_off,
    
    [Parameter(HelpMessage = 'Do not enable enhance liked songs.')]
    [switch]$enhance_like_off,
    
    [Parameter(HelpMessage = 'Do not enable new discography on artist.')]
    [switch]$new_artist_pages_off,
    
    [Parameter(HelpMessage = 'Do not enable new lyrics.')]
    [switch]$new_lyrics_off,
    
    [Parameter(HelpMessage = 'Do not enable exception playlists from recommendations.')]
    [switch]$ignore_in_recommendations_off,

    [Parameter(HelpMessage = 'Enable audio equalizer for Desktop.')]
    [switch]$equalizer_off,
    
    [Parameter(HelpMessage = 'Return the old device picker')]
    [switch]$device_picker_old,

    [Parameter(HelpMessage = 'New theme activated (new right and left sidebar, some cover change)')]
    [switch]$new_theme,
    
    [Parameter(HelpMessage = 'Returns old lyrics')]
    [switch]$old_lyrics,
    
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
    
    [Parameter(HelpMessage = 'Select the desired language to use for installation. Default is the detected system language.')]
    [Alias('l')]
    [string]$Language
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
        'en', 'ru', 'it', 'tr', 'ka', 'pl', 'es', 'fr', 'hi', 'pt', 'id', 'vi', 'ro', 'de', 'hu', 'zh', 'zh-TW', 'ko', 'ua', 'fa', 'sr', 'lv', 'bn', 'el', 'fi', 'ja', 'fil'
    )
    
    
    # Trim the language code down to two letter code.
    switch -Regex ($LanguageCode) {
        '^en' {
            $returnCode = 'en'
            break
        }
        '^(ru|py)' {
            $returnCode = 'ru'
            break
        }
        '^it' {
            $returnCode = 'it'
            break
        }
        '^tr' {
            $returnCode = 'tr'
            break
        }
        '^ka' {
            $returnCode = 'ka'
            break
        }
        '^pl' {
            $returnCode = 'pl'
            break
        }
        '^es' {
            $returnCode = 'es'
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
        '^pt' {
            $returnCode = 'pt'
            break
        }
        '^id' {
            $returnCode = 'id'
            break
        }
        '^vi' {
            $returnCode = 'vi'
            break
        }
        '^ro' {
            $returnCode = 'ro'
            break
        }
        '^de' {
            $returnCode = 'de'
            break
        }
        '^hu' {
            $returnCode = 'hu'
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
        '^ko' {
            $returnCode = 'ko'
            break
        }
        '^ua' {
            $returnCode = 'ua'
            break
        }
        '^fa' {
            $returnCode = 'fa'
            break
        }
        '^sr' {
            $returnCode = 'sr'
            break
        }
        '^lv' {
            $returnCode = 'lv'
            break
        }
        '^bn' {
            $returnCode = 'bn'
            break
        }
        '^el' {
            $returnCode = 'el'
            break
        }
        '^fi' {
            $returnCode = 'fi'
            break
        }
        '^ja' {
            $returnCode = 'ja'
            break
        
        }
        '^fil' {
            $returnCode = 'fil'
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
        $returnCode = $PSUICulture.Remove(2)
    }
    # Checking the short language code
    if ($returnCode -NotIn $supportLanguages) {
        # If the language code is not supported default to English.
        $returnCode = 'en'
    }
    return $returnCode 
}

$spotifyDirectory = "$env:APPDATA\Spotify"
$spotifyDirectory2 = "$env:LOCALAPPDATA\Spotify"
$spotifyExecutable = "$spotifyDirectory\Spotify.exe"
$exe_bak = "$spotifyDirectory\Spotify.bak"
$cache_folder = "$env:APPDATA\Spotify\cache"
$spotifyUninstall = "$env:TEMP\SpotifyUninstall.exe"
$start_menu = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Spotify.lnk"
$upgrade_client = $false

# Check version Windows
$os = Get-CimInstance -ClassName Win32_OperatingSystem
$osCaption = $os.Caption
$pattern = "\bWindows (7|8(\.1)?|10|11|12)\b"
$reg = [regex]::Matches($osCaption, $pattern)
$win_os = $reg.value

$win12 = $win_os -match "\windows 12\b"
$win11 = $win_os -match "\windows 11\b"
$win10 = $win_os -match "\windows 10\b"
$win8_1 = $win_os -match "\windows 8.1\b"
$win8 = $win_os -match "\windows 8\b"

# Recommended version for Win 10-12
if ($win10 -or $win11 -or $win12) { 
    $onlineFull = "1.2.9.743.g85d9593d-295" 
}
# Recommended version for Win 7-8.1
else { 
    $onlineFull = "1.2.5.1006.g22820f93-1078" 
}

$online = ($onlineFull -split ".g")[0]

# Check version Powershell
$psv = $PSVersionTable.PSVersion.major
if ($psv -ge 7) {
    Import-Module Appx -UseWindowsPowerShell -WarningAction:SilentlyContinue
}

# Country check
$country = [System.Globalization.RegionInfo]::CurrentRegion.EnglishName

# add Tls12
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12


function CallLang($clg) {

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $urlLang = "https://raw.githubusercontent.com/amd64fox/SpotX/main/scripts/installer-lang/$clg.ps1"
    $ProgressPreference = 'SilentlyContinue'
    
    try {
(Invoke-WebRequest -useb $urlLang).Content | Invoke-Expression 
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

# Set variable 'ru'.
if ($langCode -eq 'ru') { 
    $ru = $true
    $urlru = "https://raw.githubusercontent.com/amd64fox/SpotX/main/patches/Augmented%20translation/ru.json"
    $webjsonru = (Invoke-WebRequest -useb -Uri $urlru).Content | ConvertFrom-Json
}

Write-Host ($lang).Welcome
Write-Host ""

# Sending a statistical web query to cutt.ly
$ErrorActionPreference = 'SilentlyContinue'
$cutt_url = "https://cutt.ly/DK8UQub"
try {
    $ProgressPreference = 'SilentlyContinue'
    Invoke-WebRequest -useb -Uri $cutt_url | Out-Null
}
catch {
    Start-Sleep -Milliseconds 2300
    try { 
        Invoke-WebRequest -useb -Uri $cutt_url | Out-Null
    }
    catch { }
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
    $blockFileUpdate = "$env:LOCALAPPDATA\Spotify\Update"
    
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

function downloadScripts($param1) {

    $webClient = New-Object -TypeName System.Net.WebClient

    if ($param1 -eq "Desktop") {
        Import-Module BitsTransfer
        
        $links = "https://download.scdn.co/upgrade/client/win32-x86/spotify_installer-$onlineFull.exe"
    }
    if ($ru -and $param1 -eq "cache-spotify") {
        $links2 = "https://raw.githubusercontent.com/amd64fox/SpotX/main/scripts/cache/cache_spotify_ru.ps1"
    }
    if (!($ru) -and $param1 -eq "cache-spotify" ) { 
        $links2 = "https://raw.githubusercontent.com/amd64fox/SpotX/main/scripts/cache/cache_spotify.ps1"
    }
    
    $web_Url_prev = $links, $links2, "https://raw.githubusercontent.com/amd64fox/SpotX/main/scripts/cache/hide_window.vbs", `
        "https://raw.githubusercontent.com/amd64fox/SpotX/main/scripts/cache/run_ps.bat"

    $local_Url_prev = "$PWD\SpotifySetup.exe", "$cache_folder\cache_spotify.ps1", "$cache_folder\hide_window.vbs", "$cache_folder\run_ps.bat"
    $web_name_file_prev = "SpotifySetup.exe", "cache_spotify.ps1", "hide_window.vbs", "run_ps.bat"

    switch ( $param1 ) {
        "Desktop" { $web_Url = $web_Url_prev[0]; $local_Url = $local_Url_prev[0]; $web_name_file = $web_name_file_prev[0] }
        "cache-spotify" { $web_Url = $web_Url_prev[1]; $local_Url = $local_Url_prev[1]; $web_name_file = $web_name_file_prev[1] }
        "hide_window" { $web_Url = $web_Url_prev[2]; $local_Url = $local_Url_prev[2]; $web_name_file = $web_name_file_prev[2] }
        "run_ps" { $web_Url = $web_Url_prev[3]; $local_Url = $local_Url_prev[3]; $web_name_file = $web_name_file_prev[3] } 
    }

    if ($param1 -eq "Desktop") {
        try { if (curl.exe -V) { $curl_check = $true } }
        catch { $curl_check = $false }
    }
    try { 
        if ($param1 -eq "Desktop" -and $curl_check) {
            $stcode = curl.exe -s -w "%{http_code}" -o /dev/null $web_Url --retry 2 --ssl-no-revoke
            if ($stcode -ne "200") { throw ($lang).Download6 }
            curl.exe $web_Url -o $local_Url --progress-bar --retry 3 --ssl-no-revoke
            return
        }
        if ($param1 -eq "Desktop" -and !($curl_check ) -and $null -ne (Get-Module -Name BitsTransfer -ListAvailable)) {
            $ProgressPreference = 'Continue'
            Start-BitsTransfer -Source  $web_Url -Destination $local_Url  -DisplayName ($lang).Download5 -Description "$online "
            return
        }
        if ($param1 -eq "Desktop" -and !($curl_check ) -and $null -eq (Get-Module -Name BitsTransfer -ListAvailable)) {
            $webClient.DownloadFile($web_Url, $local_Url) 
            return
        }
        if ($param1 -ne "Desktop") {
            $ProgressPreference = 'SilentlyContinue' # Hiding Progress Bars
            $webClient.DownloadFile($web_Url, $local_Url) 
        }
    }

    catch {
        Write-Host ""
        Write-Host ($lang).Download $web_name_file -ForegroundColor RED
        $Error[0].Exception
        Write-Host ""
        Write-Host ($lang).Download2`n
        Start-Sleep -Milliseconds 5000 
        try { 

            if ($param1 -eq "Desktop" -and $curl_check) {
                $stcode = curl.exe -s -w "%{http_code}" -o /dev/null $web_Url --retry 2 --ssl-no-revoke
                if ($stcode -ne "200") { throw ($lang).Download6 }
                curl.exe $web_Url -o $local_Url --progress-bar --retry 3 --ssl-no-revoke
                return
            }
            if ($param1 -eq "Desktop" -and $null -ne (Get-Module -Name BitsTransfer -ListAvailable) -and !($curl_check )) {
                Start-BitsTransfer -Source  $web_Url -Destination $local_Url  -DisplayName ($lang).Download5 -Description "$vernew "
                return
            }
            if ($param1 -eq "Desktop" -and $null -eq (Get-Module -Name BitsTransfer -ListAvailable) -and !($curl_check )) {
                $webClient.DownloadFile($web_Url, $local_Url) 
                return
            }
            if ($param1 -ne "Desktop") {
                $webClient.DownloadFile($web_Url, $local_Url) 
            }

        }
        
        catch {
            Write-Host ($lang).Download3 -ForegroundColor RED
            $Error[0].Exception
            Write-Host ""
            Write-Host ($lang).Download4`n
            ($lang).StopScript
            $tempDirectory = $PWD
            Pop-Location
            Start-Sleep -Milliseconds 200
            Remove-Item -Recurse -LiteralPath $tempDirectory
            Pause
            Exit
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

taskkill /f /im Spotify.exe /t > $null 2>&1

# Remove Spotify Windows Store If Any
if ($win10 -or $win11 -or $win8_1 -or $win8 -or $win12) {

    if (Get-AppxPackage -Name SpotifyAB.SpotifyMusic) {
        Write-Host ($lang).MsSpoti`n
        
        if (!($confirm_uninstall_ms_spoti)) {
            do {
                $ch = Read-Host -Prompt ($lang).MsSpoti2
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
            if ($confirm_uninstall_ms_spoti) { Write-Host ($lang).MsSpoti3`n }
            if (!($confirm_uninstall_ms_spoti)) { Write-Host ($lang).MsSpoti4`n }
            Get-AppxPackage -Name SpotifyAB.SpotifyMusic | Remove-AppxPackage
        }
        if ($ch -eq 'n') {
            Read-Host ($lang).StopScript 
            Pause
            Exit
        }
    }
}

# Attempt to fix the hosts file
$pathHosts = "$Env:windir\System32\Drivers\Etc\hosts"
$pathHosts_bak = "$Env:windir\System32\Drivers\Etc\hosts.bak"
$ErrorActionPreference = 'SilentlyContinue'
$testHosts = Test-Path -Path $pathHosts

if ($testHosts) {
    $hosts = Get-Content -Path $pathHosts

    if ($hosts -match '^[^\#|].+scdn.+|^[^\#|].+spotify.+') {
        Write-Host ($lang).HostInfo
        Write-Host ($lang).HostBak
        copy-Item $pathHosts $pathHosts_bak
        Write-Host ($lang).HostDel`n       

        try {
            $hosts = $hosts -replace '^[^\#|].+scdn.+|^[^\#|].+spotify.+', ''
            Set-Content -Path $pathHosts -Value $hosts -Force
            $hosts | Where-Object { $_.trim() -ne "" } | Set-Content -Path $pathHosts -Force
        }
        catch {
            Write-Host ($lang).HostError`n -ForegroundColor Red
        }
    }
}

# Unique directory name based on time
Push-Location -LiteralPath $env:TEMP
New-Item -Type Directory -Name "SpotX_Temp-$(Get-Date -UFormat '%Y-%m-%d_%H-%M-%S')" | Convert-Path | Set-Location

if ($premium) {
    Write-Host ($lang).Prem`n
}

$spotifyInstalled = (Test-Path -LiteralPath $spotifyExecutable)

if ($spotifyInstalled) {
    
    # Check version Spotify offline
    $offline = (Get-Item $spotifyExecutable).VersionInfo.FileVersion
 
    # Version comparison
    # converting strings to arrays of numbers using the -split operator and a ForEach-Object loop
    $arr1 = $online -split '\.' | ForEach-Object { [int]$_ }
    $arr2 = $offline -split '\.' | ForEach-Object { [int]$_ }

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

    # Old version Spotify
    if ($oldversion) {
        if ($confirm_spoti_recomended_over -or $confirm_spoti_recomended_unistall) {
            Write-Host ($lang).OldV`n
        }
        if (!($confirm_spoti_recomended_over) -and !($confirm_spoti_recomended_unistall)) {
            do {
                Write-Host (($lang).OldV2 -f $offline, $online)
                $ch = Read-Host -Prompt ($lang).OldV3
                Write-Host ""
                if (!($ch -eq 'n' -or $ch -eq 'y')) {
                    incorrectValue
                }
            }
            while ($ch -notmatch '^y$|^n$')
        }
        if ($confirm_spoti_recomended_over -or $confirm_spoti_recomended_unistall) { 
            $ch = 'y' 
            Write-Host ($lang).AutoUpd`n
        }
        if ($ch -eq 'y') { 
            $upgrade_client = $true 

            if (!($confirm_spoti_recomended_over) -and !($confirm_spoti_recomended_unistall)) {
                do {
                    $ch = Read-Host -Prompt (($lang).DelOrOver -f $offline)
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
                Write-Host ($lang).DelOld`n 
                Unlock-Folder | Out-Null
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
    
    # Unsupported version Spotify
    if ($testversion) {
        # Submit unsupported version of Spotify to google form for further processing
        try { 
            $txt = [IO.File]::ReadAllText($spotifyExecutable)
            $regex = "(\d+)\.(\d+)\.(\d+)\.(\d+)(\.g[0-9a-f]{8})"
            $v = $txt | Select-String $regex -AllMatches
            $version = $v.Matches.Value[0]
            if ($version.Count -gt 1) { $version = $version[0] }

            $Parameters = @{
                Uri    = 'https://docs.google.com/forms/d/e/1FAIpQLSegGsAgilgQ8Y36uw-N7zFF6Lh40cXNfyl1ecHPpZcpD8kdHg/formResponse'
                Method = 'POST'
                Body   = @{
                    'entry.620327948'  = $version
                    'entry.1951747592' = $country
                    'entry.1402903593' = $win_os
                    'entry.860691305'  = $psv
                    'entry.2067427976' = $online + " < " + $offline
                }   
            }
            Invoke-WebRequest -useb @Parameters | Out-Null
        }
        catch {
            Write-Host 'Unable to submit new version of Spotify' 
            Write-Host "error description: "$Error[0]
        }

        if ($confirm_spoti_recomended_over -or $confirm_spoti_recomended_unistall) {
            Write-Host ($lang).NewV`n
        }
        if (!($confirm_spoti_recomended_over) -and !($confirm_spoti_recomended_unistall)) {
            do {
                Write-Host (($lang).NewV2 -f $offline, $online)
                $ch = Read-Host -Prompt (($lang).NewV3 -f $offline)
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
            if (!($confirm_spoti_recomended_over) -and !($confirm_spoti_recomended_unistall)) {
                do {
                    $ch = Read-Host -Prompt (($lang).Recom -f $online)
                    Write-Host ""
                    if (!($ch -eq 'n' -or $ch -eq 'y')) {
                        incorrectValue
                    }
                }
                while ($ch -notmatch '^y$|^n$')
            }
            if ($confirm_spoti_recomended_over -or $confirm_spoti_recomended_unistall) { 
                $ch = 'y' 
                Write-Host ($lang).AutoUpd`n
            }
            if ($ch -eq 'y') {
                $upgrade_client = $true
                $downgrading = $true
                if (!($confirm_spoti_recomended_over) -and !($confirm_spoti_recomended_unistall)) {
                    do {
                        $ch = Read-Host -Prompt (($lang).DelOrOver -f $offline)
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
                    Write-Host ($lang).DelNew`n
                    Unlock-Folder | Out-Null
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
                Write-Host ($lang).StopScript
                $tempDirectory = $PWD
                Pop-Location
                Start-Sleep -Milliseconds 200
                Remove-Item -Recurse -LiteralPath $tempDirectory 
                Pause
                Exit
            }
        }
    }
}
# If there is no client or it is outdated, then install
if (-not $spotifyInstalled -or $upgrade_client) {

    Write-Host ($lang).DownSpoti"" -NoNewline
    Write-Host  $online -ForegroundColor Green
    Write-Host ($lang).DownSpoti2`n
    
    # Delete old version files of Spotify before installing, leave only profile files
    $ErrorActionPreference = 'SilentlyContinue'
    taskkill /f /im Spotify.exe /t > $null 2>&1
    Start-Sleep -Milliseconds 600
    Unlock-Folder | Out-Null
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
    taskkill /f /im Spotify.exe /t > $null 2>&1


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
        Write-Host ""
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
        Write-Host ""
        if (!($ch -eq 'n' -or $ch -eq 'y')) { incorrectValue } 
    }
    while ($ch -notmatch '^y$|^n$')
}
if ($ch -eq 'y') { $block_update = $true }

if ($ch -eq 'n') {
    $ErrorActionPreference = 'SilentlyContinue'
    if ((Test-Path -LiteralPath $exe_bak) -and $offline -eq $offline_bak) {
        Remove-Item $spotifyExecutable -Recurse -Force
        Rename-Item $exe_bak $spotifyExecutable
    }
}

$ch = $null

if ($cache_on) { 
    Write-Host (($lang).CacheOn -f $number_days)`n 
    $cache_install = $true
}
if ($cache_off) { 
    Write-Host ($lang).CacheOff`n
    $ErrorActionPreference = 'SilentlyContinue'
    $desktop_folder = DesktopFolder
    if (Test-Path -LiteralPath $cache_folder) {
        remove-item $cache_folder -Recurse -Force
        remove-item $desktop_folder\Spotify.lnk -Recurse -Force
        remove-item $start_menu -Recurse -Force
    } 
}
if (!($cache_on) -and !($cache_off)) {

    do {
        $ch = Read-Host -Prompt ($lang).CacheSelect
        Write-Host ""
        if (!($ch -eq 'n' -or $ch -eq 'y')) { incorrectValue }
    }
    while ($ch -notmatch '^y$|^n$')

    if ($ch -eq 'y') {
        $cache_install = $true 

        do {
            Write-Host ($lang).CacheDays
            $ch = Read-Host -Prompt ($lang).CacheDays2
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
            remove-item $start_menu -Recurse -Force
        }
    }
}

if ($exp_spotify) { Write-Host ($lang).ExpSpotify`n }

$url = "https://raw.githubusercontent.com/amd64fox/SpotX/main/patches/patches.json"
$retries = 0

while ($retries -lt 3) {
    try {
        $webjson = Invoke-WebRequest -UseBasicParsing -Uri $url | ConvertFrom-Json
        break
    }
    catch {
        Write-Warning "Request failed: $_"
        $retries++
        Start-Sleep -Seconds 3
    }
}

if ($retries -eq 3) {

    Write-Host "Failed to get patches.json" -ForegroundColor Red
    Write-Host ($lang).StopScript
    $tempDirectory = $PWD
    Pop-Location
    Start-Sleep -Milliseconds 200
    Remove-Item -Recurse -LiteralPath $tempDirectory 
    Pause
    Exit
}
function Helper($paramname) {

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
        "RemovertlCssmin" { 
            # Remove RTL and minification of all *.css
            $contents = "removertl-cssmin"
            $json = $webjson.others
        }
        "DisableSentry" { 
            # Disable Sentry (vendor~xpui.js)
            $name = "patches.json.others."
            $n = "vendor~xpui.js"
            $contents = "disablesentry"
            $json = $webjson.others
        }
        "DisabledLog" { 
            # Disabled logging
            $name = "patches.json.others."
            $n = "xpui.js"
            $contents = "disablelog"
            $json = $webjson.others
        }
        "Lyrics-color" { 
            $pasttext = $webjson.others.themelyrics.theme.$lyrics_stat.pasttext
            $current = $webjson.others.themelyrics.theme.$lyrics_stat.current
            $next = $webjson.others.themelyrics.theme.$lyrics_stat.next
            $background = $webjson.others.themelyrics.theme.$lyrics_stat.background
            $hover = $webjson.others.themelyrics.theme.$lyrics_stat.hover
            $maxmatch = $webjson.others.themelyrics.theme.$lyrics_stat.maxmatch

            if ($offline -lt "1.1.99.871") { $lyrics = "lyricscolor1"; $contents = $lyrics }
            if ($offline -ge "1.1.99.871") { $lyrics = "lyricscolor2"; $contents = $lyrics }

            # xpui-routes-lyrics.js
            if ($offline -ge "1.1.99.871") {
                $webjson.others.$lyrics.replace[1] = '$1' + '"' + $pasttext + '"'  
                $webjson.others.$lyrics.replace[2] = '$1' + '"' + $current + '"'  
                $webjson.others.$lyrics.replace[3] = '$1' + '"' + $next + '"'  
                $webjson.others.$lyrics.replace[4] = '$1' + '"' + $background + '"'
                $webjson.others.$lyrics.replace[5] = '$1' + '"' + $hover + '"'   
                $webjson.others.$lyrics.replace[6] = '$1' + '"' + $maxmatch + '"'
            }

            # xpui-routes-lyrics.css
            if ($offline -lt "1.1.99.871") {
                $webjson.others.$lyrics.replace[0] = '$1' + $pasttext
                $webjson.others.$lyrics.replace[1] = '$1' + $current
                $webjson.others.$lyrics.replace[2] = '$1' + $next
                $webjson.others.$lyrics.replace[3] = $background 
                $webjson.others.$lyrics.replace[4] = '$1' + $hover 
                $webjson.others.$lyrics.replace[5] = '$1' + $maxmatch 
            }
            $name = "patches.json.others."
            $n = $name_file
            $json = $webjson.others
        }
        "Discriptions" {  
            # Add discriptions (xpui-desktop-modals.js)
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
        "OffPodcasts" {  
            # Turn off podcasts
            if ($offline -le "1.1.92.647") { $contents = "podcastsoff" }
            if ($offline -ge "1.1.93.896") { $contents = "podcastsoff2" }
            $n = $js
            $name = "patches.json.others."
            $json = $webjson.others
        }
        "OffAdSections" {  
            # Hiding Ad-like sections from the homepage
            $n = $js
            $name = "patches.json.others."
            $contents = "adsectionsoff"
            $json = $webjson.others
        }
        "OffRujs" { 
            # Remove all languages except En and Ru from xpui.js
            $name = "patches.json.others."
            $n = "xpui.js"
            $contents = "offrujs"
            $json = $webjson.others
        }
        "RuTranslate" { 
            # Additional translation of some words for the Russian language
            $n = "ru.json"
            $contents = $webjsonru.psobject.properties.name
            $json = $webjsonru
        }
        "PodcastAd" { 
            # Aodcast ad block
            $name = "patches.json.others."
            $n = "Spotify.exe"
            $contents = "podcast_ad_block"
            $json = $webjson.others
        }
        "BlockUpdate" { 
            # Block Spotify client updates
            $name = "patches.json.others."
            $n = "Spotify.exe"
            $contents = "block_update"
            $json = $webjson.others
        }
        "Collaborators" { 
            # Hide Collaborators icon
            $name = "patches.json.others."
            $n = "xpui-routes-playlist.js"
            $contents = "collaboration"
            $json = $webjson.others
        }
        "Goofy-History" { 
            # Accumulation of track listening history with Goofy
            $name = "patches.json.others."
            $n = "xpui.js"
            $contents = "goofyhistory"
            $webjson.others.$contents.replace = "`$1 const urlForm=" + '"' + $urlform_goofy + '"' + ";const idBox=" + '"' + $idbox_goofy + '"' + $webjson.others.$contents.replace
            $json = $webjson.others
        }
        "ExpFeature" { 
            # Experimental Feature
            $rem = $webjson.exp.psobject.properties 
            if ($enhance_like_off) { $rem.remove('enhanceliked') }
            if ($enhance_playlist_off) { $rem.remove('enhanceplaylist') }
            if ($new_artist_pages_off) { $rem.remove('disographyartist') }
            if ($new_lyrics_off) { $rem.remove('lyricsmatch') }
            if ($equalizer_off) { $rem.remove('equalizer') }
            if (!($device_picker_old)) { $rem.remove('devicepickerold') }
            if ($made_for_you_off) { $rem.remove('madeforyou') }
            if (!($new_theme)) {
                $rem.remove('newhome'), $rem.remove('newhome2'), $rem.remove('lyricssidebar') , $rem.remove('showcreditsinsidebar'), $rem.remove('enableWhatsNewFeed');
                $webjson.exp.rightsidebar.replace = "`$1false"
                $webjson.exp.leftsidebar.replace = "`$1false"
            }
            # Old theme
            else { 
                $webjson.exp.rightsidebar.replace = "`$1true"
                $webjson.exp.leftsidebar.replace = "`$1true"
            }
            if ($old_lyrics) { $rem.remove('lyricssidebar') } 
            if (!$premium) { $rem.remove('RemoteDownloads') }

            $name = "patches.json.exp."
            $n = "xpui.js"
            $contents = $webjson.exp.psobject.properties.name
            $json = $webjson.exp
        }
    }
    $paramdata = $xpui
    $novariable = "Didn't find variable "
    $offline_patch = $offline -replace '(\d+\.\d+\.\d+)(.\d+)', '$1'

    $contents | ForEach-Object { 

        if ( $json.$PSItem.version.do ) { $do = $json.$PSItem.version.do -ge $offline_patch } else { $do = $true }
        if ( $json.$PSItem.version.from ) { $from = $json.$PSItem.version.from -le $offline_patch } else { $from = $false }

        $checkVer = $from -and $do; $translate = $paramname -eq "RuTranslate"

        if ($checkVer -or $translate) {

            if ($json.$PSItem.match.Count -gt 1) {

                $count = $json.$PSItem.match.Count - 1
                $numbers = 0

                While ($numbers -le $count) {

                    if ($paramdata -match $json.$PSItem.match[$numbers]) { 
                        $paramdata = $paramdata -replace $json.$PSItem.match[$numbers], $json.$PSItem.replace[$numbers] 
                    }
                    else { 
                        $notlog = "MinJs", "MinJson", "Removertl", "RemovertlCssmin"
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
                $xpui_spa_patch = "$env:APPDATA\Spotify\Apps\xpui.spa"
                $zip = [System.IO.Compression.ZipFile]::Open($xpui_spa_patch, 'update')   
                $file = $zip.GetEntry($name)
                $reader = New-Object System.IO.StreamReader($file.Open())
            }
            if ($method -eq "nonezip") {
                $file = get-item $env:APPDATA\Spotify\Apps\xpui\$name
                $reader = New-Object -TypeName System.IO.StreamReader -ArgumentList $file
            }
            $xpui = $reader.ReadToEnd()
            $reader.Close()
            if ($helper) { $xpui = Helper -paramname $helper } 
            if ($method -eq "zip") { $writer = New-Object System.IO.StreamWriter($file.Open()) }
            if ($method -eq "nonezip") { $writer = New-Object System.IO.StreamWriter -ArgumentList $file }
            $writer.BaseStream.SetLength(0)
            $writer.Write($xpui)
            if ($add) { $add | ForEach-Object { $writer.Write([System.Environment]::NewLine + $PSItem ) } }
            $writer.Close()  
            if ($method -eq "zip") { $zip.Dispose() }
        }
        "more" {  
            Add-Type -Assembly 'System.IO.Compression.FileSystem'
            $xpui_spa_patch = "$env:APPDATA\Spotify\Apps\xpui.spa"
            $zip = [System.IO.Compression.ZipFile]::Open($xpui_spa_patch, 'update') 
            $zip.Entries | Where-Object FullName -like $name | ForEach-Object {
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
            $xpui = [IO.File]::ReadAllText($spotifyExecutable, $ANSI)
            $xpui = Helper -paramname $helper
            [IO.File]::WriteAllText($spotifyExecutable, $xpui, $ANSI)
        }
    }
}

Write-Host ($lang).ModSpoti`n


$tempDirectory = $PWD
Pop-Location

Start-Sleep -Milliseconds 200
Remove-Item -Recurse -LiteralPath $tempDirectory 

$xpui_spa_patch = "$env:APPDATA\Spotify\Apps\xpui.spa"
$xpui_js_patch = "$env:APPDATA\Spotify\Apps\xpui\xpui.js"
$test_spa = Test-Path -Path $xpui_spa_patch
$test_js = Test-Path -Path $xpui_js_patch
$spotify_exe_bak_patch = "$env:APPDATA\Spotify\Spotify.bak"


if ($test_spa -and $test_js) {
    Write-Host ($lang).Error -ForegroundColor Red
    Write-Host ($lang).FileLocBroken
    Write-Host ($lang).StopScript
    pause
    Exit
}

if ($test_js) {
    
    do {
        $ch = Read-Host -Prompt ($lang).Spicetify
        Write-Host ""
        if (!($ch -eq 'n' -or $ch -eq 'y')) { incorrectValue }
    }
    while ($ch -notmatch '^y$|^n$')

    if ($ch -eq 'y') { 
        $Url = "https://telegra.ph/SpotX-FAQ-09-19#Can-I-use-SpotX-and-Spicetify-together?"
        Start-Process $Url
    }

    Write-Host ($lang).StopScript
    Pause
    Exit
}  

if (!($test_js) -and !($test_spa)) { 
    Write-Host "xpui.spa not found, reinstall Spotify"
    Write-Host ($lang).StopScript
    Pause
    Exit
}

If ($test_spa) {

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
            Write-Host ($lang).NoRestore`n
            Pause
            Exit
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

    # Remove all languages except En and Ru from xpui.spa
    if ($ru) {
        [Reflection.Assembly]::LoadWithPartialName('System.IO.Compression') | Out-Null
        $stream = New-Object IO.FileStream($xpui_spa_patch, [IO.FileMode]::Open)
        $mode = [IO.Compression.ZipArchiveMode]::Update
        $zip_xpui = New-Object IO.Compression.ZipArchive($stream, $mode)

    ($zip_xpui.Entries | Where-Object { $_.FullName -match "i18n" -and $_.FullName -inotmatch "(ru|en.json|longest)" }) | ForEach-Object { $_.Delete() }

        $zip_xpui.Dispose()
        $stream.Close()
        $stream.Dispose()
    }

    # Full screen mode activation and removing "Upgrade to premium" menu, upgrade button, disabling a playlist sponsor
    if (!($premium)) {
        extract -counts 'one' -method 'zip' -name 'xpui.js' -helper 'OffadsonFullscreen'
    }
    
    # Experimental Feature
    if (!($exp_spotify)) { extract -counts 'one' -method 'zip' -name 'xpui.js' -helper 'ExpFeature' }

    # Remove all languages except En and Ru from xpui.js
    if ($ru) { extract -counts 'one' -method 'zip' -name 'xpui.js' -helper 'OffRujs' }

    # Disabled logging
    extract -counts 'one' -method 'zip' -name 'xpui.js' -helper 'DisabledLog' -add $webjson.others.byspotx.add

    # Turn off podcasts
    if ($podcast_off) { 
        if ($offline -ge "1.1.93.896" -and $offline -le "1.1.97.962") { $js = 'home-v2.js' }
        if ($offline -le "1.1.92.647" -or $offline -ge "1.1.98.683") { $js = 'xpui.js' }
        extract -counts 'one' -method 'zip' -name $js -helper 'OffPodcasts'
    }

    # Hiding Ad-like sections from the homepage
    if ($adsections_off) { 
        if ($offline -ge "1.1.93.896" -and $offline -le "1.1.97.962") { $js = 'home-v2.js' }
        if ($offline -ge "1.1.98.683") { $js = 'xpui.js' }
        extract -counts 'one' -method 'zip' -name $js -helper 'OffAdSections'
    }

    # Accumulation of track listening history with Goofy
    if ($urlform_goofy -and $idbox_goofy -and $offline -ge "1.1.90.859") { 
        extract -counts 'one' -method 'zip' -name 'xpui.js' -helper 'Goofy-History'
    }

    # Hide Collaborators icon
    if (!($hide_col_icon_off) -and !($exp_spotify)) {
        extract -counts 'one' -method 'zip' -name 'xpui-routes-playlist.js' -helper 'Collaborators'
    }


    # Static color for lyrics
    if ($lyrics_stat) {
        # old
        if ($offline -lt "1.1.99.871") { 
            $name_file = 'xpui-routes-lyrics.css'
            extract -counts 'one' -method 'zip' -name $name_file -helper 'Lyrics-color'
        }
        # new 
        if ($offline -ge "1.1.99.871") {
            $contents = "fixcsslyricscolor2"
            extract -counts 'one' -method 'zip' -name 'xpui.css' -helper 'FixCss'
            if ($offline -le "1.2.2.582") {
                $name_file = 'xpui-routes-lyrics.js'   
                extract -counts 'one' -method 'zip' -name $name_file -helper 'Lyrics-color'
            }
        }
        # mini lyrics
        if ($offline -ge "1.2.0.1155") {
            $name_file = 'xpui.js'   
            extract -counts 'one' -method 'zip' -name $name_file -helper 'Lyrics-color'
        }
    }

    # Add discriptions (xpui-desktop-modals.js)
    extract -counts 'one' -method 'zip' -name 'xpui-desktop-modals.js' -helper 'Discriptions'

    # Disable Sentry (vendor~xpui.js)
    extract -counts 'one' -method 'zip' -name 'vendor~xpui.js' -helper 'DisableSentry'

    # Minification of all *.js
    extract -counts 'more' -name '*.js' -helper 'MinJs'

    # xpui.css
    if ($new_theme -or !($premium)) {
        if (!($premium)) {
            # Hide download icon on different pages
            $css += $webjson.others.downloadicon.add
            # Hide submenu item "download"
            $css += $webjson.others.submenudownload.add
            # Hide very high quality streaming
            $css += $webjson.others.veryhighstream.add
        }

        # New UI fix
        if ($offline -ge "1.1.94.864" -and $new_theme) {
            if ($offline -lt "1.2.3.1107") {
                $css += $webjson.others.navaltfix.add[0]
            }
            if ($offline -ge "1.2.3.1107") {
                $css += $webjson.others.navaltfix.add[1]
            }
            if ($offline -ge "1.2.6.861" -and $offline -le "1.2.6.863") {
                $css += $webjson.others.leftsidebarfix.add
            }
            $css += $webjson.others.navaltfix.add[2]
            $css += $webjson.others.navaltfix.add[3]
        }
        if ($null -ne $css ) { extract -counts 'one' -method 'zip' -name 'xpui.css' -add $css }
    }
    
    # Old UI fix
    $contents = "fix-old-theme"
    extract -counts 'one' -method 'zip' -name 'xpui.css' -helper "FixCss"

    # Fix scroll bug navylx
    if ($offline -ge "1.2.4.893" -or $offline -le "1.2.4.912") {
        $contents = "fix-scroll-bug-navylx"
        extract -counts 'one' -method 'zip' -name 'xpui.css' -helper "FixCss"
    }

    # Remove RTL and minification of all *.css
    extract -counts 'more' -name '*.css' -helper 'RemovertlCssmin'
    
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
        $source = "$env:APPDATA\Spotify\Spotify.exe"
        $target = "$desktop_folder\Spotify.lnk"
        $WorkingDir = "$env:APPDATA\Spotify"
        $WshShell = New-Object -comObject WScript.Shell
        $Shortcut = $WshShell.CreateShortcut($target)
        $Shortcut.WorkingDirectory = $WorkingDir
        $Shortcut.TargetPath = $source
        $Shortcut.Save()      
    }
}

# Create shortcut in start menu
If (!(Test-Path $start_menu)) {
    $source = "$env:APPDATA\Spotify\Spotify.exe"
    $target = $start_menu
    $WorkingDir = "$env:APPDATA\Spotify"
    $WshShell = New-Object -comObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut($target)
    $Shortcut.WorkingDirectory = $WorkingDir
    $Shortcut.TargetPath = $source
    $Shortcut.Save()      
}

$ANSI = [Text.Encoding]::GetEncoding(1251)
$old = [IO.File]::ReadAllText($spotifyExecutable, $ANSI)

$rexex1 = $old -notmatch $webjson.others.block_update.add
$rexex2 = $old -notmatch $webjson.others.podcast_ad_block.add

if ($rexex1 -and $rexex2 ) {

    if (Test-Path -LiteralPath $exe_bak) { 
        Remove-Item $exe_bak -Recurse -Force
        Start-Sleep -Milliseconds 150
    }
    copy-Item $spotifyExecutable $exe_bak
}

# Podcast ad block
extract -counts 'exe' -helper 'PodcastAd'

# Block updates
if ($block_update) { extract -counts 'exe' -helper 'BlockUpdate' }

# Automatic cache clearing
if ($cache_install) {
    Start-Sleep -Milliseconds 200
    New-Item -Path $env:APPDATA\Spotify\ -Name "cache" -ItemType "directory" | Out-Null

    # Download cache script
    downloadScripts -param1 "cache-spotify"
    downloadScripts -param1 "hide_window"
    downloadScripts -param1 "run_ps"


    # Create a desktop shortcut
    if (!($no_shortcut)) {
        $source2 = "$cache_folder\hide_window.vbs"
        $target2 = "$desktop_folder\Spotify.lnk"
        $WorkingDir2 = "$cache_folder"
        $WshShell2 = New-Object -comObject WScript.Shell
        $Shortcut2 = $WshShell2.CreateShortcut($target2)
        $Shortcut2.WorkingDirectory = $WorkingDir2
        $Shortcut2.IconLocation = "$env:APPDATA\Spotify\Spotify.exe"
        $Shortcut2.TargetPath = $source2
        $Shortcut2.Save()
    }
    # Create shortcut in start menu
    $source2 = "$cache_folder\hide_window.vbs"
    $target2 = $start_menu
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

Write-Host ($lang).InstallComplete`n -ForegroundColor Green
