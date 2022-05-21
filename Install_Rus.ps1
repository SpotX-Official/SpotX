# Игнорировать ошибки из `Stop-Process`
$PSDefaultParameterValues['Stop-Process:ErrorAction'] = [System.Management.Automation.ActionPreference]::SilentlyContinue

Write-Host "*****************"
Write-Host "Автор: " -NoNewline
Write-Host "@Amd64fox" -ForegroundColor DarkYellow
Write-Host "*****************"`n


$spotifyDirectory = "$env:APPDATA\Spotify"
$spotifyDirectory2 = "$env:LOCALAPPDATA\Spotify"
$spotifyExecutable = "$spotifyDirectory\Spotify.exe"
$chrome_elf = "$spotifyDirectory\chrome_elf.dll"
$chrome_elf_bak = "$spotifyDirectory\chrome_elf_bak.dll"
$block_File_update = "$env:LOCALAPPDATA\Spotify\Update"
$cache_folder = "$env:APPDATA\Spotify\cache"
$verPS = $PSVersionTable.PSVersion.major
$upgrade_client = $false
$podcasts_off = $false
$block_update = $false
$cache_install = $false

function incorrectValue {

    Write-Host "Ой, некорректное значение, " -ForegroundColor Red -NoNewline
    Write-Host "повторите ввод через " -NoNewline
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

    # Проверить рекомендуемую версию spotx
    if ($param2 -eq "online") {
        $ProgressPreference = 'SilentlyContinue' # Hiding Progress Bars
        $readme = Invoke-WebRequest -UseBasicParsing -Uri https://raw.githubusercontent.com/amd64fox/SpotX/main/README.md
        $v = $readme.RawContent | Select-String "Recommended official version \[\d+\.\d+\.\d+\.\d+\]" -AllMatches
        $ver = $v.Matches.Value
        $ver = $ver -replace 'Recommended official version \[(\d+\.\d+\.\d+\.\d+)\]', '$1'
        return $ver
    }
    # Проверить текущую версию Spotify 
    if ($param2 -eq "offline") {
        $check_offline = (Get-Item $spotifyExecutable).VersionInfo.FileVersion
        return $check_offline
    }
}
function unlockFolder {

    $ErrorActionPreference = 'SilentlyContinue'
    $Check_folder = Get-ItemProperty -Path $block_File_update | Select-Object Attributes 
    $folder_update_access = Get-Acl $block_File_update

    # Проверка папки Update если она есть
    if ($Check_folder -match '\bDirectory\b') {  

        # Если у папки Update заблокированы права то разблокировать 
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
        "https://raw.githubusercontent.com/amd64fox/SpotX/main/Cache/cache_spotify_ru.ps1", "https://raw.githubusercontent.com/amd64fox/SpotX/main/Cache/hide_window.vbs", `
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
            curl.exe $web_Url -o $local_Url --progress-bar
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
        Write-Host "Ошибка загрузки" $web_name_file -ForegroundColor RED
        $Error[0].Exception
        Write-Host ""
        Write-Host "Повторный запрос через 5 секунд..."`n
        Start-Sleep -Milliseconds 5000 
        try { 

            if ($param1 -eq "Desktop" -and $curl_check) {
                curl.exe $web_Url -o $local_Url --progress-bar
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
            Write-Host "Опять ошибка, скрипт остановлен" -ForegroundColor RED
            $Error[0].Exception
            Write-Host ""
            Write-Host "Попробуйте проверить подключение к интернету и снова запустить установку."`n
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

# добавить Tls12
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Stop-Process -Name Spotify
Stop-Process -Name SpotifyWebHelper

if ($verPS -lt 3) {
    do {
        Write-Host "Ваша версия PowerShell $verPS не поддерживается"`n
        $ch = Read-Host -Prompt "Пожалуйста прочтите 'Outdated versions of PowerShell' `nОткрыть страницу с инструкцией ? (Y/N)"
        Write-Host ""
        if (!($ch -eq 'n' -or $ch -eq 'y')) { incorrectValue }
    }
    while ($ch -notmatch '^y$|^n$')
    if ($ch -eq 'y') {
        Start-Process "https://github.com/amd64fox/SpotX#possible-problems"
        Write-Host "скрипт остановлен" 
        exit
    }
    if ($ch -eq 'n') {
        Write-Host "скрипт остановлен" 
        exit
    }
}
if ($verPS -ge 7) {
    Import-Module Appx -UseWindowsPowerShell -WarningAction:SilentlyContinue
}

# Проверка версии Windows
$win_os = (get-itemproperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name ProductName).ProductName
$win11 = $win_os -match "\windows 11\b"
$win10 = $win_os -match "\windows 10\b"
$win8_1 = $win_os -match "\windows 8.1\b"
$win8 = $win_os -match "\windows 8\b"

if ($win11 -or $win10 -or $win8_1 -or $win8) {

    # Удалить Spotify Windows Store если он есть
    if (Get-AppxPackage -Name SpotifyAB.SpotifyMusic) {
        Write-Host 'Обнаружена версия Spotify из Microsoft Store, которая не поддерживается.'`n
        do {
            $ch = Read-Host -Prompt "Хотите удалить Spotify Microsoft Store ? (Y/N) "
            Write-Host ""
            if (!($ch -eq 'n' -or $ch -eq 'y')) {
                incorrectValue
            }
        }
        while ($ch -notmatch '^y$|^n$')
        if ($ch -eq 'y') {      
            $ProgressPreference = 'SilentlyContinue' # Скрывает Progress Bars
            Write-Host 'Удаление Spotify...'`n
            Get-AppxPackage -Name SpotifyAB.SpotifyMusic | Remove-AppxPackage
        }
        if ($ch -eq 'n') {
            Read-Host "Завершение работы скрипта..." 
            exit
        }
    }
}

# Создаем уникальное имя каталога на основе времени
Push-Location -LiteralPath $env:TEMP
New-Item -Type Directory -Name "SpotX_Temp-$(Get-Date -UFormat '%Y-%m-%d_%H-%M-%S')" | Convert-Path | Set-Location

