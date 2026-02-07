[CmdletBinding()]
param
(

    [Parameter(HelpMessage = "Change recommended version of Spotify.")]
    [Alias("v")]
    [string]$version,

    [Parameter(HelpMessage = 'Custom path to Spotify installation directory. Default is %APPDATA%\Spotify.')]
    [string]$SpotifyPath,

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
    [string]$language
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
        'sv', 'ta', 'tr', 'ua', 'vi', 'zh', 'zh-TW'
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
        '^ua' {
            $returnCode = 'ua'
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

$spotifyDirectory = Join-Path $env:APPDATA 'Spotify'
$spotifyDirectory2 = Join-Path $env:LOCALAPPDATA 'Spotify'

# Использовать кастомный путь если указан параметр -SpotifyPath
if ($SpotifyPath) {
    $spotifyDirectory = $SpotifyPath
}
$spotifyExecutable = Join-Path $spotifyDirectory 'Spotify.exe'
$spotifyDll = Join-Path $spotifyDirectory 'Spotify.dll' 
$chrome_elf = Join-Path $spotifyDirectory 'chrome_elf.dll'
$exe_bak = Join-Path $spotifyDirectory 'Spotify.bak'
$dll_bak = Join-Path $spotifyDirectory 'Spotify.dll.bak'
$chrome_elf_bak = Join-Path $spotifyDirectory 'chrome_elf.dll.bak'
$spotifyUninstall = Join-Path ([System.IO.Path]::GetTempPath()) 'SpotifyUninstall.exe'
$start_menu = Join-Path $env:APPDATA 'Microsoft\Windows\Start Menu\Programs\Spotify.lnk'

$upgrade_client = $false

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
    Exit
}
function Get-Link {
    param (
        [Alias("e")]
        [string]$endlink
    )

    switch ($mirror) {
        $true { return "https://spotx-official.github.io/SpotX" + $endlink }
        default { return "https://raw.githubusercontent.com/SpotX-Official/SpotX/main" + $endlink }
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

# latest tested version for Win 7-8.1 
$last_win7_full = "1.2.5.1006.g22820f93-1078"

if (!($version -and $version -match $match_v)) {
    if ($old_os) { 
        $onlineFull = $last_win7_full
    }
    else {  
        # latest tested version for Win 10-12 
        $onlineFull = "1.2.82.428.g0ac8be2b-1220"
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

function downloadSp([string]$DownloadFolder) {

    $webClient = New-Object -TypeName System.Net.WebClient

    Import-Module BitsTransfer
        
    $max_x86 = [Version]"1.2.53"
    $versionParts = $onlineFull -split '\.'
    $short = [Version]"$($versionParts[0]).$($versionParts[1]).$($versionParts[2])"
    $arch = if ($short -le $max_x86) { "win32-x86" } else { "win32-x86_64" }

    $web_Url = "https://download.scdn.co/upgrade/client/$arch/spotify_installer-$onlineFull.exe"
    $local_Url = Join-Path $DownloadFolder 'SpotifySetup.exe'
    $web_name_file = "SpotifySetup.exe"

    try { if (curl.exe -V) { $curl_check = $true } }
    catch { $curl_check = $false }
    
    try { 
        if ($curl_check) {
            $stcode = curl.exe -Is -w "%{http_code} \n" -o NUL -k $web_Url --retry 2 --ssl-no-revoke
            if ($stcode.trim() -ne "200") {
                Write-Host "Curl error code: $stcode"; throw
            }
            curl.exe -q -k $web_Url -o $local_Url --progress-bar --retry 3 --ssl-no-revoke
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
                $stcode = curl.exe -Is -w "%{http_code} \n" -o NUL -k $web_Url --retry 2 --ssl-no-revoke
                if ($stcode.trim() -ne "200") {
                    Write-Host "Curl error code: $stcode"; throw
                }
                curl.exe -q -k $web_Url -o $local_Url --progress-bar --retry 3 --ssl-no-revoke
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

            if ($DownloadFolder -and (Test-Path $DownloadFolder)) {
                Start-Sleep -Milliseconds 200
                Remove-Item -Recurse -LiteralPath $DownloadFolder -ErrorAction SilentlyContinue
            }
            Stop-Script
        }
    }
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
            $ProgressPreference = 'SilentlyContinue' # Hiding Progress Bars
            if ($confirm_uninstall_ms_spoti) { Write-Host ($lang).MsSpoti3`n }
            if (!($confirm_uninstall_ms_spoti)) { Write-Host ($lang).MsSpoti4`n }
            Get-AppxPackage -Name SpotifyAB.SpotifyMusic | Remove-AppxPackage
        }
        if ($ch -eq 'n') {
            Stop-Script
        }
    }
}

# Attempt to fix the hosts file
$hostsFilePath = Join-Path $Env:windir 'System32\Drivers\Etc\hosts'
$hostsBackupFilePath = Join-Path $Env:windir 'System32\Drivers\Etc\hosts.bak'

if (Test-Path -Path $hostsFilePath) {

    $hosts = [System.IO.File]::ReadAllLines($hostsFilePath)
    $regex = "^(?!#|\|)((?:.*?(?:download|upgrade)\.scdn\.co|.*?spotify).*)"

    if ($hosts -match $regex) {

        Write-Host ($lang).HostInfo`n
        Write-Host ($lang).HostBak`n

        Copy-Item -Path $hostsFilePath -Destination $hostsBackupFilePath -ErrorAction SilentlyContinue

        if ($?) {

            Write-Host ($lang).HostDel

            try {
                $hosts = $hosts | Where-Object { $_ -notmatch $regex }
                [System.IO.File]::WriteAllLines($hostsFilePath, $hosts)
            }
            catch {
                Write-Host ($lang).HostError`n -ForegroundColor Red
                $copyError = $Error[0]
                Write-Host "Error: $($copyError.Exception.Message)`n" -ForegroundColor Red
            }
        }
        else {
            Write-Host ($lang).HostError`n -ForegroundColor Red
            $copyError = $Error[0]
            Write-Host "Error: $($copyError.Exception.Message)`n" -ForegroundColor Red
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
    
    # Unsupported version Spotify (skip if custom path is used)
    if ($testversion -and -not $SpotifyPath) {

        # Submit unsupported version of Spotify to google form for further processing

        $binary = if (Test-Path $spotifyDll) {
            $spotifyDll
        }
        else {
            $spotifyExecutable
        }

        Start-Job -ScriptBlock {
            param($binary, $win_os, $psv, $online, $offline)

            try { 
                $country = [System.Globalization.RegionInfo]::CurrentRegion.EnglishName
                $txt = [IO.File]::ReadAllText($binary)
                $regex = "(?<![\w\-])(\d+)\.(\d+)\.(\d+)\.(\d+)(\.g[0-9a-f]{8})(?![\w\-])"
                $matches = [regex]::Matches($txt, $regex)
                $ver = $matches[0].Value
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
                Invoke-WebRequest @Parameters -UseBasicParsing -ErrorAction SilentlyContinue | Out-Null
            }
            catch { }
        } -ArgumentList $binary, $win_os, $psv, $online, $offline | Out-Null

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

$webjson = Get -Url (Get-Link -e "/patches/patches.json") -RetrySeconds 5
        
if ($webjson -eq $null) { 
    Write-Host
    Write-Host "Failed to get patches.json" -ForegroundColor Red
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
        Stop-Script
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
            Stop-Script
        }

        Write-Verbose "Architecture: $ArchName"

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
        Stop-Script
    }

    function Get-RVA($FileOffset) {
        foreach ($sec in $Sections) {
            if ($FileOffset -ge $sec.RawPtr -and $FileOffset -lt ($sec.RawPtr + $sec.RawSize)) {
                return ($FileOffset - $sec.RawPtr) + $sec.VA
            }
        }
        return 0
    }

    Write-Verbose "Searching for function..."
    $StringBytes = [System.Text.Encoding]::ASCII.GetBytes($TargetStringText)
    $StringOffset = [ScannerCore]::FindBytes($bytes, $StringBytes)
    if ($StringOffset -eq -1) { 
        Write-Warning "String not found in Spotify.dll"
        Stop-Script
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
        Stop-Script
    }

    $BytesToWrite = if ($IsArm64) { $Patch_ARM64 } else { $Patch_x64 }

    $CurrentBytes = @(); for ($i = 0; $i -lt $BytesToWrite.Length; $i++) { $CurrentBytes += $bytes[$PatchOffset + $i] }
    $FoundHex = ($CurrentBytes | ForEach-Object { $_.ToString("X2") }) -join " "
    Write-Verbose "Found (Offset: 0x$($PatchOffset.ToString("X"))): $FoundHex"

    if ($CurrentBytes[0] -eq $BytesToWrite[0] -and $CurrentBytes[$BytesToWrite.Length - 1] -eq $BytesToWrite[$BytesToWrite.Length - 1]) {
        Write-Warning "File Spotify.dll already patched"
        return
    }

    Write-Verbose "Applying patch..."
    for ($i = 0; $i -lt $BytesToWrite.Length; $i++) { $bytes[$PatchOffset + $i] = $BytesToWrite[$i] }

    try {
        [System.IO.File]::WriteAllBytes($FilePath, $bytes)
        Write-Verbose "Success"
    }
    catch { 
        Write-Warning "Write error in Spotify.dll $($_.Exception.Message)" 
        Stop-Script
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
        Write-Warning "Error: $($_.Exception.Message)"
    }
    finally {
        if ($null -ne $archive_spa) {
            $archive_spa.Dispose()
        }
        if (-not $v8_snapshot -and $null -eq $xpuiJsEntry) {
            Write-Warning "v8_context_snapshot file not found, cannot create xpui.js"
            Stop-Script
        }
    }

    $bak_spa = Join-Path (Join-Path $spotifyDirectory 'Apps') 'xpui.bak'
    $test_bak_spa = Test-Path -Path $bak_spa

    # Make a backup copy of xpui.spa if it is original
    $zip = [System.IO.Compression.ZipFile]::Open($xpui_spa_patch, 'update')
    $entry = $zip.GetEntry('xpui.js')
    $reader = New-Object System.IO.StreamReader($entry.Open())
    $patched_by_spotx = $reader.ReadToEnd()
    $reader.Close()


    if ($offline -ge [version]'1.2.70.404') {
        
        $spotify_binary_bak = $dll_bak 
        $spotify_binary = $spotifyDll
    }
    else {
        $spotify_binary_bak = $exe_bak
        $spotify_binary = $spotifyExecutable
    }

    If ($patched_by_spotx -match 'patched by spotx') {
        $zip.Dispose()    

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
                    Pause
                    Exit
                }

                if (Test-Path -Path $chrome_elf_bak) {
                    Remove-Item $chrome_elf -Recurse -Force
                    Rename-Item $chrome_elf_bak $chrome_elf
                }
                else {
                    $binary_chrome_elf_bak = [System.IO.Path]::GetFileName($chrome_elf_bak)
                    Write-Warning ("Backup copy {0} not found. Please reinstall Spotify and run SpotX again" -f $binary_chrome_elf_bak)
                    Pause
                    Exit
                }

            }
        }
        else {
            Write-Host ($lang).NoRestore`n
            Pause
            Exit
        }

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
