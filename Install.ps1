param
(
    [Parameter(HelpMessage = 'Remove podcasts from homepage.')]
    [switch]$podcasts_off,
    
    [Parameter(HelpMessage = 'Do not remove podcasts from homepage.')]
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
    
    [Parameter(HelpMessage = 'Do not enable the made for you button on the left sidebar.')]
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
    
    [Parameter(HelpMessage = 'Enable showing a new and improved device picker UI.')]
    [switch]$device_new_off,

    [Parameter(HelpMessage = 'Disable the new home structure and navigation.')]
    [switch]$navalt_off,

    [Parameter(HelpMessage = 'Do not create desktop shortcut.')]
    [switch]$no_shortcut,
    
    [Parameter(HelpMessage = 'Use bts patch.')]
    [switch]$bts,
    
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
            'en', 'ru', 'it', 'tr', 'ka', 'pl', 'es', 'fr', 'hi', 'pt'
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
    $urlLang = "https://raw.githubusercontent.com/amd64fox/SpotX/main/scripts/installer-lang/$clg.ps1"
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
if ($langCode -eq 'ru') { $ru = $true }
# Set variable 'add transl line'.
if ($langCode -match '^(it|tr|ka|pl|es|fr|hi|pt)') { $line = $true }

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
    # Check version Spotify.bak
    if ($param2 -eq "Spotify.bak") {
        $check_offline_bak = (Get-Item $exe_bak).VersionInfo.FileVersion
        return $check_offline_bak
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
    if ($ru -and $param1 -eq "cache-spotify") {
        $links2 = "https://raw.githubusercontent.com/amd64fox/SpotX/main/scripts/cache/cache_spotify_ru.ps1"
    }
    if (!($ru) -and $param1 -eq "cache-spotify" ) { 
        $links2 = "https://raw.githubusercontent.com/amd64fox/SpotX/main/scripts/cache/cache_spotify.ps1"
    }
    
    $web_Url_prev = "https://github.com/mrpond/BlockTheSpot/releases/latest/download/chrome_elf.zip", $links, `
        $links2, "https://raw.githubusercontent.com/amd64fox/SpotX/main/scripts/cache/hide_window.vbs", `
        "https://raw.githubusercontent.com/amd64fox/SpotX/main/scripts/cache/run_ps.bat", "https://docs.google.com/spreadsheets/d/e/2PACX-1vSFN2hWu4UO-ZWyVe8wlP9c0JsrduA49xBnRmSLOt8SWaOfIpCwjDLKXMTWJQ5aKj3WakQv6-Hnv9rz/pub?gid=0&single=true&output=tsv"

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
            $stcode = curl.exe -I -s $web_Url --retry 1 --ssl-no-revoke
            if (!($stcode -match "200 OK")) { throw ($lang).Download6 }
            curl.exe $web_Url -o $local_Url --progress-bar --retry 3 --ssl-no-revoke
        }
        if ($param1 -eq "Desktop" -and $null -ne (Get-Module -Name BitsTransfer -ListAvailable) -and !($curl_check )) {
            $ProgressPreference = 'Continue'
            Start-BitsTransfer -Source  $web_Url -Destination $local_Url  -DisplayName ($lang).Download5 -Description "$vernew "
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

# add Tls12
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Stop-Process -Name Spotify

if ($PSVersionTable.PSVersion.major -ge 7) {
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
if (!($premium)) {
    if ($bts) {
        downloadScripts -param1 "BTS"
        Add-Type -Assembly 'System.IO.Compression.FileSystem'
        $zip = [System.IO.Compression.ZipFile]::Open("$PWD\chrome_elf.zip", 'read')
        [System.IO.Compression.ZipFileExtensions]::ExtractToDirectory($zip, $PWD)
        $zip.Dispose()
    }
}
downloadScripts -param1 "links.tsv"


$online = Check_verison_clients -param2 "online"

$spotifyInstalled = (Test-Path -LiteralPath $spotifyExecutable)

if ($spotifyInstalled) {

    $offline = Check_verison_clients -param2 "offline"

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

    if ($online -lt $offline) {

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
}

# Delete Spotify shortcut if it is on desktop
if ($no_shortcut) {
    $ErrorActionPreference = 'SilentlyContinue'
    $desktop_folder = DesktopFolder
    Start-Sleep -Milliseconds 1000
    remove-item "$desktop_folder\Spotify.lnk" -Recurse -Force
}

# Delete the leveldb folder (Fixes bug with incorrect experimental features for some accounts)
$leveldb = (Test-Path -LiteralPath "$spotifyDirectory2\Browser\Local Storage\leveldb")

if ($leveldb) {
    $ErrorActionPreference = 'SilentlyContinue'
    remove-item "$spotifyDirectory2\Browser\Local Storage\leveldb" -Recurse -Force
}

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
    $exe_onl_fn = Check_verison_clients -param2 "offline"
    $exe_bak_fn = Check_verison_clients -param2 'Spotify.bak'
    if ((Test-Path -LiteralPath $exe_bak) -and $exe_onl_fn -eq $exe_bak_fn) {
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

function Helper($paramname, $addstring) {

    switch ( $paramname ) {
        "HtmlLicMin" { 
            # licenses.html minification
            $html_lic_min = @{
                HtmlLicMin1 = '<li><a href="#6eef7">zlib<\/a><\/li>\n(.|\n)*<\/p><!-- END CONTAINER DEPS LICENSES -->(<\/div>)', '$2'
                HtmlLicMin2 = '	', ''
                HtmlLicMin3 = '  ', ''
                HtmlLicMin4 = '(?m)(^\s*\r?\n)', ''
                HtmlLicMin5 = '\r?\n(?!\(1|\d)', ''
            }
            $n = ($lang).NoVariable6
            $contents = $html_lic_min
            $paramdata = $xpuiContents_html
        }
        "Discriptions" {  
            # Add discriptions (xpui-desktop-modals.js)
            $about = "`$1`"<h3>More about SpotX</h3>`"}),`$1`'<a `
        href=`"https://github.com/amd64fox/SpotX`">Github</a>`'}),`$1`'<a `
        href=`"https://github.com/amd64fox/SpotX/discussions/111`">FAQ</a>'}),`$1`'<a `
        href=`"https://t.me/spotify_windows_mod`">Telegram channel</a>`'}),`$1`'<a `
        href=`"https://github.com/amd64fox/SpotX/issues/new?assignees=&labels=%E2%9D%8C+bug&template=bug_report.yml`">Create `
        an issue report</a>`'}),`$1`"<br>`"}),`$1`"<h4>DISCLAIMER</h4>`"}),`$1`"SpotX is a modified version of the official Spotify client, provided as an evaluation version, you use it at your own risk.`"})"

            $discript = @{
                Log = '(..createElement\(....,{source:).....get\("about.copyright",.\),paragraphClassName:.}\)', $about
            }
            $n = ($lang).NoVariable2
            $contents = $discript
            $paramdata = $xpui_desktop_modals

        }
        "OffadsonFullscreen" { 
            $offadson_fullscreen = @{
                # Removing a billboard on the homepage
                Bilboard            = '.(\?\[..\(..leaderboard,)', 'false$1' 
                # Removing audio ads
                AidioAds            = '(case .:)return this.enabled=...+?(;case .:this.subscription=this.audioApi).+?(;case .)', '$1$2.cosmosConnector.increaseStreamTime(-100000000000)$3'
                # Removing an empty block
                EmptyBlockAd        = 'adsEnabled:!0', 'adsEnabled:!1'
                # Fullscreen act., removing upgrade menu, button
                FullScreenAd        = '(return|.=.=>)"free"===(.+?)(return|.=.=>)"premium"===', '$1"premium"===$2$3"free"==='
                # Disabling a playlist sponsor
                PlaylistSponsorsOff = 'allSponsorships', ''
                # Connect unlock test for 1.1.91 >
                ConnectUnlock       = ' connect-device-list-item--disabled', ''
                ConnectUnlock2      = 'connect-picker.unavailable-to-control', 'spotify-connect'
                ConnectUnlock3      = '(className:.,disabled:)(..)', '$1false'
                ConnectUnlock4      = 'return (..isDisabled)(\?..createElement\(..,)', 'return false$2'
                # Removing the track download quality switch
                DownloadQuality     = 'xe\(...\)\)\)\)...createElement\(....{filterMatchQuery:.....get\(.desktop.settings.downloadQuality.title.\).+?xe', 'xe'
            }
            if ($bts) {
                $offadson_fullscreen.Remove('Bilboard'), $offadson_fullscreen.Remove('AidioAds')
            }

            $n = ($lang).NoVariable2
            $contents = $offadson_fullscreen
            $paramdata = $xpui_js
        }
        "OffPodcasts" {  
            # Turn off podcasts
            $podcasts_off = @{
                PodcastsOff = '(\!Array.isArray\(.\)\|\|.===..length)', "`$1||e.children[0].key.includes('episode')||e.children[0].key.includes('show')"
            }
            $n = ($lang).NoVariable5
            $contents = $podcasts_off
            $paramdata = $xpui_homev2
        }
        "OffRujs" { 
            # Remove all languages except En and Ru from xpui.js
            $rus_js = @{
                OffRujs = '(\[a\.go\.en,)(.+?\])', '$1a.go.ru]'
            }
            $n = ($lang).NoVariable2
            $contents = $rus_js
            $paramdata = $xpui_js

        }
        "RuTranslate" { 
            # Additional translation of some words for the Russian language
            $ru_translate = @{
                EnhancePlaylist    = '"To Enhance this playlist, you.ll need to go online."', '"Чтобы улучшить этот плейлист, вам нужно подключиться к интернету."'
                ConfirmAge         = '"Confirm your age"', '"Подтвердите свой возраст"' 
                Premium            = '"%price%\/month after. Terms and conditions apply. One month free not available for users who have already tried Premium."', '"%price%/месяц спустя. Принять условия. Один месяц бесплатно, недоступно для пользователей, которые уже попробовали Premium."'
                AdFreeMusic        = '"Enjoy ad-free music listening, offline listening, and more. Cancel anytime."', '"Наслаждайтесь прослушиванием музыки без рекламы, прослушиванием в офлайн режиме и многим другим. Отменить можно в любое время."'
                AddPlaylist        = '"Add to another playlist"', '"Добавить в другой плейлист"' 
                OfflineStorage     = '"Offline storage location"', '"Хранилище скачанных треков"' 
                ChangeLocation     = '"Change location"', '"Изменить место"' 
                Linebreaks         = '"Line breaks aren.t supported in the description."', '"В описании не поддерживаются разрывы строк."' 
                PressSave          = '"Press save to keep changes you.ve made."', '"Нажмите «Сохранить», чтобы сохранить внесенные изменения."' 
                NoInternet         = '"No internet connection found. Changes to description and image will not be saved."', '"Подключение к интернету не найдено. Изменения в описании и изображении не будут сохранены."' 
                ImageSmall         = '"Image too small. Images must be at least [{]0[}]x[{]1[}]."', '"Изображение слишком маленькое. Изображения должны быть не менее {0}x{1}."' 
                FailedUpload       = '"Failed to upload image. Please try again."', '"Не удалось загрузить изображение. Пожалуйста, попробуйте снова."' 
                Description        = '"Description"', '"Описание"' 
                ChangePhoto        = '"Change photo"', '"Сменить изображение"' 
                RemovePhoto        = '"Remove photo"', '"Удалить изображение"' 
                Name               = '"Name"', '"Имя"' 
                ChangeSpeed        = '"Change speed"', '"Изменение скорости"' 
                Years19            = '"You need to be at least 19 years old to listen to explicit content marked with"', '"Вам должно быть не менее 19 лет, чтобы слушать непристойный контент, помеченный значком"' 
                AddPlaylist2       = '"Add to this playlist"', '"Добавить в этот плейлист"'
                NoConnect          = '"Couldn.t connect to Spotify."', '"Не удалось подключиться к Spotify."' 
                Reconnecting       = '"Reconnecting..."', '"Повторное подключение..."' 
                NoConnection       = '"No connection"', '"Нет соединения"' 
                CharacterCounter   = '"Character counter"', '"Счетчик символов"' 
                Lightsaber         = '"Toggle lightsaber hilt. Current is [{]0[}]."', '"Переключить рукоять светового меча. Текущий {0}."' 
                SongAvailable      = '"Song not available"', '"Песня недоступна"' 
                HiFi               = '"The song you.re trying to listen to is not available in HiFi at this time."', '"Песня, которую вы пытаетесь прослушать, в настоящее время недоступна в HiFi."' 
                Quality            = '"Current audio quality:"', '"Текущее качество звука:"' 
                Network            = '"Network connection"', '"Подключение к сети"' 
                Good               = '"Good"', '"Хорошее"' 
                Poor               = '"Poor"', '"Плохое"' 
                Yes                = '"Yes"', '"Да"' 
                No                 = '"No"', '"Нет"' 
                Location           = '"Your Location"', '"Ваше местоположение"'
                NetworkConnection  = '"Network connection failed while playing this content."', '"Сбой сетевого подключения при воспроизведении этого контента."'
                ContentLocation    = '"We.re not able to play this content in your current location."', '"Мы не можем воспроизвести этот контент в вашем текущем местоположении."'
                ContentUnavailable = '"This content is unavailable. Try another\?"', '"Этот контент недоступен. Попробуете другой?"'
                NoContent          = '"Sorry, we.re not able to play this content."', '"К сожалению, мы не можем воспроизвести этот контент."'
                NoContent2         = '"Hmm... we can.t seem to play this content. Try installing the latest version of Spotify."', '"Хм... похоже, мы не можем воспроизвести этот контент. Попробуйте установить последнюю версию Spotify."'
                NoContent3         = '"Please upgrade Spotify to play this content."', '"Пожалуйста, обновите Spotify, чтобы воспроизвести этот контент."'
                NoContent4         = '"This content cannot be played on your operating system version."', '"Этот контент нельзя воспроизвести в вашей версии операционной системы."'
                DevLang            = '"Override certain user attributes to test regionalized content programming. The overrides are only active in this app."', '"Переопределите определенные атрибуты пользователя, чтобы протестировать региональное программирование контента. Переопределения активны только в этом приложении."'
                AlbumRelease       = '"...name... was released this week!"', '"\"%name%\" был выпущен на этой неделе!"'
                AlbumReleaseOne    = '"one": "\\"%name%\\" was released %years% year ago this week!"', '"one": "\"%name%\" был выпущен %years% год назад на этой неделе!"'
                AlbumReleaseFew    = '"few": "\\"%name%\\" was released %years% years ago this week!"', '"few": "\"%name%\" был выпущен %years% года назад на этой неделе!"'
                AlbumReleaseMany   = '"many": "\\"%name%\\" was released %years% years ago this week!"', '"many": "\"%name%\" был выпущен %years% лет назад на этой неделе!"'
                AlbumReleaseOther  = '"other": "\\"%name%\\" was released %years% years ago this week!"', '"other": "\"%name%\" был выпущен %years% года назад на этой неделе!"'
                Speed              = '"Speed [{]0[}]×"', '"Скорость {0}×"'
                AudiobookGet       = '"Get"', '"Получить"'
                AudiobookBy        = '"Buy"', '"Купить"'
                CloseModal         = '"Close modal"', '"Закрыть"'
                RatinggoToApp      = '"Head over to Spotify on your mobile phone to rate this title."', '"Зайдите в Spotify на своем мобильном телефоне, чтобы оценить этот заголовок."'
                Freexplanation     = '"Tap Get to add it to Your Library and it will be ready for listening in a few seconds."', '"Нажмите «Получить», чтобы добавить его в свою библиотеку, и через несколько секунд он будет готов для прослушивания."'
                Confidential       = '"This is a highly confidential test. Do not share details of this test or any song you create outside of Spotify."', '"Это очень конфиденциальный тест. Не делитесь подробностями этого теста или какой-либо песни, которую вы создаете, за пределами Spotify."'
                LoveAudiobook      = '"Love this audiobook\? Unlock all chapters first"', '"Нравится эта аудиокнига? Сначала разблокируйте все главы"'
                FullAudiobook      = '"You can listen to this chapter after purchasing the full audiobook."', '"Вы можете прослушать эту главу после покупки полной аудиокниги."'
                PurchaseAudiobook  = '"Purchase audiobook"', '"Купить аудиокнигу"'
                Cache              = '"Cache:"', '"Кеш:"'
                Downloads          = '"Downloads:"', '"Загрузки:"'

            }
            $n = ($lang).NoVariable7
            $contents = $ru_translate
            $paramdata = $xpui_ru
        }

        "ExpFeature" { 
            # Experimental Feature Standart
            $exp_features = @{
                LikedArtistPage  = '(Enable Liked Songs section on Artist page",default:)(!1)', '$1true' 
                BlockUsers       = '(Enable block users feature in clientX",default:)(!1)', '$1true' 
                Quicksilver      = '(Enables quicksilver in-app messaging modal",default:)(!0)', '$1false' 
                IgnorInRec       = '(Enable Ignore In Recommendations for desktop and web",default:)(!1)', '$1true'
                Prod             = '(Enable Playlist Permissions flows for Prod",default:)(!1)', '$1true'
                ShowingBalloons  = '(Enable showing balloons on album release date anniversaries",default:)(!1)', '$1true'
                EnhanceLiked     = '(Enable Enhance Liked Songs UI and functionality",default:)(!1)', '$1true'
                EnhancePlaylist  = '(Enable Enhance Playlist UI and functionality for end-users",default:)(!1)', '$1true' 
                DisographyArtist = '(Enable a condensed disography shelf on artist pages",default:)(!1)', '$1true' 
                LyricsMatch      = '(Enable Lyrics match labels in search results",default:)(!1)', '$1true'  
                Equalizer        = '(Enable audio equalizer for Desktop and Web Player",default:)(!1)', '$1true' 
                DevicePicker     = '(Enable showing a new and improved device picker UI",default:)(!1)', '$1true'
                NewHome          = '(Enable the new home structure and navigation",values:.,default:)(..DISABLED)', '$1true'
                MadeForYou       = '(Show "Made For You" entry point in the left sidebar.,default:)(!1)', '$1true'
                ClearCache       = '(Enable option in settings to clear all downloads",default:)(!1)', '$1true'
                CarouselsonHome  = '(Use carousels on Home",default:)(!1)', '$1true'
                LyricsEnabled    = '(With this enabled, clients will check whether tracks have lyrics available",default:)(!1)', '$1true' 
                PlaylistCreation = '(Enables new playlist creation flow in Web Player and DesktopX",default:)(!1)', '$1true'
                SearchBox        = '(Adds a search box so users are able to filter playlists when trying to add songs to a playlist using the contextmenu",default:)(!1)', '$1true'
                # "Create similar playlist" menu is activated for someone else's playlists
                SimilarPlaylist  = ',(.\.isOwnedBySelf&&)(..createElement\(..Fragment,null,..createElement\(.+?{(uri:.|spec:.),(uri:.|spec:.).+?contextmenu.create-similar-playlist"\)}\),)' , ',$2$1'
            }
            if ($enhance_like_off) { $exp_features.Remove('EnhanceLiked') }
            if ($enhance_playlist_off) { $exp_features.Remove('EnhancePlaylist') }
            if ($new_artist_pages_off) { $exp_features.Remove('DisographyArtist') }
            if ($new_lyrics_off) { $exp_features.Remove('LyricsMatch') }
            if ($equalizer_off) { $exp_features.Remove('Equalizer') }
            if ($device_new_off) { $exp_features.Remove('DevicePicker') }
            if ($navalt_off) { $exp_features.Remove('NewHome') }
            if ($made_for_you_off) { $exp_features.Remove('MadeForYou') }
            if ($exp_standart) {
                $exp_features.Remove('EnhanceLiked'), $exp_features.Remove('EnhancePlaylist'), 
                $exp_features.Remove('DisographyArtist'), $exp_features.Remove('LyricsMatch'), 
                $exp_features.Remove('Equalizer'), $exp_features.Remove('DevicePicker'), 
                $exp_features.Remove('NewHome'), $exp_features.Remove('MadeForYou'),
                $exp_features.Remove('SimilarPlaylist')
            }
            $ofline = Check_verison_clients -param2 "offline"
            if ($ofline -ge "1.1.94.864") {
                $exp_features.Remove('LyricsEnabled'), $exp_features.Remove('PlaylistCreation'), 
                $exp_features.Remove('SearchBox')
            }
            if ($ofline -le "1.1.93.896") { $exp_features.Remove('NewHome') }
            $n = ($lang).NoVariable2
            $contents = $exp_features
            $paramdata = $xpui_js
        }


    }
    $contents.Keys | Sort-Object | ForEach-Object { 
 
        if ($paramdata -match $contents.$PSItem[0]) { 
            $paramdata = $paramdata -replace $contents.$PSItem[0], $contents.$PSItem[1] 
        }
        else { 
            Write-Host ($lang).NoVariable"" -ForegroundColor red -NoNewline 
            Write-Host "`$contents.$PSItem"$n
        }    
    }
    $paramdata
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

    $reader = New-Object -TypeName System.IO.StreamReader -ArgumentList $xpui_js_patch
    $xpui_js = $reader.ReadToEnd()
    $reader.Close()
    
    # Full screen mode activation and removing "Upgrade to premium" menu, upgrade button, disabling a playlist sponsor
    if (!($premium)) { $xpui_js = Helper -paramname "OffadsonFullscreen" } 

    # Experimental Feature
    if (!($exp_spotify)) { $xpui_js = Helper -paramname "ExpFeature" }

    # Remove all languages except En and Ru from xpui.js
    if ($ru) { $xpui_js = Helper -paramname "OffRujs" }

    $writer = New-Object System.IO.StreamWriter -ArgumentList $xpui_js_patch
    $writer.BaseStream.SetLength(0)
    $writer.Write($xpui_js)
    $writer.Write([System.Environment]::NewLine + '// Patched by SpotX') 
    $writer.Close()  

    # Russian additional translation
    if ($ru) {
        $file_ru = get-item $env:APPDATA\Spotify\Apps\xpui\i18n\ru.json
        $reader = New-Object -TypeName System.IO.StreamReader -ArgumentList $file_ru
        $xpui_ru = $reader.ReadToEnd()
        $reader.Close()
        $xpui_ru = Helper -paramname "RuTranslate"
        $writer = New-Object System.IO.StreamWriter -ArgumentList $file_ru
        $writer.BaseStream.SetLength(0)
        $writer.Write($xpui_ru)
        $writer.Close()  
    }
    $file_desktop_modals = get-item $env:APPDATA\Spotify\Apps\xpui\xpui-desktop-modals.js
    $reader = New-Object -TypeName System.IO.StreamReader -ArgumentList $file_desktop_modals
    $xpui_desktop_modals = $reader.ReadToEnd()
    $reader.Close()
    $xpui_desktop_modals = Helper -paramname "Discriptions"
    $writer = New-Object System.IO.StreamWriter -ArgumentList $file_desktop_modals
    $writer.BaseStream.SetLength(0)
    $writer.Write($xpui_desktop_modals)
    $writer.Close()  

    # Turn off podcasts
    if ($Podcast_off) { 
        $file_homev2 = get-item $env:APPDATA\Spotify\Apps\xpui\home-v2.js
        $reader = New-Object -TypeName System.IO.StreamReader -ArgumentList $file_homev2
        $xpui_homev2 = $reader.ReadToEnd()
        $reader.Close()
        $xpui_homev2 = Helper -paramname "OffPodcasts" 
        $writer = New-Object System.IO.StreamWriter -ArgumentList $file_homev2
        $writer.BaseStream.SetLength(0)
        $writer.Write($xpui_homev2)
        $writer.Close()  
    }

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
        # Hide very high quality streaming
        $writer.Write([System.Environment]::NewLine + ' #desktop\.settings\.streamingQuality>option:nth-child(5) {display:none}')
    }
    # new UI fix
    if (!($navalt_off)) {
        $writer.Write([System.Environment]::NewLine + ' .nav-alt .Root__top-container {background: #00000085;gap: 6px;padding: 8px;}')
        $writer.Write([System.Environment]::NewLine + ' .Root__fixed-top-bar {background-color: #00000000}')
    }
    # Hide Collaborators icon
    if (!($hide_col_icon_off) -and !($exp_spotify)) {
        $writer.Write([System.Environment]::NewLine + ' .X1lXSiVj0pzhQCUo_72A{display:none}')
    }
    $writer.Close()

    # licenses.html minification
    $file_licenses = get-item $env:APPDATA\Spotify\Apps\xpui\licenses.html
    $reader = New-Object -TypeName System.IO.StreamReader -ArgumentList $file_licenses
    $xpuiContents_html = $reader.ReadToEnd()
    $reader.Close()
    $xpuiContents_html = Helper -paramname "HtmlLicMin" 
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

        $files = 'af.json', 'am.json', 'ar.json', 'az.json', 'bg.json', 'bho.json', 'bn.json', `
            'cs.json', 'da.json', 'de.json', 'el.json', 'es-419.json', 'es.json', 'et.json', 'fa.json', `
            'fi.json', 'fil.json', 'fr-CA.json', 'fr.json', 'gu.json', 'he.json', 'hi.json', 'hu.json', `
            'id.json', 'is.json', 'it.json', 'ja.json', 'kn.json', 'ko.json', 'lt.json', 'lv.json', `
            'ml.json', 'mr.json', 'ms.json', 'nb.json', 'ne.json', 'nl.json', 'or.json', 'pa-IN.json', `
            'pl.json', 'pt-BR.json', 'pt-PT.json', 'ro.json', 'sk.json', 'sl.json', 'sr.json', 'sv.json', `
            'sw.json' , 'ta.json' , 'te.json' , 'th.json' , 'tr.json' , 'uk.json' , 'ur.json' , 'vi.json', `
            'zh-CN.json', 'zh-TW.json' , 'zu.json' , 'pa-PK.json' , 'hr.json'

        $stream = New-Object IO.FileStream($xpui_spa_patch, [IO.FileMode]::Open)
        $mode = [IO.Compression.ZipArchiveMode]::Update
        $zip_xpui = New-Object IO.Compression.ZipArchive($stream, $mode)

    ($zip_xpui.Entries | Where-Object { $files -contains $_.Name }) | ForEach-Object { $_.Delete() }

        $zip_xpui.Dispose()
        $stream.Close()
        $stream.Dispose()
    }

    Add-Type -Assembly 'System.IO.Compression.FileSystem'
    $zip = [System.IO.Compression.ZipFile]::Open($xpui_spa_patch, 'update')
    
    # xpui.js
    $entry_xpui = $zip.GetEntry('xpui.js')
    $reader = New-Object System.IO.StreamReader($entry_xpui.Open())
    $xpui_js = $reader.ReadToEnd()
    $reader.Close()
    
    if (!($premium)) {
        # Full screen mode activation and removing "Upgrade to premium" menu, upgrade button, disabling a playlist sponsor
        $xpui_js = Helper -paramname "OffadsonFullscreen"
    }

    # Experimental Feature
    if (!($exp_spotify)) { $xpui_js = Helper -paramname "ExpFeature" }

    # Remove all languages except En and Ru from xpui.js
    if ($ru) { $xpui_js = Helper -paramname "OffRujs" }

    # Disabled logging
    $xpui_js = $xpui_js -replace "sp://logging/v3/\w+", ""
   
    $writer = New-Object System.IO.StreamWriter($entry_xpui.Open())
    $writer.BaseStream.SetLength(0)
    $writer.Write($xpui_js)
    $writer.Write([System.Environment]::NewLine + '// Patched by SpotX') 
    $writer.Close()


    # Turn off podcasts
    if ($podcast_off) { 
        $entry_home_v2 = $zip.GetEntry('home-v2.js')
        $reader = New-Object System.IO.StreamReader($entry_home_v2.Open())
        $xpui_homev2 = $reader.ReadToEnd()
        $reader.Close()
        $xpui_homev2 = Helper -paramname "OffPodcasts" 
        $writer = New-Object System.IO.StreamWriter($entry_home_v2.Open())
        $writer.BaseStream.SetLength(0)
        $writer.Write($xpui_homev2)
        $writer.Close()
    }

    # Add discriptions (xpui-desktop-modals.js)
    $entry_xpui_desktop_modals = $zip.GetEntry('xpui-desktop-modals.js')
    $reader = New-Object System.IO.StreamReader($entry_xpui_desktop_modals.Open())
    $xpui_desktop_modals = $reader.ReadToEnd()
    $reader.Close()
    $xpui_desktop_modals = Helper -paramname "Discriptions"
    $writer = New-Object System.IO.StreamWriter($entry_xpui_desktop_modals.Open())
    $writer.BaseStream.SetLength(0)
    $writer.Write($xpui_desktop_modals)
    $writer.Close()

    # Disable Sentry (vendor~xpui.js)
    $entry_vendor_xpui = $zip.GetEntry('vendor~xpui.js')
    $reader = New-Object System.IO.StreamReader($entry_vendor_xpui.Open())
    $xpuiContents_vendor = $reader.ReadToEnd()
    $reader.Close()

    $xpuiContents_vendor = $xpuiContents_vendor `
        -replace "(?:prototype\.)?bindClient(?:=function)?\(\w+\)\{", '${0}return;'
    $writer = New-Object System.IO.StreamWriter($entry_vendor_xpui.Open())
    $writer.BaseStream.SetLength(0)
    $writer.Write($xpuiContents_vendor)
    $writer.Close()

    # minification of all *.js
    $zip.Entries | Where-Object FullName -like '*.js' | ForEach-Object {
        $readerjs = New-Object System.IO.StreamReader($_.Open())
        $xpuiContents_js = $readerjs.ReadToEnd()
        $readerjs.Close()

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
        $writer.Write([System.Environment]::NewLine + ' .BKsbV2Xl786X9a09XROH {display:none}')
        # Hide submenu item "download"
        $writer.Write([System.Environment]::NewLine + ' button.wC9sIed7pfp47wZbmU6m.pzkhLqffqF_4hucrVVQA {display:none}')
        # Hide very high quality streaming
        $writer.Write([System.Environment]::NewLine + ' #desktop\.settings\.streamingQuality>option:nth-child(5) {display:none}')
    }
     
    # new UI fix
    if (!($navalt_off)) {
        $writer.Write([System.Environment]::NewLine + ' .nav-alt .Root__top-container {background: #00000085;gap: 6px;padding: 8px;}')
        $writer.Write([System.Environment]::NewLine + ' .Root__fixed-top-bar {background-color: #00000000}')
    }
    # Hide Collaborators icon
    if (!($hide_col_icon_off) -and !($exp_spotify)) {
        $writer.Write([System.Environment]::NewLine + ' .X1lXSiVj0pzhQCUo_72A{display:none}')
    }
    $writer.Close()

    # of all *.Css
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
        $xpuiContents_html = Helper -paramname "HtmlLicMin"
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
    if ($xpuiContents_html_blank -match $html_min1) { $xpuiContents_html_blank = $xpuiContents_html_blank -replace $html_min1, "" } else { Write-Host ($lang).NoVariable"" -ForegroundColor red -NoNewline; Write-Host "`$html_min1 "($lang).NoVariable4 }
    if ($xpuiContents_html_blank -match $html_min2) { $xpuiContents_html_blank = $xpuiContents_html_blank -replace $html_min2, "" } else { Write-Host ($lang).NoVariable"" -ForegroundColor red -NoNewline; Write-Host "`$html_min2 "($lang).NoVariable4 }
    if ($xpuiContents_html_blank -match $html_min3) { $xpuiContents_html_blank = $xpuiContents_html_blank -replace $html_min3, "" } else { Write-Host ($lang).NoVariable"" -ForegroundColor red -NoNewline; Write-Host "`$html_min3 "($lang).NoVariable4 }

    $xpuiContents_html_blank = $xpuiContents_html_blank
    $writer = New-Object System.IO.StreamWriter($entry_blank_html.Open())
    $writer.BaseStream.SetLength(0)
    $writer.Write($xpuiContents_html_blank)
    $writer.Close()
    
    if ($ru) {
        # Additional translation of the ru.json file
        $zip.Entries | Where-Object FullName -like '*ru.json' | ForEach-Object {
            $readerjson = New-Object System.IO.StreamReader($_.Open())
            $xpui_ru = $readerjson.ReadToEnd()
            $readerjson.Close()

    
            $xpui_ru = Helper -paramname "RuTranslate"
            $writer = New-Object System.IO.StreamWriter($_.Open())
            $writer.BaseStream.SetLength(0)
            $writer.Write($xpui_ru)
            $writer.Close()
        }
    }
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

# Delete all files except "en" and "ru"
if ($ru) {
    $patch_lang = "$spotifyDirectory\locales"
    Remove-Item $patch_lang -Exclude *en*, *ru* -Recurse
}

# create a desktop shortcut
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

# create shortcut in start menu
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


    # create a desktop shortcut
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
    # create shortcut in start menu
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
