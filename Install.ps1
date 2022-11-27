param
(
    [Parameter(HelpMessage = 'Remove podcasts/episodes/audiobooks from homepage.')]
    [switch]$podcasts_off,
    
    [Parameter(HelpMessage = 'Do not remove podcasts/episodes/audiobooks from homepage.')]
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

    [Parameter(HelpMessage = 'Experimental features of SpotX are not included')]
    [switch]$exp_standart,
    
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

    [Parameter(HelpMessage = 'Disable the new home structure and navigation.')]
    [switch]$navalt_off,

    [Parameter(HelpMessage = 'Enable new left sidebar.')]
    [switch]$left_sidebar_on,
    
    [Parameter(HelpMessage = 'Do not create desktop shortcut.')]
    [switch]$no_shortcut,
    
    [Parameter(HelpMessage = 'Use bts patch.')]
    [switch]$bts,

    [Parameter(HelpMessage = 'Static color for lyrics.')]
    [int16]$lyrics_stat,

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
    
    begin {
        $supportLanguages = @(
            'en', 'ru', 'it', 'tr', 'ka', 'pl', 'es', 'fr', 'hi', 'pt', 'id', 'vi', 'ro', 'de', 'hu', 'zh', 'ko'
        )
    }
    
    process {
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
            '^zh' {
                $returnCode = 'zh'
                break
            }
            '^ko' {
                $returnCode = 'ko'
                break
            }
            Default {
                $returnCode = $PSUICulture.Remove(2)
                break
            }
        }
        
        # Confirm that the language code is supported by this script.
        if ($returnCode -NotIn $supportLanguages) {
            # If the language code is not supported default to English.
            $returnCode = 'en'
        }
    }
    
    end {
        return $returnCode
    }
}

function CallLang($clg) {

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $urlLang = "https://raw.githubusercontent.com/SpotX-CLI/SpotX-Win/main/scripts/installer-lang/$clg.ps1"
    $ProgressPreference = 'SilentlyContinue'
    
    try {
(Invoke-WebRequest -useb $urlLang).Content | Invoke-Expression 
    }
    catch {
        Write-Host "Error loading $clg language"
    }
}


function Set-ScriptLanguageStrings($LanguageCode) {
    
    #Sets the language strings to be used.
    
    switch ($LanguageCode) {
        'en' {
            $langStrings = CallLang -clg "en"
            break
        }
        'ru' {
            $langStrings = CallLang -clg "ru"
            break
        }
        'it' {
            $langStrings = CallLang -clg "it"
            break
        }
        'tr' {
            $langStrings = CallLang -clg "tr"
            break
        }
        'ka' {
            $langStrings = CallLang -clg "ka"
            break
        }
        'pl' {
            $langStrings = CallLang -clg "pl"
            break
        }
        'es' {
            $langStrings = CallLang -clg "es"
            break
        }
        'fr' {
            $langStrings = CallLang -clg "fr"
            break
        }
        'hi' {
            $langStrings = CallLang -clg "hi"
            break
        }
        'pt' {
            $langStrings = CallLang -clg "pt"
            break
        }
        'id' {
            $langStrings = CallLang -clg "id"
            break
        }
        'vi' {
            $langStrings = CallLang -clg "vi"
            break
        }
        'ro' {
            $langStrings = CallLang -clg "ro"
            break
        }
        'de' {
            $langStrings = CallLang -clg "de"
            break
        }
        'hu' {
            $langStrings = CallLang -clg "hu"
            break
        }
        'zh' {
            $langStrings = CallLang -clg "zh"
            break
        }
        'ko' {
            $langStrings = CallLang -clg "ko"
            break
        }
        Default {
            # Default to English if unable to find a match.
            $langStrings = CallLang -clg "en"
            break
        }
    }
    
 
    return $langStrings
}

# Set language code for script.
$langCode = Format-LanguageCode -LanguageCode $Language

# Set script language strings.
$lang = Set-ScriptLanguageStrings -LanguageCode $langCode

