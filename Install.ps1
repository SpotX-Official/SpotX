param
(

    [Parameter(HelpMessage = "Change recommended version of Spotify.")]
    [Alias("v")]
    [string]$version,

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
    
    [Parameter(HelpMessage = 'Change limit for clearing audio cache.')]
    [Alias('cl')]
    [int]$cache_limit,
    
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
    
    [Parameter(HelpMessage = 'disable new right sidebar.')]
    [switch]$rightsidebar_off,

    [Parameter(HelpMessage = 'Do not enable enhance playlist.')]
    [switch]$enhance_playlist_off,
    
    [Parameter(HelpMessage = 'Do not enable enhance liked songs.')]
    [switch]$enhance_like_off,

    [Parameter(HelpMessage = 'Disable smart shuffle in playlists.')]
    [switch]$smartShuffle_off,

    [Parameter(HelpMessage = 'enable funny progress bar.')]
    [switch]$funnyprogressBar,

    [Parameter(HelpMessage = 'New theme activated (new right and left sidebar, some cover change)')]
    [switch]$new_theme,

    [Parameter(HelpMessage = 'enable right sidebar coloring to match cover color)')]
    [switch]$rightsidebarcolor,
    
    [Parameter(HelpMessage = 'Returns old lyrics')]
    [switch]$old_lyrics,
    
    [Parameter(HelpMessage = 'Do not create desktop shortcut.')]
    [switch]$no_shortcut,

    [Parameter(HelpMessage = 'Static color for lyrics.')]
    [ArgumentCompleter({ param($cmd, $param, $wordToComplete)
            [array] $validValues = @('default', 'red', 'orange', 'yellow', 'spotify', 'blue', 'purple', 'strawberry', 'pumpkin', 'sandbar', 'radium', 'oceano', 'royal', 'github', 'discord', 'drot', 'forest', 'fresh', 'zing', 'pinkle', 'krux', 'blueberry', 'postlight', 'relish', 'turquoise')
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
        '^fi$' {
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
        $returnCode = $returnCode -split "-" | Select-Object -First 1
    }
    # Checking the short language code
    if ($returnCode -NotIn $supportLanguages) {
        # If the language code is not supported default to English.
        $returnCode = 'en'
    }
    return $returnCode 
}

$spotifyDirectory = Join-Path $env:APPDATA 'Spotify'
$spotifyDirectory2 = Join-Path $env:LOCALAPPDATA 'Spotify'
$spotifyExecutable = Join-Path $spotifyDirectory 'Spotify.exe'
$exe_bak = Join-Path $spotifyDirectory 'Spotify.bak'
$spotifyUninstall = Join-Path $env:TEMP 'SpotifyUninstall.exe'
$start_menu = Join-Path $env:APPDATA 'Microsoft\Windows\Start Menu\Programs\Spotify.lnk'

$upgrade_client = $false

# Check version Powershell
$psv = $PSVersionTable.PSVersion.major
if ($psv -ge 7) {
    Import-Module Appx -UseWindowsPowerShell -WarningAction:SilentlyContinue
}

# add Tls12
[Net.ServicePointManager]::SecurityProtocol = 3072


function CallLang($clg) {

    $urlLang = "https://amd64fox.github.io/SpotX/scripts/installer-lang/$clg.ps1"
    $ProgressPreference = 'SilentlyContinue'
    
    try {
        $response = (iwr -Uri $urlLang -UseBasicParsing).Content
        $scriptContent = [System.Text.Encoding]::UTF8.GetString($response)
        Invoke-Expression $scriptContent
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
    $urlru = "https://amd64fox.github.io/SpotX/patches/Augmented%20translation/ru.json"
    $webjsonru = (Invoke-WebRequest -useb -Uri $urlru).Content | ConvertFrom-Json
}

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

$match_v = "^\d+\.\d+\.\d+\.\d+\.g[0-9a-f]{8}-\d+$"
if ($version) {
    if ($version -match $match_v) {
        $onlineFull = $version
    }
    else {      
        Write-Warning "Invalid $($version) format. Example: 1.2.13.661.ga588f749-4064"
        Write-Host
    }
}

$old_os = $win7 -or $win8 -or $win8_1

# Recommended version for Win 7-8.1
$last_win7_full = "1.2.5.1006.g22820f93-1078"

if (!($version -and $version -match $match_v)) {
    if ($old_os) { 
        $onlineFull = $last_win7_full
    }
    else {  
        # Recommended version for Win 10-12
        $onlineFull = "1.2.20.1214.g009959bd-963" 
    }
}
else {
    if ($old_os) {
        $last_win7 = "1.2.5.1006"
        if ([version]($onlineFull -split ".g")[0] -gt [version]$last_win7) { 

            Write-Warning ("Version {0} is only supported on Windows 10 and above" -f ($onlineFull -split ".g")[0])   
            Write-Warning ("The recommended version has been automatically changed to {0}, the latest supported version for Windows 7-8.1" -f $last_win7)
            Write-Host
            $onlineFull = $last_win7_full
        }
    }
}
$online = ($onlineFull -split ".g")[0]

# Sending a statistical web query to cutt.ly
$ErrorActionPreference = 'SilentlyContinue'
$cutt_url = "https://cutt.ly/rwl6sXuQ"
$retries = 0

while ($retries -lt 2) {
    try {
        $null = Invoke-WebRequest -useb -Uri $cutt_url 
        break
    }
    catch {
        $retries++
        Start-Sleep -Seconds 2
    }
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

function downloadSp() {

    $webClient = New-Object -TypeName System.Net.WebClient

    Import-Module BitsTransfer
        
    $web_Url = "https://download.scdn.co/upgrade/client/win32-x86/spotify_installer-$onlineFull.exe"
    $local_Url = "$PWD\SpotifySetup.exe" 
    $web_name_file = "SpotifySetup.exe"

    try { if (curl.exe -V) { $curl_check = $true } }
    catch { $curl_check = $false }
    
    try { 
        if ($curl_check) {
            $stcode = curl.exe -s -w "%{http_code}" -o /dev/null $web_Url --retry 2 --ssl-no-revoke
            if ($stcode -ne "200") {
                Write-Host "Curl error code: $stcode"; throw
            }
            curl.exe -q $web_Url -o $local_Url --progress-bar --retry 3 --ssl-no-revoke
            return
        }
        if (!($curl_check ) -and $null -ne (Get-Module -Name BitsTransfer -ListAvailable)) {
            $ProgressPreference = 'Continue'
            Start-BitsTransfer -Source  $web_Url -Destination $local_Url  -DisplayName ($lang).Download5 -Description "$online "
            return
        }
        if (!($curl_check ) -and $null -eq (Get-Module -Name BitsTransfer -ListAvailable)) {
            $webClient.DownloadFile($web_Url, $local_Url) 
            return
        }
    }

    catch {
        Write-Host
        Write-Host ($lang).Download $web_name_file -ForegroundColor RED
        $Error[0].Exception
        Write-Host
        Write-Host ($lang).Download2`n
        Start-Sleep -Milliseconds 5000 
        try { 

            if ($curl_check) {
                $stcode = curl.exe -s -w "%{http_code}" -o /dev/null $web_Url --retry 2 --ssl-no-revoke
                if ($stcode -ne "200") {
                    Write-Host "Curl error code: $stcode"; throw
                }
                curl.exe -q $web_Url -o $local_Url --progress-bar --retry 3 --ssl-no-revoke
                return
            }
            if (!($curl_check ) -and $null -ne (Get-Module -Name BitsTransfer -ListAvailable) -and !($curl_check )) {
                Start-BitsTransfer -Source  $web_Url -Destination $local_Url  -DisplayName ($lang).Download5 -Description "$online "
                return
            }
            if (!($curl_check ) -and $null -eq (Get-Module -Name BitsTransfer -ListAvailable) -and !($curl_check )) {
                $webClient.DownloadFile($web_Url, $local_Url) 
                return
            }
        }
        
        catch {
            Write-Host ($lang).Download3 -ForegroundColor RED
            $Error[0].Exception
            Write-Host
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
                Write-Host
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
$hostsFilePath = Join-Path $Env:windir 'System32\Drivers\Etc\hosts'
$hostsBackupFilePath = Join-Path $Env:windir 'System32\Drivers\Etc\hosts.bak'

if (Test-Path -Path $hostsFilePath) {
    $hosts = Get-Content -Path $hostsFilePath

    if ($hosts -match '^[^\#|].+scdn.+|^[^\#|].+spotify.+') {
        Write-Host ($lang).HostInfo
        Write-Host ($lang).HostBak

        Copy-Item -Path $hostsFilePath -Destination $hostsBackupFilePath -ErrorAction SilentlyContinue

        if ($?) {
            Write-Host ($lang).HostDel
            try {
                $hosts = $hosts -replace '^[^\#|].+scdn.+|^[^\#|].+spotify.+', ''
                $hosts = $hosts | Where-Object { $_.trim() -ne "" }
                Set-Content -Path $hostsFilePath -Value $hosts -Force
            }
            catch {
                Write-Host ($lang).HostError -ForegroundColor Red
                $copyError = $Error[0]
                Write-Host "Error: $($copyError.Exception.Message)" -ForegroundColor Red
            }
        }
        else {
            Write-Host ($lang).HostError`n -ForegroundColor Red
            $copyError = $Error[0]
            Write-Host "Error: $($copyError.Exception.Message)`n" -ForegroundColor Red
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

    # Old version Spotify
    if ($oldversion) {
        if ($confirm_spoti_recomended_over -or $confirm_spoti_recomended_unistall) {
            Write-Host ($lang).OldV`n
        }
        if (!($confirm_spoti_recomended_over) -and !($confirm_spoti_recomended_unistall)) {
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
        if ($confirm_spoti_recomended_over -or $confirm_spoti_recomended_unistall) { 
            $ch = 'y' 
            Write-Host ($lang).AutoUpd`n
        }
        if ($ch -eq 'y') { 
            $upgrade_client = $true 

            if (!($confirm_spoti_recomended_over) -and !($confirm_spoti_recomended_unistall)) {
                do {
                    $ch = Read-Host -Prompt (($lang).DelOrOver -f $offline)
                    Write-Host
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
                $null = Unlock-Folder 
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
            
            # Country check
            $country = [System.Globalization.RegionInfo]::CurrentRegion.EnglishName

            $txt = [IO.File]::ReadAllText($spotifyExecutable)
            $regex = "(\d+)\.(\d+)\.(\d+)\.(\d+)(\.g[0-9a-f]{8})"
            $v = $txt | Select-String $regex -AllMatches
            $ver = $v.Matches.Value[0]
            if ($ver.Count -gt 1) { $ver = $ver[0] }

            $Parameters = @{
                Uri    = 'https://docs.google.com/forms/d/e/1FAIpQLSegGsAgilgQ8Y36uw-N7zFF6Lh40cXNfyl1ecHPpZcpD8kdHg/formResponse'
                Method = 'POST'
                Body   = @{
                    'entry.620327948'  = $ver
                    'entry.1951747592' = $country
                    'entry.1402903593' = $win_os
                    'entry.860691305'  = $psv
                    'entry.2067427976' = $online + " < " + $offline
                }   
            }
            $null = Invoke-WebRequest -useb @Parameters 
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
                Write-Host
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
                    Write-Host
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
                        Write-Host
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
                    $null = Unlock-Folder
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
    $null = Unlock-Folder 
    Start-Sleep -Milliseconds 200
    Get-ChildItem $spotifyDirectory -Exclude 'Users', 'prefs' | Remove-Item -Recurse -Force 
    Start-Sleep -Milliseconds 200

    # Client download
    downloadSp
    Write-Host

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
if ($ch -eq 'y') { $block_update = $true }

if (!($new_theme) -and [version]$offline -ge [version]"1.2.14.1141") {
    Write-Warning "This version does not support the old theme, use version 1.2.13.661 or below"
    Write-Host
}

if ($ch -eq 'n') {
    $ErrorActionPreference = 'SilentlyContinue'
    if ((Test-Path -LiteralPath $exe_bak) -and $offline -eq $offline_bak) {
        Remove-Item $spotifyExecutable -Recurse -Force
        Rename-Item $exe_bak $spotifyExecutable
    }
}

$ch = $null

$url = "https://amd64fox.github.io/SpotX/patches/patches.json"
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
        "Lyrics-color" { 
            $pasttext = $webjson.others.themelyrics.theme.$lyrics_stat.pasttext
            $current = $webjson.others.themelyrics.theme.$lyrics_stat.current
            $next = $webjson.others.themelyrics.theme.$lyrics_stat.next
            $background = $webjson.others.themelyrics.theme.$lyrics_stat.background
            $hover = $webjson.others.themelyrics.theme.$lyrics_stat.hover
            $maxmatch = $webjson.others.themelyrics.theme.$lyrics_stat.maxmatch

            if ([version]$offline -lt [version]"1.1.99.871") { $lyrics = "lyricscolor1"; $contents = $lyrics }
            if ([version]$offline -ge [version]"1.1.99.871") { $lyrics = "lyricscolor2"; $contents = $lyrics }

            # xpui.js or xpui-routes-lyrics.js
            if ([version]$offline -ge [version]"1.1.99.871") {

                $full_previous = Mod-F -template $webjson.others.$lyrics.add[0] -arguments $pasttext 
                $full_current = Mod-F -template $webjson.others.$lyrics.add[1] -arguments $current
                $full_next = Mod-F -template $webjson.others.$lyrics.add[2] -arguments $next
                $full_lyrics = Mod-F -template $webjson.others.$lyrics.add[3] -arguments $full_previous, $full_current, $full_next
                $webjson.others.$lyrics.add[3] = $full_lyrics
                $webjson.others.$lyrics.replace[1] = '$1' + '"' + $pasttext + '"'  
                $webjson.others.$lyrics.replace[2] = '$1' + '"' + $current + '"'  
                $webjson.others.$lyrics.replace[3] = '$1' + '"' + $next + '"'  
                $webjson.others.$lyrics.replace[4] = '$1' + '"' + $background + '"'
                $webjson.others.$lyrics.replace[5] = '$1' + '"' + $hover + '"'   
                $webjson.others.$lyrics.replace[6] = '$1' + '"' + $maxmatch + '"'
                if ([version]$offline -ge [version]"1.2.6.861") {
                    $webjson.others.$lyrics.replace[7] = '$1' + '"' + $maxmatch + '"' + '$3'
                }
                else {
                    $webjson.others.$lyrics.match = $webjson.others.$lyrics.match | Where-Object { $_ -ne $webjson.others.$lyrics.match[7] }
                }
                if ([version]$offline -ge [version]"1.2.3.1107") {
                    $webjson.others.$lyrics.replace[8] = $webjson.others.$lyrics.replace[8] -f $background
                }
            }

            # xpui-routes-lyrics.css
            if ([version]$offline -lt [version]"1.1.99.871") {
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
            $remEnable = $webjson.others.EnableExp.psobject.properties  
            $remCustom = $webjson.others.CustomExp.psobject.properties

            if ($enhance_like_off) { $remEnable.remove('EnhanceLikedSongs') }
            if ($enhance_playlist_off) { $remEnable.remove('EnhancePlaylist') }
            # if ($smartShuffle_off) { $remEnable.remove('SmartShuffle') }
            $remEnable.remove('SmartShuffle')
            if (!($funnyprogressBar)) { $remEnable.remove('HeBringsNpb') }
            # Old theme
            if (!($new_theme) -and [version]$offline -le [version]"1.2.13.661") {
                $LeftSidebar = $webjson.others.EnableExp.LeftSidebar
                $RightSidebar = $webjson.others.EnableExp.RightSidebar
                $webjson.others.DisableExp | Add-Member -MemberType NoteProperty -Name "LeftSidebar" -Value $LeftSidebar
                $webjson.others.DisableExp | Add-Member -MemberType NoteProperty -Name "RightSidebar" -Value $RightSidebar

                $remCustom.remove('NavAlt'), $remCustom.remove('NavAlt2'), $remEnable.remove('RightSidebarLyrics'), $remEnable.remove('RightSidebarCredits'), 
                $remEnable.remove('RightSidebar'), $remEnable.remove('LeftSidebar'), $remEnable.remove('RightSidebarColors');
            }
            # New theme
            else {
                if ($rightsidebar_off) { 
                    $RightSidebar = $webjson.others.EnableExp.RightSidebar
                    $webjson.others.DisableExp | Add-Member -MemberType NoteProperty -Name "RightSidebar" -Value $RightSidebar
                }
                else {
                    if (!($rightsidebarcolor)) { $remEnable.remove('RightSidebarColors') }
                    if ($old_lyrics) { $remEnable.remove('RightSidebarLyrics') } 
                }
            }
            if (!$premium) { $remEnable.remove('RemoteDownloads') }

            # Disable unimportant exp
            if ($exp_spotify) {
                $objects = @(
                    @{
                        Object           = $webjson.others.CustomExp.psobject.properties
                        PropertiesToKeep = @('LyricsUpsell')
                    },
                    @{
                        Object           = $webjson.others.EnableExp.psobject.properties
                        PropertiesToKeep = @('CarouselsOnHome')
                    }
                )

                foreach ($obj in $objects) {
                    $propertiesToRemove = $obj.Object.Name | Where-Object { $_ -notin $obj.PropertiesToKeep }
                    $propertiesToRemove | foreach {
                        $obj.Object.Remove($_)
                    }
                }

            }

            $Exp = ($webjson.others.EnableExp, $webjson.others.DisableExp, $webjson.others.CustomExp)

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

            $enableExp = $webjson.others.EnableExp
            $disableExp = $webjson.others.DisableExp
            $CustomExp = $webjson.others.CustomExp

            $enableNames = foreach ($item in $enableExp.PSObject.Properties.Name) {
                $webjson.others.EnableExp.$item.name
            }

            $disableNames = foreach ($item in $disableExp.PSObject.Properties.Name) {
                $webjson.others.DisableExp.$item.name
            }

            $customNames = foreach ($item in $CustomExp.PSObject.Properties.Name) {
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
                @("EnableExp=[]", "EnableExp=$enableTextVariable"),
                @("DisableExp=[]", "DisableExp=$disableTextVariable"),
                @("CustomExp=[]", "CustomExp=$customTextVariable")
            )

            foreach ($replacement in $replacements) {
                $webjson.others.ForcedExp.replace = $webjson.others.ForcedExp.replace.Replace($replacement[0], $replacement[1])
            }

            $name = "patches.json.others."
            $n = "xpui.js"
            $contents = "ForcedExp"
            $json = $webjson.others
        }
        "OffPodcasts" {  
            # Turn off podcasts
            if ([version]$offline -le [version]"1.1.92.647") { $contents = "podcastsoff" }
            if ([version]$offline -ge [version]"1.1.93.896") { $contents = "podcastsoff2" }
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
        "VariousofXpui-js" { 

            $rem = $webjson.VariousJs.psobject.properties  

            if ($urlform_goofy -and $idbox_goofy) {
                $webjson.VariousJs.goofyhistory.replace = "`$1 const urlForm=" + '"' + $urlform_goofy + '"' + ";const idBox=" + '"' + $idbox_goofy + '"' + $webjson.VariousJs.goofyhistory.replace
            }
            else { $rem.remove('goofyhistory') }
            
            if (!($ru)) { $rem.remove('offrujs') }

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
            else { $rem.remove('product_state') }

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
                $xpui_spa_patch = Join-Path (Join-Path $env:APPDATA 'Spotify\Apps') 'xpui.spa'
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
            if ($add) { $add | foreach { $writer.Write([System.Environment]::NewLine + $PSItem ) } }
            $writer.Close()  
            if ($method -eq "zip") { $zip.Dispose() }
        }
        "more" {  
            Add-Type -Assembly 'System.IO.Compression.FileSystem'
            $xpui_spa_patch = Join-Path (Join-Path $env:APPDATA 'Spotify\Apps') 'xpui.spa'
            $zip = [System.IO.Compression.ZipFile]::Open($xpui_spa_patch, 'update') 
            $zip.Entries | Where-Object FullName -like $name | foreach {
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

$xpui_spa_patch = Join-Path (Join-Path $env:APPDATA 'Spotify\Apps') 'xpui.spa'
$xpui_js_patch = Join-Path (Join-Path (Join-Path $env:APPDATA 'Spotify\Apps') 'xpui') 'xpui.js'
$test_spa = Test-Path -Path $xpui_spa_patch
$test_js = Test-Path -Path $xpui_js_patch
$spotify_exe_bak_patch = Join-Path $env:APPDATA 'Spotify\Spotify.bak'


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
        Write-Host
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

    $bak_spa = Join-Path (Join-Path $env:APPDATA 'Spotify\Apps') 'xpui.bak'
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

            $spotify_exe_bak_patch = Join-Path $env:APPDATA 'Spotify\Spotify.bak'
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
        $spotify_exe_bak_patch = Join-Path $env:APPDATA 'Spotify\Spotify.bak'
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

    # Forced disable some exp
    extract -counts 'one' -method 'zip' -name 'xpui.js' -helper 'ForcedExp' -add $webjson.others.byspotx.add
    
    # Experimental Feature
    extract -counts 'one' -method 'zip' -name 'xpui.js' -helper 'VariousofXpui-js' 

    # Turn off podcasts
    if ($podcast_off) { 
        if ([version]$offline -ge [version]"1.1.93.896" -and [version]$offline -le [version]"1.1.97.962") { $js = 'home-v2.js' }
        if ([version]$offline -le [version]"1.1.92.647" -or [version]$offline -ge [version]"1.1.98.683") { $js = 'xpui.js' }
        extract -counts 'one' -method 'zip' -name $js -helper 'OffPodcasts'
    }

    # Hiding Ad-like sections from the homepage
    if ($adsections_off) { 
        if ([version]$offline -ge [version]"1.1.93.896" -and [version]$offline -le [version]"1.1.97.962") { $js = 'home-v2.js' }
        if ([version]$offline -ge [version]"1.1.98.683") { $js = 'xpui.js' }
        extract -counts 'one' -method 'zip' -name $js -helper 'OffAdSections'
    }

    # Hide Collaborators icon
    if (!($hide_col_icon_off) -and !($exp_spotify)) {
        extract -counts 'one' -method 'zip' -name 'xpui-routes-playlist.js' -helper 'Collaborators'
    }


    # Static color for lyrics
    if ($lyrics_stat) {
        # old
        if ([version]$offline -lt [version]"1.1.99.871") { 
            $name_file = 'xpui-routes-lyrics.css'
            extract -counts 'one' -method 'zip' -name $name_file -helper 'Lyrics-color'
        }
        # new 
        if ([version]$offline -ge [version]"1.1.99.871") {
            $contents = "fixcsslyricscolor2"
            extract -counts 'one' -method 'zip' -name 'xpui.css' -helper 'FixCss'
            if ([version]$offline -le [version]"1.2.2.582") {
                $name_file = 'xpui-routes-lyrics.js'   
                extract -counts 'one' -method 'zip' -name $name_file -helper 'Lyrics-color'
            }
        }
        # mini lyrics
        if ([version]$offline -ge [version]"1.2.0.1155") {
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
    if (!($premium)) {
        # Hide download icon on different pages
        $css += $webjson.others.downloadicon.add
        # Hide submenu item "download"
        $css += $webjson.others.submenudownload.add
        # Hide very high quality streaming
        $css += $webjson.others.veryhighstream.add
    }
    # Full screen lyrics
    if ($lyrics_stat -and [version]$offline -ge [version]"1.2.3.1107") {
        $css += $webjson.others.lyricscolor2.add[3]
    }
    if ($null -ne $css ) { extract -counts 'one' -method 'zip' -name 'xpui.css' -add $css }
    
    
    # Old UI fix
    $contents = "fix-old-theme"
    extract -counts 'one' -method 'zip' -name 'xpui.css' -helper "FixCss"

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
        $source = Join-Path $env:APPDATA 'Spotify\Spotify.exe'
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
    $source = Join-Path $env:APPDATA 'Spotify\Spotify.exe'
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

# Start Spotify
if ($start_spoti) { Start-Process -WorkingDirectory $spotifyDirectory -FilePath $spotifyExecutable }

Write-Host ($lang).InstallComplete`n -ForegroundColor Green