# Ignore errors from `Stop-Process`
$PSDefaultParameterValues['Stop-Process:ErrorAction'] = [System.Management.Automation.ActionPreference]::SilentlyContinue


Write-Host "*****************"
Write-Host "Author: " -NoNewline
Write-Host "@Amd64fox" -ForegroundColor DarkYellow
Write-Host "*****************"`n

$spotifyDirectory = "$env:APPDATA\Spotify"
$spotifyExecutable = "$spotifyDirectory\Spotify.exe"
$chrome_elf = "$spotifyDirectory\chrome_elf.dll"
$chrome_elf_bak = "$spotifyDirectory\chrome_elf_bak.dll"
$upgrade_client = $false
$podcasts_off = $false
$spotx_new = $false
$block_update = $false
$cache_install = $false


# Check Tls12
$tsl_check = [Net.ServicePointManager]::SecurityProtocol 
if (!($tsl_check -match '^tls12$' )) {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
}

Stop-Process -Name Spotify
Stop-Process -Name SpotifyWebHelper

if ($PSVersionTable.PSVersion.Major -ge 7) {
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
        $ch = Read-Host -Prompt "Uninstall Spotify Windows Store edition (Y/N) "
        if ($ch -eq 'y') {
            $ProgressPreference = 'SilentlyContinue' # Hiding Progress Bars
            Write-Host 'Uninstalling Spotify.'`n
            Get-AppxPackage -Name SpotifyAB.SpotifyMusic | Remove-AppxPackage
        }
        else {
            Read-Host "Exiting..."
            exit
        }
    }
}

# Unique directory name based on time
Push-Location -LiteralPath $env:TEMP
New-Item -Type Directory -Name "BlockTheSpot-$(Get-Date -UFormat '%Y-%m-%d_%H-%M-%S')" | Convert-Path | Set-Location


Write-Host 'Downloading latest patch BTS...'`n

$webClient = New-Object -TypeName System.Net.WebClient
try {
    $webClient.DownloadFile(
        # Remote file URL
        "https://github.com/mrpond/BlockTheSpot/releases/latest/download/chrome_elf.zip",
        # Local file path
        "$PWD\chrome_elf.zip"
    )
}
catch [System.Management.Automation.MethodInvocationException] {
    Write-Host "Error downloading chrome_elf.zip" -ForegroundColor RED
    $Error[0].Exception
    Write-Host ""
    Write-Host "Will re-request in 5 seconds..."`n
    Start-Sleep -Milliseconds 5000 
    try {

        $webClient.DownloadFile(
            # Remote file URL
            "https://github.com/mrpond/BlockTheSpot/releases/latest/download/chrome_elf.zip",
            # Local file path
            "$PWD\chrome_elf.zip"
        )
    }
    catch [System.Management.Automation.MethodInvocationException] {
        Write-Host "Error again, script stopped" -ForegroundColor RED
        $Error[0].Exception
        Write-Host ""
        Write-Host "Try to check your internet connection and run the installation again."`n
        $tempDirectory = $PWD
        Pop-Location
        Start-Sleep -Milliseconds 200
        Remove-Item -Recurse -LiteralPath $tempDirectory 
        exit
    }
}

Add-Type -Assembly 'System.IO.Compression.FileSystem'
$zip = [System.IO.Compression.ZipFile]::Open("$PWD\chrome_elf.zip", 'read')
[System.IO.Compression.ZipFileExtensions]::ExtractToDirectory($zip, $PWD)
$zip.Dispose()

Remove-Item -LiteralPath "$PWD\chrome_elf.zip"

try {
    $webClient.DownloadFile(
        # Remote file URL
        'https://download.scdn.co/SpotifySetup.exe',
        # Local file path
        "$PWD\SpotifySetup.exe"
    )
}
catch [System.Management.Automation.MethodInvocationException] {
    Write-Host "Error downloading SpotifySetup.exe" -ForegroundColor RED
    $Error[0].Exception
    Write-Host ""
    Write-Host "Will re-request in 5 seconds..."`n
    Start-Sleep -Milliseconds 5000 
    try {

        $webClient.DownloadFile(
            # Remote file URL
            'https://download.scdn.co/SpotifySetup.exe',
            # Local file path
            "$PWD\SpotifySetup.exe"
        )
    }
    catch [System.Management.Automation.MethodInvocationException] {
        Write-Host "Error again, script stopped" -ForegroundColor RED
        $Error[0].Exception
        Write-Host ""
        Write-Host "Try to check your internet connection and run the installation again."`n
        $tempDirectory = $PWD
        Pop-Location
        Start-Sleep -Milliseconds 200
        Remove-Item -Recurse -LiteralPath $tempDirectory 
        exit
    }
}



$spotifyInstalled = (Test-Path -LiteralPath $spotifyExecutable)

if ($spotifyInstalled) {



    # Check last version Spotify online
    $version_client_check = (get-item $PWD\SpotifySetup.exe).VersionInfo.ProductVersion
    $online_version = $version_client_check -split '.\w\w\w\w\w\w\w\w\w'


    # Check last version Spotify ofline
    $ofline_version = (Get-Item $spotifyExecutable).VersionInfo.FileVersion


    if ($online_version -gt $ofline_version) {


        do {
            $ch = Read-Host -Prompt "Your Spotify $ofline_version version is outdated, it is recommended to upgrade to $online_version `nWant to update ? (Y/N)"
            Write-Host ""
            if (!($ch -eq 'n' -or $ch -eq 'y')) {

                Write-Host "Oops, an incorrect value, " -ForegroundColor Red -NoNewline
                Write-Host "enter again through..." -NoNewline
                Start-Sleep -Milliseconds 1000
                Write-Host "3" -NoNewline
                Start-Sleep -Milliseconds 1000
                Write-Host ".2" -NoNewline
                Start-Sleep -Milliseconds 1000
                Write-Host ".1"
                Start-Sleep -Milliseconds 1000     
                Clear-Host
            }
        }
        while ($ch -notmatch '^y$|^n$')
        if ($ch -eq 'y') { $upgrade_client = $true }
    }
}