Write-Host 'Загружаю последний патч BTS...'`n
downloadScripts -param1 "BTS"
downloadScripts -param1 "links.tsv"

Add-Type -Assembly 'System.IO.Compression.FileSystem'
$zip = [System.IO.Compression.ZipFile]::Open("$PWD\chrome_elf.zip", 'read')
[System.IO.Compression.ZipFileExtensions]::ExtractToDirectory($zip, $PWD)
$zip.Dispose()

$online = Check_verison_clients -param2 "online"

$spotifyInstalled = (Test-Path -LiteralPath $spotifyExecutable)

if ($spotifyInstalled) {

    $offline = Check_verison_clients -param2 "offline"

    if ($online -gt $offline) {
        do {
            $ch = Read-Host -Prompt "Ваша версия Spotify $offline устарела, рекомендуется обновиться до $online `nОбновить ? (Y/N)"
            Write-Host ""
            if (!($ch -eq 'n' -or $ch -eq 'y')) {
                incorrectValue
            }
        }
        while ($ch -notmatch '^y$|^n$')
        if ($ch -eq 'y') { $upgrade_client = $true }
    }

    if ($online -lt $offline) {
        do {
            $ch = Read-Host -Prompt "Ваша версия Spotify $offline еще не тестировалась, стабильная версия сейчас $online. `nХотите продолжить с $offline (возможны ошибки) ? (Y/N)"
            Write-Host ""
            if (!($ch -eq 'n' -or $ch -eq 'y')) {
                incorrectValue
            }
        }
        while ($ch -notmatch '^y$|^n$')
        if ($ch -eq 'y') { $upgrade_client = $false }
        if ($ch -eq 'n') {
            do {
                $ch = Read-Host -Prompt "Хотите установить рекомендуемую $online версию ? (Y/N)"
                Write-Host ""
                if (!($ch -eq 'n' -or $ch -eq 'y')) {
                    incorrectValue
                }
            }
            while ($ch -notmatch '^y$|^n$')
            if ($ch -eq 'y') {
                $upgrade_client = $true
            }
            if ($ch -eq 'n') {
                Write-Host "скрипт остановлен"
                Exit
            }
        }
    }
}
# Если клиента нет или он устарел, то начинаем установку/обновление
if (-not $spotifyInstalled -or $upgrade_client) {

    Write-Host "Загружаю и устанавливаю Spotify " -NoNewline
    Write-Host  $online -ForegroundColor Green
    Write-Host "Пожалуйста подождите......"`n
    
    # Удалить файлы прошлой версии Spotify перед установкой, оставить только файлы профиля
    $ErrorActionPreference = 'SilentlyContinue'  # Команда гасит легкие ошибки
    Stop-Process -Name Spotify 
    Start-Sleep -Milliseconds 600
    unlockFolder
    Start-Sleep -Milliseconds 200
    Get-ChildItem $spotifyDirectory -Exclude 'Users', 'prefs', 'cache' | Remove-Item -Recurse -Force 
    Get-ChildItem $spotifyDirectory2 -Exclude 'Users' | Remove-Item -Recurse -Force 
    Start-Sleep -Milliseconds 200

    # Загрузка клиента
    downloadScripts -param1 "Desktop"
    Write-Host ""

    Start-Sleep -Milliseconds 200

    # Установка клиента
    Start-Process -FilePath explorer.exe -ArgumentList $PWD\SpotifySetup.exe
    while (-not (get-process | Where-Object { $_.ProcessName -eq 'SpotifySetup' })) {}
    wait-process -name SpotifySetup
   
    Stop-Process -Name Spotify 
    Stop-Process -Name SpotifyWebHelper 
    Stop-Process -Name SpotifyFullSetup 

}

# Удалите папку leveldb (исправляет баг неверных эксперементальных фишек для некотрых аккаунтов)
$leveldb = (Test-Path -LiteralPath "$spotifyDirectory2\Browser\Local Storage\leveldb")

if ($leveldb) {
    $ErrorActionPreference = 'SilentlyContinue'
    remove-item "$spotifyDirectory2\Browser\Local Storage\leveldb" -Recurse -Force
}

# Создать резервную копию chrome_elf.dll
if (!(Test-Path -LiteralPath $chrome_elf_bak)) {
    Move-Item $chrome_elf $chrome_elf_bak 
}
do {
    $ch = Read-Host -Prompt "Хотите отключить подкасты ? (Y/N)"
    Write-Host ""
    if (!($ch -eq 'n' -or $ch -eq 'y')) { incorrectValue }
}
while ($ch -notmatch '^y$|^n$')
if ($ch -eq 'y') { $podcasts_off = $true }

do {
    $ch = Read-Host -Prompt "Хотите заблокировать обновления ? (Y/N)"
    Write-Host ""
    if (!($ch -eq 'n' -or $ch -eq 'y')) { incorrectValue } 
}
while ($ch -notmatch '^y$|^n$')
if ($ch -eq 'y') { $block_update = $true }

do {
    $ch = Read-Host -Prompt "Хотите установить автоматическую очистку кеша ? (Y/N)"
    Write-Host ""
    if (!($ch -eq 'n' -or $ch -eq 'y')) { incorrectValue }
}
while ($ch -notmatch '^y$|^n$')
if ($ch -eq 'y') {
    $cache_install = $true 

    do {
        $ch = Read-Host -Prompt "Файлы кэша, которые не использовались более XX дней, будут удалены.
    Пожалуйста, введите количество дней от 1 до 100"
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

function OffPodcasts {

    # Отключить подкасты
    $podcasts_off1 = '(return this\.queryParameters=(.),)', '$2.types=["album","playlist","artist","station"];$1'
    $podcasts_off2 = ',this[.]enableShows=[a-z]'

    if ($xpui_js -match $podcasts_off1[0]) { $xpui_js = $xpui_js -replace $podcasts_off1[0], $podcasts_off1[1] } else { Write-Host "Didn't find variable " -ForegroundColor red -NoNewline; Write-Host "`$podcasts_off1[0] in xpui.js" }
    if ($xpui_js -match $podcasts_off2) { $xpui_js = $xpui_js -replace $podcasts_off2, "" } else { Write-Host "Didn't find variable " -ForegroundColor red -NoNewline; Write-Host "`$podcasts_off2 in xpui.js" }
    $xpui_js
}

function OffAdsOnFullscreen {
    
    # Удаление пустого рекламного блока
    $empty_block_ad = 'adsEnabled:!0', 'adsEnabled:!1'

    # Активация полноэкранного режима, а также удаление кнопки и меню "Перейти на Premium"
    $full_screen = 'return"free"===(.+?)return"premium"===', 'return"premium"===$1return"free"==='

    # Отключиние спонсорской рекламы в некоторых плейлистах
    $playlist_ad_off = "allSponsorships"

    if ($xpui_js -match $empty_block_ad[0]) { $xpui_js = $xpui_js -replace $empty_block_ad[0], $empty_block_ad[1] } else { Write-Host "Не нашел " -ForegroundColor red -NoNewline; Write-Host "переменную `$empty_block_ad[0] в xpui.js" }
    if ($xpui_js -match $full_screen[0]) { $xpui_js = $xpui_js -replace $full_screen[0], $full_screen[1] } else { Write-Host "Не нашел " -ForegroundColor red -NoNewline; Write-Host "переменную `$full_screen[0] в xpui.js" }
    if ($xpui_js -match $playlist_ad_off) { $xpui_js = $xpui_js -replace $playlist_ad_off, "" } else { Write-Host "Не нашел " -ForegroundColor red -NoNewline; Write-Host "переменную `$playlist_ad_off в xpui.js" }
    $xpui_js
}