# Set variable 'ru'.
if ($langCode -eq 'ru') { 
    $ru = $true
    $urlru = "https://raw.githubusercontent.com/SpotX-CLI/SpotX-commons/main/Augmented%20translation/ru.json"
    $webjsonru = (Invoke-WebRequest -UseBasicParsing -Uri $urlru).Content | ConvertFrom-Json
}
# Set variable 'add translation line'.
if ($langCode -match '^(it|tr|ka|pl|es|fr|hi|pt|id|vi|ro|de|hu|zh|ko)') { $line = $true }

# Automatic length of stars
$au = ($lang).Author.Length + ($lang).Author2.Length
$by = ($lang).TranslationBy.Length + ($lang).TranslationBy2.Length
if ($au -gt $by ) { $long = $au + 1 } else { $long = $by + 1 } 
$st = ""
$star = $st.PadLeft($long, '*')

Write-Host $star
Write-Host ($lang).Author"" -NoNewline
Write-Host ($lang).Author2 -ForegroundColor DarkYellow
if (!($line)) { Write-Host $star`n }
if ($line) {
    Write-Host ($lang).TranslationBy"" -NoNewline
    Write-Host ($lang).TranslationBy2 -ForegroundColor DarkYellow
    Write-Host $star`n
}

# Sending a statistical web query to cutt.ly
$ErrorActionPreference = 'SilentlyContinue'
$cutt_url = "https://cutt.ly/DK8UQub"
try {
    $ProgressPreference = 'SilentlyContinue'
    Invoke-WebRequest -Uri $cutt_url | Out-Null
}
catch {
    Start-Sleep -Milliseconds 2300
    try { 
        Invoke-WebRequest -Uri $cutt_url | Out-Null
    }
    catch { }
}