# If there is no client or it is outdated, then install
if (-not $spotifyInstalled -or $upgrade_client) {

    $version_client_check = (get-item $PWD\SpotifySetup.exe).VersionInfo.ProductVersion
    $version_client = $version_client_check -split '.\w\w\w\w\w\w\w\w\w'

    Write-Host "Downloading and installing Spotify " -NoNewline
    Write-Host  $version_client -ForegroundColor Green
    Write-Host "Please wait..."`n


    # Try deleting chrome_elf files if Spotify folder exists
    if (Test-Path -LiteralPath $spotifyDirectory) {
        $ErrorActionPreference = 'SilentlyContinue'  # extinguishes light mistakes
        Stop-Process -Name Spotify 
        Start-Sleep -Seconds 1
        Remove-Item $spotifyDirectory -Include *chrome_elf* -Recurse -Force
    } 

    # Client installation
    Start-Process -FilePath explorer.exe -ArgumentList $PWD\SpotifySetup.exe
    while (-not (get-process | Where-Object { $_.ProcessName -eq 'SpotifySetup' })) {}
    wait-process -name SpotifySetup

    Stop-Process -Name Spotify 
    Stop-Process -Name SpotifyWebHelper 
    Stop-Process -Name SpotifyFullSetup 

    $ErrorActionPreference = 'SilentlyContinue'  # extinguishes light mistakes

    # Remove Spotify installer
    if (test-path "$env:LOCALAPPDATA\Microsoft\Windows\Temporary Internet Files\") {
        get-childitem -path "$env:LOCALAPPDATA\Microsoft\Windows\Temporary Internet Files\" -Recurse -Force -Filter  "SpotifyFullSetup*" | remove-item  -Force
    }
    if (test-path $env:LOCALAPPDATA\Microsoft\Windows\INetCache\) {
        get-childitem -path "$env:LOCALAPPDATA\Microsoft\Windows\INetCache\" -Recurse -Force -Filter  "SpotifyFullSetup*" | remove-item  -Force
    }
}

# Create backup chrome_elf.dll
if (!(Test-Path -LiteralPath $chrome_elf_bak)) {
    Move-Item $chrome_elf $chrome_elf_bak 
}



do {
    $ch = Read-Host -Prompt "Want to turn off podcasts ? (Y/N)"
    Write-Host ""
    if (!($ch -eq 'n' -or $ch -eq 'y')) {
    
        Write-Host "Oops, an incorrect value, " -ForegroundColor Red -NoNewline
        Write-Host "enter again through..." -NoNewline
        Start-Sleep -Milliseconds 1000
        Write-Host "3" -NoNewline
        Start-Sleep -Milliseconds 1000
        Write-Host ".2" -NoNewline
        Start-Sleep -Milliseconds 1000
        Write-Host ".1"
        Start-Sleep -Milliseconds 1000     
        Clear-Host
    }
}
while ($ch -notmatch '^y$|^n$')
if ($ch -eq 'y') { $podcasts_off = $true }


do {
    $ch = Read-Host -Prompt "Want to block updates ? (Y/N)"
    Write-Host ""
    if (!($ch -eq 'n' -or $ch -eq 'y')) {
    
        Write-Host "Oops, an incorrect value, " -ForegroundColor Red -NoNewline
        Write-Host "enter again through..." -NoNewline
        Start-Sleep -Milliseconds 1000
        Write-Host "3" -NoNewline
        Start-Sleep -Milliseconds 1000
        Write-Host ".2" -NoNewline
        Start-Sleep -Milliseconds 1000
        Write-Host ".1"
        Start-Sleep -Milliseconds 1000     
        Clear-Host
    }
}
while ($ch -notmatch '^y$|^n$')

if ($ch -eq 'y') { $block_update = $true }

do {
    $ch = Read-Host -Prompt "Want to set up automatic cache cleanup? (Y/N)"
    Write-Host ""
    if (!($ch -eq 'n' -or $ch -eq 'y')) {
        Write-Host "Oops, an incorrect value, " -ForegroundColor Red -NoNewline
        Write-Host "enter again through..." -NoNewline
        Start-Sleep -Milliseconds 1000
        Write-Host "3" -NoNewline
        Start-Sleep -Milliseconds 1000
        Write-Host ".2" -NoNewline
        Start-Sleep -Milliseconds 1000
        Write-Host ".1"
        Start-Sleep -Milliseconds 1000     
        Clear-Host
    }
}
while ($ch -notmatch '^y$|^n$')
if ($ch -eq 'y') {
    $cache_install = $true 

    do {
        $ch = Read-Host -Prompt "Cache files that have not been used for more than XX days will be deleted.
    Enter the number of days from 1 to 100"
        Write-Host ""
        if (!($ch -match "^[1-9][0-9]?$|^100$")) {
            Write-Host "Oops, an incorrect value, " -ForegroundColor Red -NoNewline
            Write-Host "enter again through..." -NoNewline
		
            Start-Sleep -Milliseconds 1000
            Write-Host "3" -NoNewline
            Start-Sleep -Milliseconds 1000
            Write-Host ".2" -NoNewline
            Start-Sleep -Milliseconds 1000
            Write-Host ".1"
            Start-Sleep -Milliseconds 1000     
            Clear-Host
        }
    }
    while ($ch -notmatch '^[1-9][0-9]?$|^100$')

    if ($ch -match "^[1-9][0-9]?$|^100$") { $number_days = $ch }

}


function OffUpdStatus {
    # Remove the label about the new version
    $upgrade_status = "sp://desktop/v1/upgrade/status"
    if ($xpui_js -match $upgrade_status) { $xpui_js = $xpui_js -replace $upgrade_status, "" } else { Write-Host "Didn't find variable " -ForegroundColor red -NoNewline; Write-Host "`$upgrade_status in xpui.js" }
    $xpui_js
}
function OffPodcasts {
    # Turn off podcasts
    $podcasts_off1 = 'album,playlist,artist,show,station,episode', 'album,playlist,artist,station'
    $podcasts_off2 = ',this[.]enableShows=[a-z]'
    if ($xpui_js -match $podcasts_off1[0]) { $xpui_js = $xpui_js -replace $podcasts_off1[0], $podcasts_off1[1] } else { Write-Host "Didn't find variable " -ForegroundColor red -NoNewline; Write-Host "`$podcasts_off1[0] in xpui.js" }
    if ($xpui_js -match $podcasts_off2) { $xpui_js = $xpui_js -replace $podcasts_off2, "" } else { Write-Host "Didn't find variable " -ForegroundColor red -NoNewline; Write-Host "`$podcasts_off2 in xpui.js" }
    $xpui_js
}
function OffAdsOnFullscreen {

    # Removing an empty block
    $empty_block_ad = 'adsEnabled:!0', 'adsEnabled:!1'

    # Full screen mode activation and removing "Upgrade to premium" menu, upgrade button
    
    $ofline_version2 = (Get-Item $spotifyExecutable).VersionInfo.FileVersion
    
    if ($ofline_version2 -ge "1.1.80.699") {
        
        $full_screen_1 = '({return ..session},.=function\(.\){var .,.,.;return)("free")', '$1"premium"'
        $full_screen_2 = '(toLowerCase\(\)\)},.=function\(.\){var .,.,.;return)("premium")', '$1"free"'
    }
    if ($ofline_version2 -le "1.1.79.763") {
        
        $full_screen_1 = '(session[,]{1}[a-z]{1}[=]{1}[a-z]{1}[=]{1}[>]{1}[{]{1}var [a-z]{1}[,]{1}[a-z]{1}[,]{1}[a-z]{1}[;]{1}[a-z]{6})(["]{1}free["]{1})', '$1"premium"'
        $full_screen_2 = '([a-z]{1}[.]{1}toLowerCase[(]{1}[)]{2}[}]{1}[,]{1}[a-z]{1}[=]{1}[a-z]{1}[=]{1}[>]{1}[{]{1}var [a-z]{1}[,]{1}[a-z]{1}[,]{1}[a-z]{1}[;]{1}return)(["]{1}premium["]{1})', '$1"free"'
    }

    # Disabling a playlist sponsor
    $playlist_ad_off = "allSponsorships"

    # Remove the menu item "download"
    $menu_download = 'return .\(\).createElement\(....,\{value:"download-playlist"\},.\(\).createElement\(..,.\)\)'

    if ($xpui_js -match $empty_block_ad[0]) { $xpui_js = $xpui_js -replace $empty_block_ad[0], $empty_block_ad[1] } else { Write-Host "Didn't find variable " -ForegroundColor red -NoNewline; Write-Host "`$empty_block_ad[0] in xpui.js" }
    if ($xpui_js -match $full_screen_1[0]) { $xpui_js = $xpui_js -replace $full_screen_1[0], $full_screen_1[1] } else { Write-Host "Didn't find variable " -ForegroundColor red -NoNewline; Write-Host "`$full_screen_1[0] in xpui.js" }
    if ($xpui_js -match $full_screen_2[0]) { $xpui_js = $xpui_js -replace $full_screen_2[0], $full_screen_2[1] } else { Write-Host "Didn't find variable " -ForegroundColor red -NoNewline; Write-Host "`$full_screen_2[0] in xpui.js" }
    if ($xpui_js -match $playlist_ad_off) { $xpui_js = $xpui_js -replace $playlist_ad_off, "" } else { Write-Host "Didn't find variable " -ForegroundColor red -NoNewline; Write-Host "`$playlist_ad_off in xpui.js" }
    if ($xpui_js -match $menu_download) { $xpui_js = $xpui_js -replace $menu_download, "" } else { Write-Host "Didn't find variable " -ForegroundColor red -NoNewline; Write-Host "`$menu_download in xpui.js" }
    $xpui_js
}
function ExpFeature {
    # Experimental Feature
    $exp_features1 = '(Show "Made For You" entry point in the left sidebar.,default:)(!1)', '$1!0'
    $exp_features2 = '(Enable the new Search with chips experience",default:)(!1)', '$1!0'  
    $exp_features3 = '(Enable Liked Songs section on Artist page",default:)(!1)', '$1!0' 
    $exp_features4 = '(Enable block users feature in clientX",default:)(!1)', '$1!0' 
    $exp_features5 = '(Enables quicksilver in-app messaging modal",default:)(!0)', '$1!1' 
    $exp_features6 = '(With this enabled, clients will check whether tracks have lyrics available",default:)(!1)', '$1!0' 
    $exp_features7 = '(Enables new playlist creation flow in Web Player and DesktopX",default:)(!1)', '$1!0' 
    $exp_features8 = '(Enable Enhance Playlist UI and functionality",default:)(!1)', '$1!0'
    $exp_features9 = '(Enable a condensed disography shelf on artist pages",default:)(!1)', '$1!0'
    if ($xpui_js -match $exp_features1[0]) { $xpui_js = $xpui_js -replace $exp_features1[0], $exp_features1[1] } else { Write-Host "Didn't find variable " -ForegroundColor red -NoNewline; Write-Host "`$exp_features1[0] in xpui.js" }
    if ($xpui_js -match $exp_features2[0]) { $xpui_js = $xpui_js -replace $exp_features2[0], $exp_features2[1] } else { Write-Host "Didn't find variable " -ForegroundColor red -NoNewline; Write-Host "`$exp_features2[0] in xpui.js" }
    if ($xpui_js -match $exp_features3[0]) { $xpui_js = $xpui_js -replace $exp_features3[0], $exp_features3[1] } else { Write-Host "Didn't find variable " -ForegroundColor red -NoNewline; Write-Host "`$exp_features3[0] in xpui.js" }
    if ($xpui_js -match $exp_features4[0]) { $xpui_js = $xpui_js -replace $exp_features4[0], $exp_features4[1] } else { Write-Host "Didn't find variable " -ForegroundColor red -NoNewline; Write-Host "`$exp_features4[0] in xpui.js" }
    if ($xpui_js -match $exp_features5[0]) { $xpui_js = $xpui_js -replace $exp_features5[0], $exp_features5[1] } else { Write-Host "Didn't find variable " -ForegroundColor red -NoNewline; Write-Host "`$exp_features5[0] in xpui.js" }
    if ($xpui_js -match $exp_features6[0]) { $xpui_js = $xpui_js -replace $exp_features6[0], $exp_features6[1] } else { Write-Host "Didn't find variable " -ForegroundColor red -NoNewline; Write-Host "`$exp_features6[0] in xpui.js" }
    if ($xpui_js -match $exp_features7[0]) { $xpui_js = $xpui_js -replace $exp_features7[0], $exp_features7[1] } else { Write-Host "Didn't find variable " -ForegroundColor red -NoNewline; Write-Host "`$exp_features7[0] in xpui.js" }
    if ($xpui_js -match $exp_features8[0]) { $xpui_js = $xpui_js -replace $exp_features8[0], $exp_features8[1] } else { Write-Host "Didn't find variable " -ForegroundColor red -NoNewline; Write-Host "`$exp_features8[0] in xpui.js" }
    if ($xpui_js -match $exp_features9[0]) { $xpui_js = $xpui_js -replace $exp_features9[0], $exp_features9[1] } else { Write-Host "Didn't find variable " -ForegroundColor red -NoNewline; Write-Host "`$exp_features9[0] in xpui.js" }
    $xpui_js
}