function OffRujs {
    
    # Удалить из xpui.js все языки кроме En и Ru
    $rus_js = '(JSON.parse\(.{)("en":"English \(English\)".*\(Vietnamese\)"})', '$1"en":"English (English)","ru":"Русский (Russian)"}'
    if ($xpui_js -match $rus_js[0]) { $xpui_js = $xpui_js -replace $rus_js[0], $rus_js[1] } else { Write-Host "Не нашел " -ForegroundColor red -NoNewline; Write-Host "переменную `$rus_js[0] в xpui.js" }
    $xpui_js
}

function ExpFeature {

    # Эксперементальные фишки

    $ofline = Check_verison_clients -param2 "offline"

    $exp_features1 = '(Show "Made For You" entry point in the left sidebar.,default:)(!1)', '$1!0'
    $exp_features2 = '(Enable the new Search with chips experience",default:)(!1)', '$1!0'  
    $exp_features3 = '(Enable Liked Songs section on Artist page",default:)(!1)', '$1!0' 
    $exp_features4 = '(Enable block users feature in clientX",default:)(!1)', '$1!0' 
    $exp_features5 = '(Enables quicksilver in-app messaging modal",default:)(!0)', '$1!1' 
    $exp_features6 = '(With this enabled, clients will check whether tracks have lyrics available",default:)(!1)', '$1!0' 
    $exp_features7 = '(Enables new playlist creation flow in Web Player and DesktopX",default:)(!1)', '$1!0' 
    $exp_features8 = '(Enable Enhance Playlist UI and functionality for end-users",default:)(!1)', '$1!0'
    $exp_features9 = '(Enable a condensed disography shelf on artist pages",default:)(!1)', '$1!0'
    $exp_features10 = '(Enable the new fullscreen lyrics page",default:)(!1)', '$1!0'
    if ($ofline -eq "1.1.84.716") { 
        $exp_features11 = '(lyrics_format:)(.)', '$1"fullscreen"'
    }
    $exp_features12 = '(Enable Playlist Permissions flows for Prod",default:)(!1)', '$1!0'

    if ($xpui_js -match $exp_features1[0]) { $xpui_js = $xpui_js -replace $exp_features1[0], $exp_features1[1] } else { Write-Host "Не нашел " -ForegroundColor red -NoNewline; Write-Host "переменную `$exp_features1[0] в xpui.js" }
    if ($xpui_js -match $exp_features2[0]) { $xpui_js = $xpui_js -replace $exp_features2[0], $exp_features2[1] } else { Write-Host "Не нашел " -ForegroundColor red -NoNewline; Write-Host "переменную `$exp_features2[0] в xpui.js" }
    if ($xpui_js -match $exp_features3[0]) { $xpui_js = $xpui_js -replace $exp_features3[0], $exp_features3[1] } else { Write-Host "Не нашел " -ForegroundColor red -NoNewline; Write-Host "переменную `$exp_features3[0] в xpui.js" }
    if ($xpui_js -match $exp_features4[0]) { $xpui_js = $xpui_js -replace $exp_features4[0], $exp_features4[1] } else { Write-Host "Не нашел " -ForegroundColor red -NoNewline; Write-Host "переменную `$exp_features4[0] в xpui.js" }
    if ($xpui_js -match $exp_features5[0]) { $xpui_js = $xpui_js -replace $exp_features5[0], $exp_features5[1] } else { Write-Host "Не нашел " -ForegroundColor red -NoNewline; Write-Host "переменную `$exp_features5[0] в xpui.js" }
    if ($xpui_js -match $exp_features6[0]) { $xpui_js = $xpui_js -replace $exp_features6[0], $exp_features6[1] } else { Write-Host "Не нашел " -ForegroundColor red -NoNewline; Write-Host "переменную `$exp_features6[0] в xpui.js" }
    if ($xpui_js -match $exp_features7[0]) { $xpui_js = $xpui_js -replace $exp_features7[0], $exp_features7[1] } else { Write-Host "Не нашел " -ForegroundColor red -NoNewline; Write-Host "переменную `$exp_features7[0] в xpui.js" }
    if ($xpui_js -match $exp_features8[0]) { $xpui_js = $xpui_js -replace $exp_features8[0], $exp_features8[1] } else { Write-Host "Не нашел " -ForegroundColor red -NoNewline; Write-Host "переменную `$exp_features8[0] в xpui.js" }
    if ($xpui_js -match $exp_features9[0]) { $xpui_js = $xpui_js -replace $exp_features9[0], $exp_features9[1] } else { Write-Host "Не нашел " -ForegroundColor red -NoNewline; Write-Host "переменную `$exp_features9[0] в xpui.js" }
    if ($xpui_js -match $exp_features10[0]) { $xpui_js = $xpui_js -replace $exp_features10[0], $exp_features10[1] } else { Write-Host "Не нашел " -ForegroundColor red -NoNewline; Write-Host "переменную `$exp_features10[0] в xpui.js" }
    if ($ofline -eq "1.1.84.716") { 
        if ($xpui_js -match $exp_features11[0]) { $xpui_js = $xpui_js -replace $exp_features11[0], $exp_features11[1] } else { Write-Host "Не нашел " -ForegroundColor red -NoNewline; Write-Host "переменную `$exp_features11[0] в xpui.js" }
    }
    if ($xpui_js -match $exp_features12[0]) { $xpui_js = $xpui_js -replace $exp_features12[0], $exp_features12[1] } else { Write-Host "Не нашел " -ForegroundColor red -NoNewline; Write-Host "переменную `$exp_features12[0] в xpui.js" }
    $xpui_js
}

