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

    [Parameter(HelpMessage = 'Enabled the big cards for home page')]
    [switch]$canvasHome,

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
        'bn', 'cs', 'de', 'el', 'en', 'es', 'fa', 'fi', 'fil', 'fr', 'hi', 'hu', 
        'id', 'it', 'ja', 'ka', 'ko', 'lv', 'pl', 'pt', 'ro', 'ru', 'sk', 'sr', 
        'sv', 'ta', 'tr', 'ua', 'vi', 'zh', 'zh-TW'
    )
    
    # Trim the language code down to two letter code.
    switch -Regex ($LanguageCode) {
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
        '^sr' {
            $returnCode = 'sr'
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
        $onlineFull = "1.2.59.517.g16b54919-166" 
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

function downloadSp() {

    $webClient = New-Object -TypeName System.Net.WebClient

    Import-Module BitsTransfer
        
    $max_x86 = [Version]"1.2.53"
    $versionParts = $onlineFull -split '\.'
    $short = [Version]"$($versionParts[0]).$($versionParts[1]).$($versionParts[2])"
    $arch = if ($short -le $max_x86) { "win32-x86" } else { "win32-x86_64" }

    $web_Url = "https://download.scdn.co/upgrade/client/$arch/spotify_installer-$onlineFull.exe"
    $local_Url = "$PWD\SpotifySetup.exe" 
    $web_name_file = "SpotifySetup.exe"

    try { if (curl.exe -V) { $curl_check = $true } }
    catch { $curl_check = $false }
    
    try { 
        if ($curl_check) {
            $stcode = curl.exe -Is -w "%{http_code} \n" -o /dev/null -k $web_Url --retry 2 --ssl-no-revoke
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
                $stcode = curl.exe -Is -w "%{http_code} \n" -o /dev/null -k $web_Url --retry 2 --ssl-no-revoke
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

# Unique directory name based on time
Push-Location -LiteralPath ([System.IO.Path]::GetTempPath())
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
    
    # Unsupported version Spotify
    if ($testversion) {
        # Submit unsupported version of Spotify to google form for further processing
        try { 
            
            # Country check
            $country = [System.Globalization.RegionInfo]::CurrentRegion.EnglishName

            $txt = [IO.File]::ReadAllText($spotifyExecutable)
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
            $null = Invoke-WebRequest -useb @Parameters 
        }
        catch {
            Write-Host 'Unable to submit new version of Spotify' 
            Write-Host "error description: "$Error[0]
            Write-Host
        }

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
    Kill-Spotify
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
    Write-Host ($lang).StopScript
    $tempDirectory = $PWD
    Pop-Location
    Start-Sleep -Milliseconds 200
    Remove-Item -Recurse -LiteralPath $tempDirectory 
    Pause
    Exit

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

            # disable new scrollbar
            Move-Json -n 'NewOverlayScrollbars' -t $Enable -f $Disable

            # temporarily disable collapsing right sidebar
            Move-Json -n 'PeekNpv' -t $Enable -f $Disable

            # notifications are temporarily disabled
            Move-Json -n 'NotificationCenter' -t $Enable -f $Disable

            # ability to toggle the visibility of the playlist column is temporarily disabled because it does not save its state
            Move-Json -n 'TogglePlaylistColumns' -t $Enable -f $Disable
 
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

            if (!($canvasHome)) { Move-Json -n "canvasHome", "canvasHomeAudioPreviews" -t $Enable -f $Disable }

            if (!$newFullscreenMode) { Move-Json -n "ImprovedCinemaMode", "ImprovedCinemaModeCanvas" -t $Enable -f $Disable }
            
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
                    if ($old_lyrics) { Remove-Json -j $Enable -p 'RightSidebarLyrics' } 
                }
            }
            if (!$premium) { Remove-Json -j $Enable -p 'RemoteDownloads' }

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

            
            if ($podcast_off -or $adsections_off) {
                $type = switch ($true) {
                    { $podcast_off -and $adsections_off } { "all" }
                    { $podcast_off -and -not $adsections_off } { "podcast" }
                    { -not $podcast_off -and $adsections_off } { "section" }
                }
                $webjson.VariousJs.block_section.replace = $webjson.VariousJs.block_section.replace -f $type
                $global:type = $type
            }
            else {
                Remove-Json -j $VarJs -p 'block_section'
            }

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
            $xpui = [IO.File]::ReadAllText($spotifyExecutable, $ANSI)
            $xpui = Helper -paramname $helper
            [IO.File]::WriteAllText($spotifyExecutable, $xpui, $ANSI)
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

    # Forced exp
    extract -counts 'one' -method 'zip' -name 'xpui.js' -helper 'ForcedExp' -add $webjson.others.byspotx.add

    # Hiding Ad-like sections or turn off podcasts from the homepage
    if ($podcast_off -or $adsections_off) {

        $section = Get -Url (Get-Link -e "/js-helper/sectionBlock.js")
        
        if ($section -ne $null) {

            injection -p $xpui_spa_patch -f "spotx-helper" -n "sectionBlock.js" -c $section
        }
        else {
            $podcast_off, $adsections_off = $false
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
    if ($global:type -eq "all" -or $global:type -eq "podcast") {
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

$regex1 = $old -notmatch $webjson.others.binary.block_update.add
$regex2 = $old -notmatch $webjson.others.binary.block_slots.add
$regex3 = $old -notmatch $webjson.others.binary.block_slots_2.add
$regex4 = $old -notmatch $webjson.others.binary.block_slots_3.add
$regex5 = $old -notmatch $webjson.others.binary.block_gabo.add

if ($regex1 -and $regex2 -and $regex3 -and $regex4 -and $regex5) {

    if (Test-Path -LiteralPath $exe_bak) { 
        Remove-Item $exe_bak -Recurse -Force
        Start-Sleep -Milliseconds 150
    }
    copy-Item $spotifyExecutable $exe_bak
}

# Binary patch
extract -counts 'exe' -helper 'Binary'

# fix login for old versions
if ([version]$offline -ge [version]"1.1.87.612" -and [version]$offline -le [version]"1.2.5.1006") {
    $login_spa = Join-Path (Join-Path $env:APPDATA 'Spotify\Apps') 'login.spa'
    Get -Url (Get-Link -e "/res/login.spa") -OutputPath $login_spa
}

# Disable Startup client
if ($DisableStartup) {
    $prefsPath = "$env:APPDATA\Spotify\prefs"
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