$spotifyDirectory = "$env:APPDATA\Spotify"
$spotifyDirectory2 = "$env:LOCALAPPDATA\Spotify"
$spotifyExecutable = "$spotifyDirectory\Spotify.exe"
$exe_bak = "$spotifyDirectory\Spotify.bak"
$chrome_elf = "$spotifyDirectory\chrome_elf.dll"
$chrome_elf_bak = "$spotifyDirectory\chrome_elf_bak.dll"
$cache_folder = "$env:APPDATA\Spotify\cache"
$spotifyUninstall = "$env:TEMP\SpotifyUninstall.exe"
$start_menu = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Spotify.lnk"
$upgrade_client = $false

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
        
        $l = "$PWD\links.tsv"
        $old = [IO.File]::ReadAllText($l)
        $links = $old -match "https:\/\/upgrade.scdn.co\/upgrade\/client\/win32-x86\/spotify_installer-$online\.g[0-9a-f]{8}-[0-9]{1,4}\.exe" 
        $links = $Matches.Values
    }
    if ($ru -and $param1 -eq "cache-spotify") {
        $links2 = "https://raw.githubusercontent.com/SpotX-CLI/SpotX-Win/main/scripts/cache/cache_spotify_ru.ps1"
    }
    if (!($ru) -and $param1 -eq "cache-spotify" ) { 
        $links2 = "https://raw.githubusercontent.com/SpotX-CLI/SpotX-Win/main/scripts/cache/cache_spotify.ps1"
    }
    
    $web_Url_prev = "https://github.com/mrpond/BlockTheSpot/releases/latest/download/chrome_elf.zip", $links, `
        $links2, "https://raw.githubusercontent.com/SpotX-CLI/SpotX-Win/main/scripts/cache/hide_window.vbs", `
        "https://raw.githubusercontent.com/SpotX-CLI/SpotX-Win/main/scripts/cache/run_ps.bat", "https://docs.google.com/spreadsheets/d/e/2PACX-1vSFN2hWu4UO-ZWyVe8wlP9c0JsrduA49xBnRmSLOt8SWaOfIpCwjDLKXMTWJQ5aKj3WakQv6-Hnv9rz/pub?gid=0&single=true&output=tsv"

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
    }
    try { 
        if ($param1 -eq "Desktop" -and $curl_check) {
            $stcode = curl.exe -I -s $web_Url --retry 1 --ssl-no-revoke
            if (!($stcode -match "200 OK")) { throw ($lang).Download6 }
            curl.exe $web_Url -o $local_Url --progress-bar --retry 3 --ssl-no-revoke
        }
        if ($param1 -eq "Desktop" -and $null -ne (Get-Module -Name BitsTransfer -ListAvailable) -and !($curl_check )) {
            $ProgressPreference = 'Continue'
            Start-BitsTransfer -Source  $web_Url -Destination $local_Url  -DisplayName ($lang).Download5 -Description "$online "
        }
        if ($param1 -eq "Desktop" -and $null -eq (Get-Module -Name BitsTransfer -ListAvailable) -and !($curl_check )) {
            $webClient.DownloadFile($web_Url, $local_Url) 
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
                $stcode = curl.exe -I -s $web_Url --retry 1 --ssl-no-revoke
                if (!($stcode -match "200 OK")) { throw ($lang).Download6 }
                curl.exe $web_Url -o $local_Url --progress-bar --retry 3 --ssl-no-revoke
            }
            if ($param1 -eq "Desktop" -and $null -ne (Get-Module -Name BitsTransfer -ListAvailable) -and !($curl_check )) {
                Start-BitsTransfer -Source  $web_Url -Destination $local_Url  -DisplayName ($lang).Download5 -Description "$vernew "
            }
            if ($param1 -eq "Desktop" -and $null -eq (Get-Module -Name BitsTransfer -ListAvailable) -and !($curl_check )) {
                $webClient.DownloadFile($web_Url, $local_Url) 
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
            ($lang).StopScrpit
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

# Checking the recommended version for spotx
$ProgressPreference = 'SilentlyContinue' # Hiding Progress Bars
$readme = Invoke-WebRequest -UseBasicParsing -Uri https://raw.githubusercontent.com/SpotX-CLI/SpotX-Win/main/README.md
$match = $readme.RawContent | Select-String "Recommended official version \[\d+\.\d+\.\d+\.\d+\]" -AllMatches
$ver = $match.Matches.Value
$online = $ver -replace 'Recommended official version \[(\d+\.\d+\.\d+\.\d+)\]', '$1'

# Check version Spotify offline
$offline = (Get-Item $spotifyExecutable).VersionInfo.FileVersion

# Check version Spotify.bak
$offline_bak = (Get-Item $exe_bak).VersionInfo.FileVersion

# add Tls12
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Stop-Process -Name Spotify
$psv = $PSVersionTable.PSVersion.major
if ($psv -ge 7) {
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
            Read-Host ($lang).StopScrpit 
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
if (!($premium) -and $bts) {
    downloadScripts -param1 "BTS"
    Add-Type -Assembly 'System.IO.Compression.FileSystem'
    $zip = [System.IO.Compression.ZipFile]::Open("$PWD\chrome_elf.zip", 'read')
    [System.IO.Compression.ZipFileExtensions]::ExtractToDirectory($zip, $PWD)
    $zip.Dispose()
}
downloadScripts -param1 "links.tsv"

$spotifyInstalled = (Test-Path -LiteralPath $spotifyExecutable)

if ($spotifyInstalled) {

    # Old version Spotify
    if ($online -gt $offline) {
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
    
    # Unsupported version Spotify
    if ($online -lt $offline) {
        # Submit unsupported version of Spotify to google form for further processing
        try { 
            $txt = [IO.File]::ReadAllText($spotifyExecutable)
            $regex = "(\d+)\.(\d+)\.(\d+)\.(\d+)(\.g[0-9a-f]{8})"
            $v = $txt | Select-String $regex -AllMatches
            $version = $v.Matches.Value
            $Parameters = @{
                Uri    = 'https://docs.google.com/forms/d/e/1FAIpQLSegGsAgilgQ8Y36uw-N7zFF6Lh40cXNfyl1ecHPpZcpD8kdHg/formResponse'
                Method = 'POST'
                Body   = @{
                    'entry.620327948'  = $version
                    'entry.1402903593' = $win_os
                    'entry.860691305'  = $psv
                    'entry.2067427976' = $online + " меньше чем " + $offline
                }   
            }
            Invoke-WebRequest -UseBasicParsing @Parameters | Out-Null
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
                Write-Host ($lang).StopScrpit
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
    Stop-Process -Name Spotify

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

# Delete the leveldb folder (Fixes bug with incorrect experimental features for some accounts)
<# 
$leveldb = (Test-Path -LiteralPath "$spotifyDirectory2\Browser\Local Storage\leveldb")

if ($leveldb) {
    $ErrorActionPreference = 'SilentlyContinue'
    remove-item "$spotifyDirectory2\Browser\Local Storage\leveldb" -Recurse -Force
}
#>

# Create backup chrome_elf.dll
if (!(Test-Path -LiteralPath $chrome_elf_bak) -and !($premium) -and $bts) {
    Move-Item $chrome_elf $chrome_elf_bak 
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

if ($exp_standart) { Write-Host ($lang).ExpStandart`n }
if ($exp_spotify) { Write-Host ($lang).ExpSpotify`n }

$url = "https://raw.githubusercontent.com/SpotX-CLI/SpotX-commons/main/patches.json"
$webjson = (Invoke-WebRequest -UseBasicParsing -Uri $url).Content | ConvertFrom-Json

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
            # Static color for lyrics (xpui-routes-lyrics.css)
            $webjson.others.lyricscolor.replace[0] = '$1' + $webjson.others.lyricscolor.theme.$lyrics_stat.pasttext 
            $webjson.others.lyricscolor.replace[1] = '$1' + $webjson.others.lyricscolor.theme.$lyrics_stat.current 
            $webjson.others.lyricscolor.replace[2] = '$1' + $webjson.others.lyricscolor.theme.$lyrics_stat.next 
            $webjson.others.lyricscolor.replace[3] = '$1' + $webjson.others.lyricscolor.theme.$lyrics_stat.hover 
            $webjson.others.lyricscolor.replace[4] = $webjson.others.lyricscolor.theme.$lyrics_stat.background 
            $webjson.others.lyricscolor.replace[5] = '$1' + $webjson.others.lyricscolor.theme.$lyrics_stat.maxmatch 
            $name = "patches.json.others."
            $n = "xpui-routes-lyrics.css"
            $contents = "lyricscolor"
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
            if ($bts) { $webjson.free.psobject.properties.remove('bilboard'), $webjson.free.psobject.properties.remove('audioads') }
            if ($offline -ge "1.1.98.683") { $webjson.free.psobject.properties.remove('connectold') }
            $name = "patches.json.free."
            $n = "xpui.js"
            $contents = $webjson.free.psobject.properties.name
            $json = $webjson.free
        }
        "OffPodcasts" {  
            # Turn off podcasts
            $n = $js
            if ($offline -le "1.1.92.647") { $podcats = "podcastsoff" }
            if ($offline -ge "1.1.93.896" -and $offline -le "1.1.96.785") { $podcats = "podcastsoff2" }
            if ($offline -ge "1.1.97.952") { $podcats = "podcastsoff3" }
            $name = "patches.json.others."
            $contents = $podcats
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
        "Collaborators" { 
            # Hide Collaborators icon
            $name = "patches.json.others."
            $n = "xpui-routes-playlist.js"
            $contents = "collaboration"
            $json = $webjson.others
        }
        "ExpFeature" { 
            # Experimental Feature Standart
            $rem = $webjson.exp.psobject.properties 

            if ( $offline -le "1.1.96.785") { $rem.remove('newhome2'); $newhome = 'newhome' }
            if ( $offline -ge "1.1.97.956") { $rem.remove('newhome'); $newhome = 'newhome2' }
            if ( $offline -ge "1.1.99.871") { $rem.remove('clearcache') }
            if ( $offline -le "1.1.98.691") { $rem.remove('sidebar-fix') }
            if ($enhance_like_off) { $rem.remove('enhanceliked') }
            if ($enhance_playlist_off) { $rem.remove('enhanceplaylist') }
            if ($new_artist_pages_off) { $rem.remove('disographyartist') }
            if ($new_lyrics_off) { $rem.remove('lyricsmatch') }
            if ($equalizer_off) { $rem.remove('equalizer') }
            if (!($device_picker_old) -or $offline -ge "1.1.98.683") { $rem.remove('devicepickerold') }
            if ($made_for_you_off -or $offline -ge "1.1.96.783") { $rem.remove('madeforyou') }
            if ($offline -lt "1.1.98.683") { $rem.remove('rightsidebar'), $rem.remove('addingplaylist') }
            if ($exp_standart) {
                $rem.remove('enhanceliked'), $rem.remove('enhanceplaylist'), 
                $rem.remove('disographyartist'), $rem.remove('lyricsmatch'), 
                $rem.remove('equalizer'), $rem.remove('devicepicker'), 
                $rem.remove($newhome), $rem.remove('madeforyou'),
                $rem.remove('similarplaylist'), $rem.remove('leftsidebar'), $rem.remove('rightsidebar')
            }
            if (!($left_sidebar_on) -or $offline -le "1.1.97.956") { $rem.remove('leftsidebar') }
            if ($navalt_off) { $rem.remove($newhome) }
            if ($offline -ge "1.1.94.864") {
                $rem.remove('lyricsenabled'), $rem.remove('playlistcreat'), 
                $rem.remove('searchbox')
            }
            if ($offline -lt "1.1.90.859" -or $offline -gt "1.1.95.893") { $rem.remove('devicepicker') }
            if ($offline -le "1.1.93.896") { $rem.remove($newhome) }
            $name = "patches.json.exp."
            $n = "xpui.js"
            $contents = $webjson.exp.psobject.properties.name
            $json = $webjson.exp
        }
    }
    $paramdata = $xpui
    $novariable = "Didn't find variable "
    $contents | ForEach-Object { 
        
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

                if (!($paramname -eq "RuTranslate") -or $err_ru) {

    
                    Write-Host $novariable -ForegroundColor red -NoNewline 
                    Write-Host "$name$PSItem"'in'$n
                }
            }
        }    
    }
    $paramdata
}

function extract ($counts, $method, $name, $helper, $add) {
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
    }
}

Write-Host ($lang).ModSpoti`n

# Patching files
if (!($premium) -and $bts) {
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
if ($ru) { $xpui_ru_patch = "$env:APPDATA\Spotify\Apps\xpui\i18n\ru.json" }
$test_spa = Test-Path -Path $xpui_spa_patch
$test_js = Test-Path -Path $xpui_js_patch
$xpui_js_bak_patch = "$env:APPDATA\Spotify\Apps\xpui\xpui.js.bak"
$xpui_css_bak_patch = "$env:APPDATA\Spotify\Apps\xpui\xpui.css.bak"
$xpui_lic_bak_patch = "$env:APPDATA\Spotify\Apps\xpui\licenses.html.bak"
if ($ru) { $xpui_ru_bak_patch = "$env:APPDATA\Spotify\Apps\xpui\i18n\ru.json.bak" }
$spotify_exe_bak_patch = "$env:APPDATA\Spotify\Spotify.bak"


if ($test_spa -and $test_js) {
    Write-Host ($lang).Error -ForegroundColor Red
    Write-Host ($lang).FileLocBroken
    Write-Host ($lang).StopScrpit
    pause
    Exit
}

if (Test-Path $xpui_js_patch) {
    Write-Host ($lang).Spicetify`n

    # Delete all files except "en", "ru" and "__longest"
    if ($ru) {
        $patch_lang = "$env:APPDATA\Spotify\Apps\xpui\i18n"
        Remove-Item $patch_lang -Exclude *en*, *ru*, *__longest* -Recurse
    }

    $reader = New-Object -TypeName System.IO.StreamReader -ArgumentList $xpui_js_patch
    $xpui_test_js = $reader.ReadToEnd()
    $reader.Close()
        
    If ($xpui_test_js -match 'patched by spotx') {

        $test_xpui_js_bak = Test-Path -Path $xpui_js_bak_patch
        $test_xpui_css_bak = Test-Path -Path $xpui_css_bak_patch
        $test_xpui_lic_bak = Test-Path -Path $xpui_lic_bak_patch
        if ($ru) { $test_xpui_ru_bak = Test-Path -Path $xpui_ru_bak_patch }
        $test_spotify_exe_bak = Test-Path -Path $spotify_exe_bak_patch

        if ($test_xpui_js_bak -and $test_xpui_css_bak) {
            
            Remove-Item $xpui_js_patch -Recurse -Force
            Rename-Item $xpui_js_bak_patch $xpui_js_patch
            
            Remove-Item $xpui_css_patch -Recurse -Force
            Rename-Item $xpui_css_bak_patch $xpui_css_patch
            
            if ($test_xpui_lic_bak) {
                Remove-Item $xpui_lic_patch -Recurse -Force
                Rename-Item $xpui_lic_bak_patch $xpui_lic_patch
            }
            if ($test_xpui_ru_bak -and $ru) {
                Remove-Item $xpui_ru_patch -Recurse -Force
                Rename-Item $xpui_ru_bak_patch $xpui_ru_patch
            }
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

    }

    Copy-Item $xpui_js_patch $xpui_js_bak_patch
    Copy-Item $xpui_css_patch $xpui_css_bak_patch
    Copy-Item $xpui_lic_patch $xpui_lic_bak_patch
    if ($ru) { Copy-Item $xpui_ru_patch $xpui_ru_bak_patch }

    
    # Full screen mode activation and removing "Upgrade to premium" menu, upgrade button, disabling a playlist sponsor
    if (!($premium)) { extract -counts 'one' -method 'nonezip' -name 'xpui.js' -helper 'OffadsonFullscreen' }   

    # Experimental Feature
    if (!($exp_spotify)) { extract -counts 'one' -method 'nonezip' -name 'xpui.js' -helper 'ExpFeature' }

    # Remove all languages except En and Ru from xpui.js
    if ($ru) { extract -counts 'one' -method 'nonezip' -name 'xpui.js' -helper 'OffRujs' -add $webjson.others.byspotx.add }

    # Russian additional translation
    if ($ru) {
        extract -counts 'one' -method 'nonezip' -name 'i18n\ru.json' -helper 'RuTranslate'
    }

    extract -counts 'one' -method 'nonezip' -name 'xpui-desktop-modals.js' -helper 'Discriptions'

    # Hide Collaborators icon
    if (!($hide_col_icon_off) -and !($exp_spotify)) {
        extract -counts 'one' -method 'nonezip' -name 'xpui-routes-playlist.js' -helper 'Collaborators'
    }

    # Turn off podcasts
    if ($Podcast_off) { 
        if ($offline -ge "1.1.93.896" -and $offline -le "1.1.97.962") { $js = "home-v2.js" }
        if ($offline -le "1.1.92.647" -or $offline -ge "1.1.98.683") { $js = "xpui.js" }
        extract -counts 'one' -method 'nonezip' -name $js -helper 'OffPodcasts'
    }

    # Static color for lyrics
    if ($lyrics_stat) {
        extract -counts 'one' -method 'nonezip' -name 'xpui-routes-lyrics.css' -helper 'Lyrics-color'
    }
    
    # xpui.css
    if (!($premium)) {
        # Hide download icon on different pages
        $icon = $webjson.others.downloadicon.add
        # Hide submenu item "download"
        $submenu = $webjson.others.submenudownload.add
        # Hide very high quality streaming
        $very_high = $webjson.others.veryhighstream.add
    }

    $css = $icon, $submenu, $very_high

    extract -counts 'one' -method 'nonezip' -name 'xpui.css' -add $css

    # licenses.html minification
    extract -counts 'one' -method 'nonezip' -name 'licenses.html' -helper 'HtmlLicMin'
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
            Write-Host ($lang).NoRestore2`n
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

        $files = 'af.json', 'am.json', 'ar.json', 'ar-EG.json', 'ar-SA.json', 'ar-MA.json', 'az.json', 'bg.json', 'bho.json', 'bn.json', `
            'bs.json', 'cs.json', 'ca.json', 'gl.json', 'da.json', 'de.json', 'en-GB.json', 'el.json', 'es-419.json', 'es-MX.json', 'es-AR.json', 'es.json', 'et.json', 'fa.json', `
            'fi.json', 'fil.json', 'fr-CA.json', 'fr.json', 'gu.json', 'he.json', 'hi.json', 'eu.json', 'hu.json', `
            'id.json', 'is.json', 'it.json', 'ja.json', 'kn.json', 'ko.json', 'lt.json', 'lv.json', `
            'ml.json', 'mr.json', 'ms.json', 'mk.json', 'nb.json', 'ne.json', 'nl.json', 'or.json', 'pa-IN.json', `
            'pl.json', 'pt-BR.json', 'pt-PT.json', 'ro.json', 'sk.json', 'sl.json', 'sr.json', 'sv.json', `
            'sw.json' , 'ta.json', 'te.json', 'th.json', 'tr.json', 'uk.json', 'ur.json', 'vi.json', `
            'zh-CN.json', 'zh-TW.json', 'zh-HK.json', 'zu.json', 'pa-PK.json', 'hr.json'

        $stream = New-Object IO.FileStream($xpui_spa_patch, [IO.FileMode]::Open)
        $mode = [IO.Compression.ZipArchiveMode]::Update
        $zip_xpui = New-Object IO.Compression.ZipArchive($stream, $mode)

    ($zip_xpui.Entries | Where-Object { $files -contains $_.Name }) | ForEach-Object { $_.Delete() }

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

    # Hide Collaborators icon
    if (!($hide_col_icon_off) -and !($exp_spotify)) {
        extract -counts 'one' -method 'zip' -name 'xpui-routes-playlist.js' -helper 'Collaborators'
    }


    # Static color for lyrics
    if ($lyrics_stat) {
        extract -counts 'one' -method 'zip' -name 'xpui-routes-lyrics.css' -helper 'Lyrics-color'
    }

    # Add discriptions (xpui-desktop-modals.js)
    extract -counts 'one' -method 'zip' -name 'xpui-desktop-modals.js' -helper 'Discriptions'

    # Disable Sentry (vendor~xpui.js)
    extract -counts 'one' -method 'zip' -name 'vendor~xpui.js' -helper 'DisableSentry'

    # Minification of all *.js
    extract -counts 'more' -name '*.js' -helper 'MinJs'

    # xpui.css
    if (!($premium)) {
        # Hide download icon on different pages
        $icon = $webjson.others.downloadicon.add
        # Hide submenu item "download"
        $submenu = $webjson.others.submenudownload.add
        # Hide very high quality streaming
        $very_high = $webjson.others.veryhighstream.add
    }

    # New UI fix
    if (!($navalt_off)) {
        $navaltfix = $webjson.others.navaltfix.add[0]
        $navaltfix2 = $webjson.others.navaltfix.add[1]
    }
    $css = $icon, $submenu, $very_high, $navaltfix, $navaltfix2

    extract -counts 'one' -method 'zip' -name 'xpui.css' -add $css

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

# Block updates
$ErrorActionPreference = 'SilentlyContinue'
$update_test_exe = Test-Path -Path $spotifyExecutable

if ($block_update) {

    if ($update_test_exe) {
        $exe = "$env:APPDATA\Spotify\Spotify.exe"
        $ANSI = [Text.Encoding]::GetEncoding(1251)
        $old = [IO.File]::ReadAllText($exe, $ANSI)

        if ($old -match "(?<=wg:\/\/desktop-update\/.)7(\/update)") {
            Write-Host ($lang).UpdateBlocked`n
        }
        elseif ($old -match "(?<=wg:\/\/desktop-update\/.)2(\/update)") {
            if (Test-Path -LiteralPath $exe_bak) { 
                Remove-Item $exe_bak -Recurse -Force
                Start-Sleep -Milliseconds 150
            }
            copy-Item $exe $exe_bak
            $new = $old -replace "(?<=wg:\/\/desktop-update\/.)2(\/update)", '7/update'
            [IO.File]::WriteAllText($exe, $new, $ANSI)
        }
        else {
            Write-Host ($lang).UpdateError`n -ForegroundColor Red
        }
    }
    else {
        Write-Host ($lang).NoSpotifyExe`n -ForegroundColor Red 
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