function ContentsHtml {

    # Минификация html
    $html_lic_min1 = '<li><a href="#6eef7">zlib<\/a><\/li>\n(.|\n)*<\/p><!-- END CONTAINER DEPS LICENSES -->(<\/div>)'
    $html_lic_min2 = "	"
    $html_lic_min3 = "  "
    $html_lic_min4 = "(?m)(^\s*\r?\n)"
    $html_lic_min5 = "\r?\n(?!\(1|\d)"
    if ($xpuiContents_html -match $html_lic_min1) { $xpuiContents_html = $xpuiContents_html -replace $html_lic_min1, '$2' } else { Write-Host "Не нашел " -ForegroundColor red -NoNewline; Write-Host "переменную `$html_lic_min1 в licenses.html" }
    if ($xpuiContents_html -match $html_lic_min2) { $xpuiContents_html = $xpuiContents_html -replace $html_lic_min2, "" } else { Write-Host "Не нашел " -ForegroundColor red -NoNewline; Write-Host "переменную `$html_lic_min2 в licenses.html" }
    if ($xpuiContents_html -match $html_lic_min3) { $xpuiContents_html = $xpuiContents_html -replace $html_lic_min3, "" } else { Write-Host "Не нашел " -ForegroundColor red -NoNewline; Write-Host "переменную `$html_lic_min3 в licenses.html" }
    if ($xpuiContents_html -match $html_lic_min4) { $xpuiContents_html = $xpuiContents_html -replace $html_lic_min4, "" } else { Write-Host "Не нашел " -ForegroundColor red -NoNewline; Write-Host "переменную `$html_lic_min4 в licenses.html" }
    if ($xpuiContents_html -match $html_lic_min5) { $xpuiContents_html = $xpuiContents_html -replace $html_lic_min5, "" } else { Write-Host "Не нашел " -ForegroundColor red -NoNewline; Write-Host "переменную `$html_lic_min5 в licenses.html" }
    $xpuiContents_html
}