function ContentsHtml {
    # licenses.html minification
    
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

$patchFiles = "$PWD\chrome_elf.dll", "$PWD\config.ini"
Copy-Item -LiteralPath $patchFiles -Destination "$spotifyDirectory"

$tempDirectory = $PWD
Pop-Location



Start-Sleep -Milliseconds 200
Remove-Item -Recurse -LiteralPath $tempDirectory 

$xpui_spa_patch = "$env:APPDATA\Spotify\Apps\xpui.spa"
$xpui_js_patch = "$env:APPDATA\Spotify\Apps\xpui\xpui.js"

$test_spa = Test-Path -Path $env:APPDATA\Spotify\Apps\xpui.spa
$test_js = Test-Path -Path $env:APPDATA\Spotify\Apps\xpui\xpui.js

if ($test_spa -and $test_js) {
    Write-Host "Error" -ForegroundColor Red
    Write-Host "The location of Spotify files is broken, uninstall the client and run the script again."
    Write-Host "The script is stopped."
    exit
}

if (Test-Path $xpui_js_patch) {
    Write-Host "Spicetify detected"`n

    
    $reader = New-Object -TypeName System.IO.StreamReader -ArgumentList $xpui_js_patch
    $xpui_js = $reader.ReadToEnd()
    $reader.Close()
        
    If (!($xpui_js -match 'patched by spotx')) {
        $spotx_new = $true
        Copy-Item $xpui_js_patch "$xpui_js_patch.bak"
    }


    # Remove the label about the new version
    if ($block_update) { $xpui_js = OffUpdStatus }

    # Turn off podcasts
    if ($Podcasts_off) { $xpui_js = OffPodcasts }
    
    # Full screen mode activation and removing "Upgrade to premium" menu, upgrade button, disabling a playlist sponsor
    $xpui_js = OffAdsOnFullscreen
       
    # Experimental Feature
    $xpui_js = ExpFeature

    $writer = New-Object System.IO.StreamWriter -ArgumentList $xpui_js_patch
    $writer.BaseStream.SetLength(0)
    $writer.Write($xpui_js)
    if ($spotx_new) { $writer.Write([System.Environment]::NewLine + '// Patched by SpotX') }
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

    # Make a backup copy of xpui.spa if it is original
    Add-Type -Assembly 'System.IO.Compression.FileSystem'
    $zip = [System.IO.Compression.ZipFile]::Open($xpui_spa_patch, 'update')
    $entry = $zip.GetEntry('xpui.js')
    $reader = New-Object System.IO.StreamReader($entry.Open())
    $patched_by_spotx = $reader.ReadToEnd()
    $reader.Close()

    If (!($patched_by_spotx -match 'patched by spotx')) {
        $spotx_new = $true 
        $zip.Dispose()    
        Copy-Item $xpui_spa_patch $env:APPDATA\Spotify\Apps\xpui.bak
    }
    else { $zip.Dispose() }
    
    Add-Type -Assembly 'System.IO.Compression.FileSystem'
    $zip = [System.IO.Compression.ZipFile]::Open($xpui_spa_patch, 'update')
    
    # xpui.js
    $entry_xpui = $zip.GetEntry('xpui.js')
    $reader = New-Object System.IO.StreamReader($entry_xpui.Open())
    $xpui_js = $reader.ReadToEnd()
    $reader.Close()


    # Remove the label about the new version
    if ($block_update) { $xpui_js = OffUpdStatus }


    # Turn off podcasts
    if ($podcasts_off) { $xpui_js = OffPodcasts }
    

    # Full screen mode activation and removing "Upgrade to premium" menu, upgrade button, disabling a playlist sponsor
    $xpui_js = OffAdsOnFullscreen
       
    # Experimental Feature
    $xpui_js = ExpFeature
   
    $writer = New-Object System.IO.StreamWriter($entry_xpui.Open())
    $writer.BaseStream.SetLength(0)
    $writer.Write($xpui_js)
    if ($spotx_new) { $writer.Write([System.Environment]::NewLine + '// Patched by SpotX') }
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


    # xpui.css
    $entry_xpui_css = $zip.GetEntry('xpui.css')
    $reader = New-Object System.IO.StreamReader($entry_xpui_css.Open())
    $xpuiContents_xpui_css = $reader.ReadToEnd()
    $reader.Close()
        
    $writer = New-Object System.IO.StreamWriter($entry_xpui_css.Open())
    $writer.BaseStream.SetLength(0)
    $writer.Write($xpuiContents_xpui_css)
    # Hide download icon on different pages
    $writer.Write([System.Environment]::NewLine + ' .BKsbV2Xl786X9a09XROH {display: none}')
    $writer.Close()


    # js minification
    $zip.Entries | Where-Object FullName -like '*.js' | ForEach-Object {
        $readerjs = New-Object System.IO.StreamReader($_.Open())
        $xpuiContents_js = $readerjs.ReadToEnd()
        $readerjs.Close()
        $xpuiContents_js = $xpuiContents_js `
            -replace "[/][/][#] sourceMappingURL=.*[.]map", "" `
            -replace "\r?\n(?!\(1|\d)", ""
        $writer = New-Object System.IO.StreamWriter($_.Open())
        $writer.BaseStream.SetLength(0)
        $writer.Write($xpuiContents_js)
        $writer.Close()
    }



    # *.Css
    $zip.Entries | Where-Object FullName -like '*.css' | ForEach-Object {
        $readercss = New-Object System.IO.StreamReader($_.Open())
        $xpuiContents_css = $readercss.ReadToEnd()
        $readercss.Close()

        
        $xpuiContents_css = $xpuiContents_css `
            <# Remove RTL #>`
            -replace "}\[dir=ltr\]\s?([.a-zA-Z\d[_]+?,\[dir=ltr\])", '}[dir=str] $1' `
            -replace "}\[dir=ltr\]\s?", "} " `
            -replace "html\[dir=ltr\]", "html" `
            -replace ",\s?\[dir=rtl\].+?(\{.+?\})", '$1' `
            -replace "[\w\-\.]+\[dir=rtl\].+?\{.+?\}", "" `
            -replace "\}\[lang=ar\].+?\{.+?\}", "}" `
            -replace "\}\[dir=rtl\].+?\{.+?\}", "}" `
            -replace "\}html\[dir=rtl\].+?\{.+?\}", "}" `
            -replace "\}html\[lang=ar\].+?\{.+?\}", "}" `
            -replace "\[lang=ar\].+?\{.+?\}", "" `
            -replace "html\[dir=rtl\].+?\{.+?\}", "" `
            -replace "html\[lang=ar\].+?\{.+?\}", "" `
            -replace "\[dir=rtl\].+?\{.+?\}", "" `
            -replace "\[dir=str\]", "[dir=ltr]" `
            <# Css minification #>`
            -replace "[/]\*([^*]|[\r\n]|(\*([^/]|[\r\n])))*\*[/]", "" `
            -replace "[/][/]#\s.*", "" `
            -replace "\r?\n(?!\(1|\d)", ""
    
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

        # Json minification
        $xpuiContents_json = $xpuiContents_json `
            -replace "  ", "" -replace "    ", "" -replace '": ', '":' -replace "\r?\n(?!\(1|\d)", "" 

        $writer = New-Object System.IO.StreamWriter($_.Open())
        $writer.BaseStream.SetLength(0)
        $writer.Write($xpuiContents_json)
        $writer.Close()
    }
    $zip.Dispose()   
}


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

# Shortcut bug
$ErrorActionPreference = 'SilentlyContinue' 

If (!(Test-Path $env:USERPROFILE\Desktop\Spotify.lnk)) {
  
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
$update_directory = Test-Path -Path $env:LOCALAPPDATA\Spotify
$migrator_bak = Test-Path -Path $env:APPDATA\Spotify\SpotifyMigrator.bak  
$migrator_exe = Test-Path -Path $env:APPDATA\Spotify\SpotifyMigrator.exe
$Check_folder_file = Get-ItemProperty -Path $env:LOCALAPPDATA\Spotify\Update | Select-Object Attributes 
$folder_update_access = Get-Acl $env:LOCALAPPDATA\Spotify\Update



if ($block_update) {

    # If there was a client installation 
    if (!($update_directory)) {

        # Create Spotify folder in Localappdata
        New-Item -Path $env:LOCALAPPDATA -Name "Spotify" -ItemType "directory" | Out-Null

        # Create Update file
        New-Item -Path $env:LOCALAPPDATA\Spotify\ -Name "Update" -ItemType "file" -Value "STOPIT" | Out-Null
        $file_upd = Get-ItemProperty -Path $env:LOCALAPPDATA\Spotify\Update
        $file_upd.Attributes = "ReadOnly", "System"
      
        # Если оба файлав мигратора существуют то .bak удалить, а .exe переименовать в .bak
        If ($migrator_exe -and $migrator_bak) {
            Remove-item $env:APPDATA\Spotify\SpotifyMigrator.bak -Recurse -Force
            Rename-Item -path $env:APPDATA\Spotify\SpotifyMigrator.exe -NewName $env:APPDATA\Spotify\SpotifyMigrator.bak
        }

        # Если есть только мигратор .exe то переименовать его в .bak
        if ($migrator_exe) {
            Rename-Item -path $env:APPDATA\Spotify\SpotifyMigrator.exe -NewName $env:APPDATA\Spotify\SpotifyMigrator.bak
        }
    }

    # If the client has already been
    If ($update_directory) {


        # Delete the Update folder if it exists
        if ($Check_folder_file -match '\bDirectory\b') {  

            # If the rights of the Update folder are blocked, then unblock 
            if ($folder_update_access.AccessToString -match 'Deny') {

        ($ACL = Get-Acl $env:LOCALAPPDATA\Spotify\Update).access | ForEach-Object {
                    $Users = $_.IdentityReference 
                    $ACL.PurgeAccessRules($Users) }
                $ACL | Set-Acl $env:LOCALAPPDATA\Spotify\Update
            }
            Remove-item $env:LOCALAPPDATA\Spotify\Update -Recurse -Force
        } 

        # Create Update file if it doesn't exist
        if (!($Check_folder_file -match '\bSystem\b' -and $Check_folder_file -match '\bReadOnly\b')) {  
            New-Item -Path $env:LOCALAPPDATA\Spotify\ -Name "Update" -ItemType "file" -Value "STOPIT" | Out-Null
            $file_upd = Get-ItemProperty -Path $env:LOCALAPPDATA\Spotify\Update
            $file_upd.Attributes = "ReadOnly", "System"
        }
        # Если оба файлав мигратора существуют то .bak удалить, а .exe переименовать в .bak
        If ($migrator_exe -and $migrator_bak) {
            Remove-item $env:APPDATA\Spotify\SpotifyMigrator.bak -Recurse -Force
            Rename-Item -path $env:APPDATA\Spotify\SpotifyMigrator.exe -NewName $env:APPDATA\Spotify\SpotifyMigrator.bak
        }

        # Если есть только мигратор .exe то переименовать его в .bak
        if ($migrator_exe) {
            Rename-Item -path $env:APPDATA\Spotify\SpotifyMigrator.exe -NewName $env:APPDATA\Spotify\SpotifyMigrator.bak
        }
    }
}


# automatic cache clearing


if ($cache_install) {

    $test_cache_folder = Test-Path -Path $env:APPDATA\Spotify\cache

    if ($test_cache_folder) {
        Remove-item $env:APPDATA\Spotify\cache -Recurse -Force
    }

    Start-Sleep -Milliseconds 200


    New-Item -Path $env:APPDATA\Spotify\ -Name "cache" -ItemType "directory" | Out-Null

    # cache-spotify.ps1
    $webClient.DownloadFile('https://raw.githubusercontent.com/amd64fox/SpotX/main/Cache/cache-spotify.ps1', "$env:APPDATA\Spotify\cache\cache-spotify.ps1")

    # hide_window.vbs
    $webClient.DownloadFile('https://raw.githubusercontent.com/amd64fox/SpotX/main/Cache/hide_window.vbs', "$env:APPDATA\Spotify\cache\hide_window.vbs")
    
    # run_ps.bat
    $webClient.DownloadFile('https://raw.githubusercontent.com/amd64fox/SpotX/main/Cache/run_ps.bat', "$env:APPDATA\Spotify\cache\run_ps.bat")


    # Spotify.lnk
    $source2 = "$env:APPDATA\Spotify\cache\hide_window.vbs"
    $target2 = "$desktop_folder\Spotify.lnk"
    $WorkingDir2 = "$env:APPDATA\Spotify\cache\"
    $WshShell2 = New-Object -comObject WScript.Shell
    $Shortcut2 = $WshShell2.CreateShortcut($target2)
    $Shortcut2.WorkingDirectory = $WorkingDir2
    $Shortcut2.IconLocation = "$env:APPDATA\Spotify\Spotify.exe"
    $Shortcut2.TargetPath = $source2
    $Shortcut2.Save()


    if ($number_days -match "^[1-9][0-9]?$|^100$") {
        $file_cache_spotify_ps1 = Get-Content $env:APPDATA\Spotify\cache\cache-spotify.ps1 -Raw
        $new_file_cache_spotify_ps1 = $file_cache_spotify_ps1 -replace '7', $number_days
        Set-Content -Path $env:APPDATA\Spotify\cache\cache-spotify.ps1 -Force -Value $new_file_cache_spotify_ps1
        $contentcache_spotify_ps1 = [System.IO.File]::ReadAllText("$env:APPDATA\Spotify\cache\cache-spotify.ps1")
        $contentcache_spotify_ps1 = $contentcache_spotify_ps1.Trim()
        [System.IO.File]::WriteAllText("$env:APPDATA\Spotify\cache\cache-spotify.ps1", $contentcache_spotify_ps1)

        $infile = "$env:APPDATA\Spotify\cache\cache-spotify.ps1"
        $outfile = "$env:APPDATA\Spotify\cache\cache-spotify2.ps1"

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


        Write-Host "installation completed"`n -ForegroundColor Green
        exit
    }
}

Write-Host "installation completed"`n -ForegroundColor Green
exit