function RuTranslate {

    # Доперевод некоторых слов для русского языка
    $ru_translate1 = '"one": "Enhanced with [{]0[}] recommended song."', '"one": "Добавлен {0} рекомендованный трек."' 
    $ru_translate2 = '"few": "Enhanced with [{]0[}] recommended songs."', '"few": "Добавлено {0} рекомендованных трека."' 
    $ru_translate3 = '"many": "Enhanced with [{]0[}] recommended songs."', '"many": "Добавлено {0} рекомендованных треков."' 
    $ru_translate4 = '"other": "Enhanced with [{]0[}] recommended songs."', '"other": "Добавлено {0} рекомендованных трека."' 
    $ru_translate5 = '"To Enhance this playlist, you.ll need to go online."', '"Чтобы улучшить этот плейлист, вам нужно подключиться к интернету."'
    $ru_translate13 = '"Confirm your age"', '"Подтвердите свой возраст"' 
    $ru_translate16 = '"%price%\/month after. Terms and conditions apply. One month free not available for users who have already tried Premium."', '"%price%/месяц спустя. Принять условия. Один месяц бесплатно, недоступно для пользователей, которые уже попробовали Premium."' 
    $ru_translate17 = '"Enjoy ad-free music listening, offline listening, and more. Cancel anytime."', '"Наслаждайтесь прослушиванием музыки без рекламы, прослушиванием в офлайн режиме и многим другим. Отменить можно в любое время."' 
    $ru_translate20 = '"Lyrics provided by [{]0[}]"', '"Тексты песен предоставлены {0}"' 
    $ru_translate24 = '"Add to another playlist"', '"Добавить в другой плейлист"' 
    $ru_translate25 = '"Offline storage location"', '"Хранилище скачанных треков"' 
    $ru_translate26 = '"Change location"', '"Изменить место"' 
    $ru_translate27 = '"Line breaks aren.t supported in the description."', '"В описании не поддерживаются разрывы строк."' 
    $ru_translate29 = '"Press save to keep changes you.ve made."', '"Нажмите «Сохранить», чтобы сохранить внесенные изменения."' 
    $ru_translate30 = '"No internet connection found. Changes to description and image will not be saved."', '"Подключение к интернету не найдено. Изменения в описании и изображении не будут сохранены."' 
    $ru_translate31 = '"Image too large. Please select an image below 4MB."', '"Изображение слишком большое. Пожалуйста, выберите изображение размером менее 4 МБ."' 
    $ru_translate32 = '"Image too small. Images must be at least [{]0[}]x[{]1[}]."', '"Изображение слишком маленькое. Изображения должны быть не менее {0}x{1}."' 
    $ru_translate33 = '"Failed to upload image. Please try again."', '"Не удалось загрузить изображение. Пожалуйста, попробуйте снова."' 
    $ru_translate36 = '"Description"', '"Описание"' 
    $ru_translate38 = '"Change photo"', '"Сменить изображение"' 
    $ru_translate39 = '"Remove photo"', '"Удалить изображение"' 
    $ru_translate40 = '"Name"', '"Имя"' 
    $ru_translate42 = '"Change speed"', '"Изменение скорости"' 
    $ru_translate43 = '"You need to be at least 19 years old to listen to explicit content marked with"', '"Вам должно быть не менее 19 лет, чтобы слушать непристойный контент, помеченный значком"' 
    $ru_translate45 = '"Add to this playlist"', '"Добавить в этот плейлист"' 
    $ru_translate46 = '"Retrying in [{]0[}]..."', '"Повторная попытка в {0}..."' 
    $ru_translate47 = '"Couldn.t connect to Spotify."', '"Не удалось подключиться к Spotify."' 
    $ru_translate48 = '"Reconnecting..."', '"Повторное подключение..."' 
    $ru_translate49 = '"No connection"', '"Нет соединения"' 
    $ru_translate50 = '"Character counter"', '"Счетчик символов"' 
    $ru_translate51 = '"Toggle lightsaber hilt. Current is [{]0[}]."', '"Переключить рукоять светового меча. Текущий {0}."' 
    $ru_translate52 = '"Song not available"', '"Песня недоступна"' 
    $ru_translate53 = '"The song you.re trying to listen to is not available in HiFi at this time."', '"Песня, которую вы пытаетесь прослушать, в настоящее время недоступна в HiFi."' 
    $ru_translate54 = '"Current audio quality:"', '"Текущее качество звука:"' 
    $ru_translate55 = '"Network connection"', '"Подключение к сети"' 
    $ru_translate56 = '"Good"', '"Хорошее"' 
    $ru_translate57 = '"Poor"', '"Плохое"' 
    $ru_translate58 = '"Yes"', '"Да"' 
    $ru_translate59 = '"No"', '"Нет"' 
    $ru_translate62 = '"Your Location"', '"Ваше местоположение"'  

    if ($xpui_ru -match $ru_translate1[0]) { $xpui_ru = $xpui_ru -replace $ru_translate1[0], $ru_translate1[1] } else { Write-Host "Не нашел " -ForegroundColor red -NoNewline; Write-Host "переменную `$ru_translate1[0] в ru.json" }
    if ($xpui_ru -match $ru_translate2[0]) { $xpui_ru = $xpui_ru -replace $ru_translate2[0], $ru_translate2[1] } else { Write-Host "Не нашел " -ForegroundColor red -NoNewline; Write-Host "переменную `$ru_translate2[0] в ru.json" }
    if ($xpui_ru -match $ru_translate3[0]) { $xpui_ru = $xpui_ru -replace $ru_translate3[0], $ru_translate3[1] } else { Write-Host "Не нашел " -ForegroundColor red -NoNewline; Write-Host "переменную `$ru_translate3[0] в ru.json" }
    if ($xpui_ru -match $ru_translate4[0]) { $xpui_ru = $xpui_ru -replace $ru_translate4[0], $ru_translate4[1] } else { Write-Host "Не нашел " -ForegroundColor red -NoNewline; Write-Host "переменную `$ru_translate4[0] в ru.json" }
    if ($xpui_ru -match $ru_translate5[0]) { $xpui_ru = $xpui_ru -replace $ru_translate5[0], $ru_translate5[1] } else { Write-Host "Не нашел " -ForegroundColor red -NoNewline; Write-Host "переменную `$ru_translate5[0] в ru.json" }
    if ($xpui_ru -match $ru_translate13[0]) { $xpui_ru = $xpui_ru -replace $ru_translate13[0], $ru_translate13[1] } else { Write-Host "Не нашел " -ForegroundColor red -NoNewline; Write-Host "переменную `$ru_translate13[0] в ru.json" }
    if ($xpui_ru -match $ru_translate16[0]) { $xpui_ru = $xpui_ru -replace $ru_translate16[0], $ru_translate16[1] } else { Write-Host "Не нашел " -ForegroundColor red -NoNewline; Write-Host "переменную `$ru_translate16[0] в ru.json" }
    if ($xpui_ru -match $ru_translate17[0]) { $xpui_ru = $xpui_ru -replace $ru_translate17[0], $ru_translate17[1] } else { Write-Host "Не нашел " -ForegroundColor red -NoNewline; Write-Host "переменную `$ru_translate17[0] в ru.json" }
    if ($xpui_ru -match $ru_translate20[0]) { $xpui_ru = $xpui_ru -replace $ru_translate20[0], $ru_translate20[1] } else { Write-Host "Не нашел " -ForegroundColor red -NoNewline; Write-Host "переменную `$ru_translate20[0] в ru.json" }
    if ($xpui_ru -match $ru_translate24[0]) { $xpui_ru = $xpui_ru -replace $ru_translate24[0], $ru_translate24[1] } else { Write-Host "Не нашел " -ForegroundColor red -NoNewline; Write-Host "переменную `$ru_translate24[0] в ru.json" }
    if ($xpui_ru -match $ru_translate25[0]) { $xpui_ru = $xpui_ru -replace $ru_translate25[0], $ru_translate25[1] } else { Write-Host "Не нашел " -ForegroundColor red -NoNewline; Write-Host "переменную `$ru_translate25[0] в ru.json" }
    if ($xpui_ru -match $ru_translate26[0]) { $xpui_ru = $xpui_ru -replace $ru_translate26[0], $ru_translate26[1] } else { Write-Host "Не нашел " -ForegroundColor red -NoNewline; Write-Host "переменную `$ru_translate26[0] в ru.json" }
    if ($xpui_ru -match $ru_translate27[0]) { $xpui_ru = $xpui_ru -replace $ru_translate27[0], $ru_translate27[1] } else { Write-Host "Не нашел " -ForegroundColor red -NoNewline; Write-Host "переменную `$ru_translate27[0] в ru.json" }
    if ($xpui_ru -match $ru_translate29[0]) { $xpui_ru = $xpui_ru -replace $ru_translate29[0], $ru_translate29[1] } else { Write-Host "Не нашел " -ForegroundColor red -NoNewline; Write-Host "переменную `$ru_translate29[0] в ru.json" }
    if ($xpui_ru -match $ru_translate30[0]) { $xpui_ru = $xpui_ru -replace $ru_translate30[0], $ru_translate30[1] } else { Write-Host "Не нашел " -ForegroundColor red -NoNewline; Write-Host "переменную `$ru_translate30[0] в ru.json" }
    if ($xpui_ru -match $ru_translate31[0]) { $xpui_ru = $xpui_ru -replace $ru_translate31[0], $ru_translate31[1] } else { Write-Host "Не нашел " -ForegroundColor red -NoNewline; Write-Host "переменную `$ru_translate31[0] в ru.json" }
    if ($xpui_ru -match $ru_translate32[0]) { $xpui_ru = $xpui_ru -replace $ru_translate32[0], $ru_translate32[1] } else { Write-Host "Не нашел " -ForegroundColor red -NoNewline; Write-Host "переменную `$ru_translate32[0] в ru.json" }
    if ($xpui_ru -match $ru_translate33[0]) { $xpui_ru = $xpui_ru -replace $ru_translate33[0], $ru_translate33[1] } else { Write-Host "Не нашел " -ForegroundColor red -NoNewline; Write-Host "переменную `$ru_translate33[0] в ru.json" }
    if ($xpui_ru -match $ru_translate36[0]) { $xpui_ru = $xpui_ru -replace $ru_translate36[0], $ru_translate36[1] } else { Write-Host "Не нашел " -ForegroundColor red -NoNewline; Write-Host "переменную `$ru_translate36[0] в ru.json" }
    if ($xpui_ru -match $ru_translate38[0]) { $xpui_ru = $xpui_ru -replace $ru_translate38[0], $ru_translate38[1] } else { Write-Host "Не нашел " -ForegroundColor red -NoNewline; Write-Host "переменную `$ru_translate38[0] в ru.json" }
    if ($xpui_ru -match $ru_translate39[0]) { $xpui_ru = $xpui_ru -replace $ru_translate39[0], $ru_translate39[1] } else { Write-Host "Не нашел " -ForegroundColor red -NoNewline; Write-Host "переменную `$ru_translate39[0] в ru.json" }
    if ($xpui_ru -match $ru_translate40[0]) { $xpui_ru = $xpui_ru -replace $ru_translate40[0], $ru_translate40[1] } else { Write-Host "Не нашел " -ForegroundColor red -NoNewline; Write-Host "переменную `$ru_translate40[0] в ru.json" }
    if ($xpui_ru -match $ru_translate42[0]) { $xpui_ru = $xpui_ru -replace $ru_translate42[0], $ru_translate42[1] } else { Write-Host "Не нашел " -ForegroundColor red -NoNewline; Write-Host "переменную `$ru_translate42[0] в ru.json" }
    if ($xpui_ru -match $ru_translate43[0]) { $xpui_ru = $xpui_ru -replace $ru_translate43[0], $ru_translate43[1] } else { Write-Host "Не нашел " -ForegroundColor red -NoNewline; Write-Host "переменную `$ru_translate43[0] в ru.json" }
    if ($xpui_ru -match $ru_translate45[0]) { $xpui_ru = $xpui_ru -replace $ru_translate45[0], $ru_translate45[1] } else { Write-Host "Не нашел " -ForegroundColor red -NoNewline; Write-Host "переменную `$ru_translate45[0] в ru.json" }
    if ($xpui_ru -match $ru_translate46[0]) { $xpui_ru = $xpui_ru -replace $ru_translate46[0], $ru_translate46[1] } else { Write-Host "Не нашел " -ForegroundColor red -NoNewline; Write-Host "переменную `$ru_translate46[0] в ru.json" }
    if ($xpui_ru -match $ru_translate47[0]) { $xpui_ru = $xpui_ru -replace $ru_translate47[0], $ru_translate47[1] } else { Write-Host "Не нашел " -ForegroundColor red -NoNewline; Write-Host "переменную `$ru_translate47[0] в ru.json" }
    if ($xpui_ru -match $ru_translate48[0]) { $xpui_ru = $xpui_ru -replace $ru_translate48[0], $ru_translate48[1] } else { Write-Host "Не нашел " -ForegroundColor red -NoNewline; Write-Host "переменную `$ru_translate48[0] в ru.json" }
    if ($xpui_ru -match $ru_translate49[0]) { $xpui_ru = $xpui_ru -replace $ru_translate49[0], $ru_translate49[1] } else { Write-Host "Не нашел " -ForegroundColor red -NoNewline; Write-Host "переменную `$ru_translate49[0] в ru.json" }
    if ($xpui_ru -match $ru_translate50[0]) { $xpui_ru = $xpui_ru -replace $ru_translate50[0], $ru_translate50[1] } else { Write-Host "Не нашел " -ForegroundColor red -NoNewline; Write-Host "переменную `$ru_translate50[0] в ru.json" }
    if ($xpui_ru -match $ru_translate51[0]) { $xpui_ru = $xpui_ru -replace $ru_translate51[0], $ru_translate51[1] } else { Write-Host "Не нашел " -ForegroundColor red -NoNewline; Write-Host "переменную `$ru_translate51[0] в ru.json" }
    if ($xpui_ru -match $ru_translate52[0]) { $xpui_ru = $xpui_ru -replace $ru_translate52[0], $ru_translate52[1] } else { Write-Host "Не нашел " -ForegroundColor red -NoNewline; Write-Host "переменную `$ru_translate52[0] в ru.json" }
    if ($xpui_ru -match $ru_translate53[0]) { $xpui_ru = $xpui_ru -replace $ru_translate53[0], $ru_translate53[1] } else { Write-Host "Не нашел " -ForegroundColor red -NoNewline; Write-Host "переменную `$ru_translate53[0] в ru.json" }
    if ($xpui_ru -match $ru_translate54[0]) { $xpui_ru = $xpui_ru -replace $ru_translate54[0], $ru_translate54[1] } else { Write-Host "Не нашел " -ForegroundColor red -NoNewline; Write-Host "переменную `$ru_translate54[0] в ru.json" }
    if ($xpui_ru -match $ru_translate55[0]) { $xpui_ru = $xpui_ru -replace $ru_translate55[0], $ru_translate55[1] } else { Write-Host "Не нашел " -ForegroundColor red -NoNewline; Write-Host "переменную `$ru_translate55[0] в ru.json" }
    if ($xpui_ru -match $ru_translate56[0]) { $xpui_ru = $xpui_ru -replace $ru_translate56[0], $ru_translate56[1] } else { Write-Host "Не нашел " -ForegroundColor red -NoNewline; Write-Host "переменную `$ru_translate56[0] в ru.json" }
    if ($xpui_ru -match $ru_translate57[0]) { $xpui_ru = $xpui_ru -replace $ru_translate57[0], $ru_translate57[1] } else { Write-Host "Не нашел " -ForegroundColor red -NoNewline; Write-Host "переменную `$ru_translate57[0] в ru.json" }
    if ($xpui_ru -match $ru_translate58[0]) { $xpui_ru = $xpui_ru -replace $ru_translate58[0], $ru_translate58[1] } else { Write-Host "Не нашел " -ForegroundColor red -NoNewline; Write-Host "переменную `$ru_translate58[0] в ru.json" }
    if ($xpui_ru -match $ru_translate59[0]) { $xpui_ru = $xpui_ru -replace $ru_translate59[0], $ru_translate59[1] } else { Write-Host "Не нашел " -ForegroundColor red -NoNewline; Write-Host "переменную `$ru_translate59[0] в ru.json" }
    if ($xpui_ru -match $ru_translate62[0]) { $xpui_ru = $xpui_ru -replace $ru_translate62[0], $ru_translate62[1] } else { Write-Host "Не нашел " -ForegroundColor red -NoNewline; Write-Host "переменную `$ru_translate62[0] в ru.json" }
    $xpui_ru
}

Write-Host 'Модифицирую Spotify...'`n

# Модифицируем файлы
$patchFiles = "$PWD\chrome_elf.dll", "$PWD\config.ini"
Copy-Item -LiteralPath $patchFiles -Destination "$spotifyDirectory"

$tempDirectory = $PWD
Pop-Location

Start-Sleep -Milliseconds 200
Remove-Item -Recurse -LiteralPath $tempDirectory 

$xpui_spa_patch = "$env:APPDATA\Spotify\Apps\xpui.spa"
$xpui_js_patch = "$env:APPDATA\Spotify\Apps\xpui\xpui.js"
$xpui_css_patch = "$env:APPDATA\Spotify\Apps\xpui\xpui.css"
$xpui_lic_patch = "$env:APPDATA\Spotify\Apps\xpui\licenses.html"
$xpui_ru_patch = "$env:APPDATA\Spotify\Apps\xpui\i18n\ru.json"
$test_spa = Test-Path -Path $env:APPDATA\Spotify\Apps\xpui.spa
$test_js = Test-Path -Path $xpui_js_patch
$xpui_js_bak_patch = "$env:APPDATA\Spotify\Apps\xpui\xpui.js.bak"
$xpui_css_bak_patch = "$env:APPDATA\Spotify\Apps\xpui\xpui.css.bak"
$xpui_lic_bak_patch = "$env:APPDATA\Spotify\Apps\xpui\licenses.html.bak"
$xpui_ru_bak_patch = "$env:APPDATA\Spotify\Apps\xpui\i18n\ru.json.bak"
$spotify_exe_bak_patch = "$env:APPDATA\Spotify\Spotify.bak"


if ($test_spa -and $test_js) {
    Write-Host "Ошибка" -ForegroundColor Red
    Write-Host "Расположение файлов Spotify нарушено, удалите клиент и снова запустите скрипт."
    Write-Host "Выполнение остановлено."
    exit
}

if (Test-Path $xpui_js_patch) {
    Write-Host "Обнаружен Spicetify"`n

    # Удалить все файлы кроме "en", "ru" и "__longest"
    $patch_lang = "$env:APPDATA\Spotify\Apps\xpui\i18n"

    Remove-Item $patch_lang -Exclude *en*, *ru*, *__longest* -Recurse

    $reader = New-Object -TypeName System.IO.StreamReader -ArgumentList $xpui_js_patch
    $xpui_test_js = $reader.ReadToEnd()
    $reader.Close()
        
    If ($xpui_test_js -match 'patched by spotx') {

        $test_xpui_js_bak = Test-Path -Path $xpui_js_bak_patch
        $test_xpui_css_bak = Test-Path -Path $xpui_css_bak_patch
        $test_xpui_lic_bak = Test-Path -Path $xpui_lic_bak_patch
        $test_xpui_ru_bak = Test-Path -Path $xpui_ru_bak_patch
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
            if ($test_xpui_ru_bak) {
                Remove-Item $xpui_ru_patch -Recurse -Force
                Rename-Item $xpui_ru_bak_patch $xpui_ru_patch
            }
            if ($test_spotify_exe_bak) {
                Remove-Item $spotifyExecutable -Recurse -Force
                Rename-Item $spotify_exe_bak_patch $spotifyExecutable
            }

        }
        else {
            Write-Host "SpotX уже был установлен, xpui.js.bak и xpui.css.bak не найдены. `nУдалите клиент Spotify и снова запустите Install_Rus.bat, скрипт остановлен."`n
            exit
        }

    }

    Copy-Item $xpui_js_patch $xpui_js_bak_patch
    Copy-Item $xpui_css_patch $xpui_css_bak_patch
    Copy-Item $xpui_lic_patch $xpui_lic_bak_patch
    Copy-Item $xpui_ru_patch $xpui_ru_bak_patch

    $reader = New-Object -TypeName System.IO.StreamReader -ArgumentList $xpui_js_patch
    $xpui_js = $reader.ReadToEnd()
    $reader.Close()

    # Отключить подкасты
    if ($Podcasts_off) { $xpui_js = OffPodcasts }
    
    # Активация полноэкранного режима, а также удаление кнопки и меню "Перейти на Premium",
    # отключиние спонсорской рекламы в некоторых плейлистах, удаление пустого рекламного блока.
    $xpui_js = OffAdsOnFullscreen
       
    # Экспереметальные функции
    $xpui_js = ExpFeature

    # Удалить из xpui.js все языки кроме En и Ru
    $xpui_js = OffRujs

    $writer = New-Object System.IO.StreamWriter -ArgumentList $xpui_js_patch
    $writer.BaseStream.SetLength(0)
    $writer.Write($xpui_js)
    $writer.Write([System.Environment]::NewLine + '// Patched by SpotX') 
    $writer.Close()  

    # Русский доперевод
    $file_ru = get-item $env:APPDATA\Spotify\Apps\xpui\i18n\ru.json
    $reader = New-Object -TypeName System.IO.StreamReader -ArgumentList $file_ru
    $xpui_ru = $reader.ReadToEnd()
    $reader.Close()
    $xpui_ru = RuTranslate
    $writer = New-Object System.IO.StreamWriter -ArgumentList $file_ru
    $writer.BaseStream.SetLength(0)
    $writer.Write($xpui_ru)
    $writer.Close()  

    # xpui.css
    $file_xpui_css = get-item $env:APPDATA\Spotify\Apps\xpui\xpui.css
    $reader = New-Object -TypeName System.IO.StreamReader -ArgumentList $file_xpui_css
    $xpuiContents_xpui_css = $reader.ReadToEnd()
    $reader.Close()

    $writer = New-Object System.IO.StreamWriter -ArgumentList $file_xpui_css
    $writer.BaseStream.SetLength(0)
    $writer.Write($xpuiContents_xpui_css)
    # Скрыть иконку скачивание на разных страницах
    $writer.Write([System.Environment]::NewLine + ' .BKsbV2Xl786X9a09XROH{display:none}')
    # Скрыть подменю "загрузка"
    $writer.Write([System.Environment]::NewLine + ' button.wC9sIed7pfp47wZbmU6m.pzkhLqffqF_4hucrVVQA{display:none}')
    # Скрыть иконку соавторов
    $writer.Write([System.Environment]::NewLine + ' .X1lXSiVj0pzhQCUo_72A{display:none}')
    # Скрыть сломанное меню подкастов
    if ($podcasts_off) { 
        $writer.Write([System.Environment]::NewLine + ' li.OEFWODerafYHGp09iLlA [href="/collection/podcasts"]{display:none}')
    }
    $writer.Close()

    # Минификация licenses.html
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

    # Делаем резервную копию xpui.spa если он оригинальный
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
            Write-Host "SpotX уже был установлен, xpui.bak не найден. `nУдалите клиент Spotify и снова запустите Install_Rus.bat, скрипт остановлен."`n
            exit
        }
    }
    $zip.Dispose()
    Copy-Item $xpui_spa_patch $env:APPDATA\Spotify\Apps\xpui.bak


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


    Add-Type -Assembly 'System.IO.Compression.FileSystem'
    $zip = [System.IO.Compression.ZipFile]::Open($xpui_spa_patch, 'update')
    
    # xpui.js
    $entry_xpui = $zip.GetEntry('xpui.js')
    $reader = New-Object System.IO.StreamReader($entry_xpui.Open())
    $xpui_js = $reader.ReadToEnd()
    $reader.Close()

    # Отключить подкасты
    if ($podcasts_off) { $xpui_js = OffPodcasts }
    
    # Активация полноэкранного режима, а также удаление кнопки и меню "Перейти на Premium",
    # отключиние спонсорской рекламы в некоторых плейлистах, удаление пустого рекламного блока.
    $xpui_js = OffAdsOnFullscreen
       
    # Экспереметальные функции
    $xpui_js = ExpFeature

    # Удалить из xpui.js все языки кроме En и Ru
    $xpui_js = OffRujs

    # Отключение логов
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
        <# Отключение Sentry" #> -replace "prototype\.bindClient=function\(\w+\)\{", '${0}return;'
    $writer = New-Object System.IO.StreamWriter($entry_vendor_xpui.Open())
    $writer.BaseStream.SetLength(0)
    $writer.Write($xpuiContents_vendor)
    $writer.Close()

    # js all
    $zip.Entries | Where-Object FullName -like '*.js' | ForEach-Object {
        $readerjs = New-Object System.IO.StreamReader($_.Open())
        $xpuiContents_js = $readerjs.ReadToEnd()
        $readerjs.Close()

        # минификация js 
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
    # Скрыть иконку скачивание на разных страницах
    $writer.Write([System.Environment]::NewLine + ' .BKsbV2Xl786X9a09XROH {display: none}')
    # Скрыть подменю "загрузка"
    $writer.Write([System.Environment]::NewLine + ' button.wC9sIed7pfp47wZbmU6m.pzkhLqffqF_4hucrVVQA {display: none}')
    # Скрыть иконку соавторов
    $writer.Write([System.Environment]::NewLine + ' .X1lXSiVj0pzhQCUo_72A{display:none}')
    # Скрыть сломанное меню подкастов
    if ($podcasts_off) { 
        $writer.Write([System.Environment]::NewLine + ' li.OEFWODerafYHGp09iLlA [href="/collection/podcasts"] {display: none}')
    }
    $writer.Close()

    # *.Css
    $zip.Entries | Where-Object FullName -like '*.css' | ForEach-Object {
        $readercss = New-Object System.IO.StreamReader($_.Open())
        $xpuiContents_css = $readercss.ReadToEnd()
        $readercss.Close()

        $xpuiContents_css = $xpuiContents_css `
            <# удаление RTL правил #>`
            -replace "}\[dir=ltr\]\s?([.a-zA-Z\d[_]+?,\[dir=ltr\])", '}[dir=str] $1' -replace "}\[dir=ltr\]\s?", "} " -replace "html\[dir=ltr\]", "html" `
            -replace ",\s?\[dir=rtl\].+?(\{.+?\})", '$1' -replace "[\w\-\.]+\[dir=rtl\].+?\{.+?\}", "" -replace "\}\[lang=ar\].+?\{.+?\}", "}" `
            -replace "\}\[dir=rtl\].+?\{.+?\}", "}" -replace "\}html\[dir=rtl\].+?\{.+?\}", "}" -replace "\}html\[lang=ar\].+?\{.+?\}", "}" `
            -replace "\[lang=ar\].+?\{.+?\}", "" -replace "html\[dir=rtl\].+?\{.+?\}", "" -replace "html\[lang=ar\].+?\{.+?\}", "" `
            -replace "\[dir=rtl\].+?\{.+?\}", "" -replace "\[dir=str\]", "[dir=ltr]" `
            <# минификация css #>`
            -replace "[/]\*([^*]|[\r\n]|(\*([^/]|[\r\n])))*\*[/]", "" -replace "[/][/]#\s.*", "" -replace "\r?\n(?!\(1|\d)", ""
    
        $writer = New-Object System.IO.StreamWriter($_.Open())
        $writer.BaseStream.SetLength(0)
        $writer.Write($xpuiContents_css)
        $writer.Close()
    }
    
    # Минификация licenses.html
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

    # Минификация blank.html
    $entry_blank_html = $zip.GetEntry('blank.html')
    $reader = New-Object System.IO.StreamReader($entry_blank_html.Open())
    $xpuiContents_html_blank = $reader.ReadToEnd()
    $reader.Close()

    $html_min1 = "  "
    $html_min2 = "(?m)(^\s*\r?\n)"
    $html_min3 = "\r?\n(?!\(1|\d)"
    if ($xpuiContents_html_blank -match $html_min1) { $xpuiContents_html_blank = $xpuiContents_html_blank -replace $html_min1, "" } else { Write-Host "Не нашел " -ForegroundColor red -NoNewline; Write-Host "переменную `$html_min1 в html" }
    if ($xpuiContents_html_blank -match $html_min2) { $xpuiContents_html_blank = $xpuiContents_html_blank -replace $html_min2, "" } else { Write-Host "Не нашел " -ForegroundColor red -NoNewline; Write-Host "переменную `$html_min2 в html" }
    if ($xpuiContents_html_blank -match $html_min3) { $xpuiContents_html_blank = $xpuiContents_html_blank -replace $html_min3, "" } else { Write-Host "Не нашел " -ForegroundColor red -NoNewline; Write-Host "переменную `$html_min3 в html" }

    $xpuiContents_html_blank = $xpuiContents_html_blank
    $writer = New-Object System.IO.StreamWriter($entry_blank_html.Open())
    $writer.BaseStream.SetLength(0)
    $writer.Write($xpuiContents_html_blank)
    $writer.Close()
    
    # Доперевод файла ru.json
    $zip.Entries | Where-Object FullName -like '*ru.json' | ForEach-Object {
        $readerjson = New-Object System.IO.StreamReader($_.Open())
        $xpui_ru = $readerjson.ReadToEnd()
        $readerjson.Close()

    
        $xpui_ru = RuTranslate

        $writer = New-Object System.IO.StreamWriter($_.Open())
        $writer.BaseStream.SetLength(0)
        $writer.Write($xpui_ru)
        $writer.Close()
    }

    # Json
    $zip.Entries | Where-Object FullName -like '*.json' | ForEach-Object {
        $readerjson = New-Object System.IO.StreamReader($_.Open())
        $xpuiContents_json = $readerjson.ReadToEnd()
        $readerjson.Close()

        # json минификация
        $xpuiContents_json = $xpuiContents_json `
            -replace "  ", "" -replace "    ", "" -replace '": ', '":' -replace "\r?\n(?!\(1|\d)", "" 

        $writer = New-Object System.IO.StreamWriter($_.Open())
        $writer.BaseStream.SetLength(0)
        $writer.Write($xpuiContents_json)
        $writer.Close()       
    }
    $zip.Dispose()   
}

# Удалить все файлы кроме "en" и "ru" 
$patch_lang = "$spotifyDirectory\locales"

Remove-Item $patch_lang -Exclude *en*, *ru* -Recurse

# Ярлык Spotify.lnk
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

# Блокировка обновлений
$ErrorActionPreference = 'SilentlyContinue'
$update_test_exe = Test-Path -Path $spotifyExecutable

if ($block_update) {

    if ($update_test_exe) {
        $exe = "$env:APPDATA\Spotify\Spotify.exe"
        $exe_bak = "$env:APPDATA\Spotify\Spotify.bak"
        $ANSI = [Text.Encoding]::GetEncoding(1251)
        $old = [IO.File]::ReadAllText($exe, $ANSI)

        if ($old -match "(?<=wg:\/\/desktop-update\/.)7(\/update)") {
            Write-Host "Обновления Spotify уже заблокированы"`n
        }
        elseif ($old -match "(?<=wg:\/\/desktop-update\/.)2(\/update)") {
            copy-Item $exe $exe_bak
            $new = $old -replace "(?<=wg:\/\/desktop-update\/.)2(\/update)", '7/update'
            [IO.File]::WriteAllText($exe, $new, $ANSI)
        }
        else {
            Write-Host "Не удалось заблокировать обновления"`n -ForegroundColor Red
        }
    }
    else {
        Write-Host "Spotify.exe не найден"`n -ForegroundColor Red 
    }
}

# Автоматическая очистка кеша
if ($cache_install) {
    Start-Sleep -Milliseconds 200
    New-Item -Path $env:APPDATA\Spotify\ -Name "cache" -ItemType "directory" | Out-Null

    # Скачать скрипт кеша
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

        Write-Host "Установка завершена"`n -ForegroundColor Green
        exit
    }
}

Write-Host "Установка завершена"`n -ForegroundColor Green
exit