# Ignore errors from `Stop-Process`
$PSDefaultParameterValues['Stop-Process:ErrorAction'] = 'SilentlyContinue'

# Check Tls12
$tsl_check = [Net.ServicePointManager]::SecurityProtocol 
if (!($tsl_check -match '^tls12$' )) {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
}


Write-Host "********************"
Write-Host "Автор: " -NoNewline
Write-Host "@Nuzair46" -ForegroundColor DarkYellow
Write-Host "Модификация: " -NoNewline
Write-Host  "@Amd64fox" -ForegroundColor DarkYellow
Write-Host "********************"


$SpotifyDirectory = "$env:APPDATA\Spotify"
$SpotifyExecutable = "$SpotifyDirectory\Spotify.exe"


Stop-Process -Name Spotify
Stop-Process -Name SpotifyWebHelper

if ($PSVersionTable.PSVersion.Major -ge 7) {
    Import-Module Appx -UseWindowsPowerShell
}
# Check version Windows
$win_os = (get-itemproperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name ProductName).ProductName
$win11 = $win_os -match "\windows 11\b"
$win10 = $win_os -match "\windows 10\b"
$win8_1 = $win_os -match "\windows 8.1\b"
$win8 = $win_os -match "\windows 8\b"
$win7 = $win_os -match "\windows 7\b"


if ($win11 -or $win10 -or $win8_1 -or $win8) {


    # Check and del Windows Store
    if (Get-AppxPackage -Name SpotifyAB.SpotifyMusic) {
        Write-Host @'
Обнаружена версия Spotify из Microsoft Store, которая не поддерживается.
'@`n
        $ch = Read-Host -Prompt "Хотите удалить Spotify Microsoft Store ? (Y/N) "
        if ($ch -eq 'y') {
            Write-Host @'
Удаление Spotify.
'@`n
            Get-AppxPackage -Name SpotifyAB.SpotifyMusic | Remove-AppxPackage
        }
        else {
            Write-Host @'
Выход...
'@`n
            Pause 
            exit
        }
    }
}


Push-Location -LiteralPath $env:TEMP
try {
    # Unique directory name based on time
    New-Item -Type Directory -Name "BlockTheSpot-$(Get-Date -UFormat '%Y-%m-%d_%H-%M-%S')" `
  | Convert-Path `
  | Set-Location
}
catch {
    Write-Output ''
    Pause
    exit
}


Write-Host 'Загружаю последний патч BTS...'`n

$webClient = New-Object -TypeName System.Net.WebClient
try {

    $webClient.DownloadFile(
        # Remote file URL
        'https://github.com/mrpond/BlockTheSpot/releases/latest/download/chrome_elf.zip',
        # Local file path
        "$PWD\chrome_elf.zip"
    )
}
catch {
    Write-Output ''
    Sleep
}

Expand-Archive -Force -LiteralPath "$PWD\chrome_elf.zip" -DestinationPath $PWD
Remove-Item -LiteralPath "$PWD\chrome_elf.zip"

$spotifyInstalled = (Test-Path -LiteralPath $SpotifyExecutable)
if (-not $spotifyInstalled) {
    
    try {
        $webClient.DownloadFile(
            # Remote file URL
            'https://download.scdn.co/SpotifySetup.exe',
            # Local file path
            "$PWD\SpotifySetup.exe"
        )
    }
    catch {
        Write-Output ''
        Pause
        exit
    }
    mkdir $SpotifyDirectory >$null 2>&1

    # Check version Spotify
    $version_client_check = (get-item $PWD\SpotifySetup.exe).VersionInfo.ProductVersion
    $version_client = $version_client_check -split '.\w\w\w\w\w\w\w\w\w'
   
    Write-Host "Загружаю и устанавливаю Spotify " -NoNewline
    Write-Host  $version_client -ForegroundColor Green
    Write-Host "Пожалуйста подождите..."

    Start-Process -FilePath $PWD\SpotifySetup.exe; wait-process -name SpotifySetup

  
  
    Stop-Process -Name Spotify >$null 2>&1
    Stop-Process -Name SpotifyWebHelper >$null 2>&1
    Stop-Process -Name SpotifyFullSetup >$null 2>&1


    $ErrorActionPreference = 'SilentlyContinue'  # Команда гасит легкие ошибки

    if ($win7) {
        get-childitem -path "$env:LOCALAPPDATA\Microsoft\Windows\Temporary Internet Files\" -Recurse -Force -Filter  "SpotifyFullSetup*" | remove-item  -Force
    }
    if ($win10) {
        get-childitem -path "$env:LOCALAPPDATA\Microsoft\Windows\INetCache\" -Recurse -Force -Filter  "SpotifyFullSetup*" | remove-item  -Force
    
    }
    
}

if (!(test-path $SpotifyDirectory/chrome_elf.dll.bak)) {
    move $SpotifyDirectory\chrome_elf.dll $SpotifyDirectory\chrome_elf.dll.bak >$null 2>&1
}

Write-Host 'Модифицирую Spotify...'
$patchFiles = "$PWD\chrome_elf.dll", "$PWD\config.ini"
Copy-Item -LiteralPath $patchFiles -Destination "$SpotifyDirectory"

$tempDirectory = $PWD
Pop-Location


sleep -Milliseconds 200
Remove-Item -Recurse -LiteralPath $tempDirectory 




# Removing an empty block and button

if (!(test-path $env:APPDATA\Spotify\Apps\xpui.bak)) {
    Copy $env:APPDATA\Spotify\Apps\xpui.spa $env:APPDATA\Spotify\Apps\xpui.bak
}

Rename-Item -path $env:APPDATA\Spotify\Apps\xpui.spa -NewName $env:APPDATA\Spotify\Apps\xpui.zip
Expand-Archive $env:APPDATA\Spotify\Apps\xpui.zip -DestinationPath $env:APPDATA\Spotify\Apps\temporary
$file_js = Get-Content $env:APPDATA\Spotify\Apps\temporary\xpui.js -Raw
If (!($file_js -match 'patched by spotx')) {
    $new_js = $file_js -replace ".........................................Z.UpgradeButton.......", "" -replace 'e.ads.leaderboard.isEnabled', 'e.ads.leaderboard.isDisabled'
    Set-Content -Path $env:APPDATA\Spotify\Apps\temporary\xpui.js -Force -Value $new_js
    add-content -Path $env:APPDATA\Spotify\Apps\temporary\xpui.js -Value '// Patched by SpotX' -passthru | Out-Null
    $contentjs = [System.IO.File]::ReadAllText("$env:APPDATA\Spotify\Apps\temporary\xpui.js")
    $contentjs = $contentjs.Trim()
    [System.IO.File]::WriteAllText("$env:APPDATA\Spotify\Apps\temporary\xpui.js", $contentjs)
    Compress-Archive -Path $env:APPDATA\Spotify\Apps\temporary\xpui.js -Update -DestinationPath $env:APPDATA\Spotify\Apps\xpui.zip
}


# Remove "Upgrade to premium" menu
$file_css = Get-Content $env:APPDATA\Spotify\Apps\temporary\xpui.css -Raw
If (!($file_css -match 'patched by spotx')) {
    $new_css = $file_css -replace 'table{border-collapse:collapse;border-spacing:0}', 'table{border-collapse:collapse;border-spacing:0}[target="_blank"]{display:none !important;}'
    Set-Content -Path $env:APPDATA\Spotify\Apps\temporary\xpui.css -Force -Value $new_css
    add-content -Path $env:APPDATA\Spotify\Apps\temporary\xpui.css -Value '/* Patched by SpotX */' -passthru | Out-Null
    $contentcss = [System.IO.File]::ReadAllText("$env:APPDATA\Spotify\Apps\temporary\xpui.css")
    $contentcss = $contentcss.Trim()
    [System.IO.File]::WriteAllText("$env:APPDATA\Spotify\Apps\temporary\xpui.css", $contentcss)
    Compress-Archive -Path $env:APPDATA\Spotify\Apps\temporary\xpui.css -Update -DestinationPath $env:APPDATA\Spotify\Apps\xpui.zip
}
Rename-Item -path $env:APPDATA\Spotify\Apps\xpui.zip -NewName $env:APPDATA\Spotify\Apps\xpui.spa
Remove-item $env:APPDATA\Spotify\Apps\temporary -Recurse

# Shortcut bug
If (!(Test-Path $env:USERPROFILE\Desktop\Spotify.lnk)) {
    $source = "$env:APPDATA\Spotify\Spotify.exe"
    $target = "$env:USERPROFILE\Desktop\Spotify.lnk"
    $WshShell = New-Object -comObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut($target)
    $Shortcut.TargetPath = $source
    $Shortcut.Save()
} 




# Block updates

$ErrorActionPreference = 'SilentlyContinue'  # Команда гасит легкие ошибки



$update_directory = Test-Path -Path $env:LOCALAPPDATA\Spotify 
$update_directory_file = Test-Path -Path $env:LOCALAPPDATA\Spotify\Update
$migrator_bak = Test-Path -Path $env:APPDATA\Spotify\SpotifyMigrator.bak  
$migrator_exe = Test-Path -Path $env:APPDATA\Spotify\SpotifyMigrator.exe
$Check_folder_file = Get-ItemProperty -Path $env:LOCALAPPDATA\Spotify\Update | SELECT Attributes 

$ch = Read-Host -Prompt "Хотите заблокировать обновления ? (Y/N), Хочу разблокировать (U)"
if ($ch -eq 'y') {



    # Если была установка клиенте 
    if (!($update_directory)) {

        # Создать папку Spotify в Local
        New-Item -Path $env:LOCALAPPDATA -Name "Spotify" -ItemType "directory" | Out-Null

        #Создать файл Update
        New-Item -Path $env:LOCALAPPDATA\Spotify\ -Name "Update" -ItemType "file" -Value "STOPIT" | Out-Null
        $file = Get-ItemProperty -Path $env:LOCALAPPDATA\Spotify\Update
        $file.Attributes = "ReadOnly", "System"
      
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


    # Если клиент уже был 
    If ($update_directory) {


        #Удалить папку Update если она есть.
        if ($Check_folder_file -match '\bDirectory\b') {  
            Remove-item $env:LOCALAPPDATA\Spotify\Update -Recurse -Force
        } 

        #Создать файл Update если его нет
        if (!($Check_folder_file -match '\bSystem\b' -and $Check_folder_file -match '\bReadOnly\b')) {  
            New-Item -Path $env:LOCALAPPDATA\Spotify\ -Name "Update" -ItemType "file" -Value "STOPIT" | Out-Null
            $file = Get-ItemProperty -Path $env:LOCALAPPDATA\Spotify\Update
            $file.Attributes = "ReadOnly", "System"
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

  
    Write-Host "Обновления успешно заблокированы" -ForegroundColor Green


}


if ($ch -eq 'n') {
    Write-Host "Оставлено без изменений" 
}



if ($ch -eq 'u') {

    
    If ($update_directory_file) {
        Remove-item $env:LOCALAPPDATA\Spotify\Update -Recurse -Force
    } 
    If ($migrator_bak -and $migrator_exe ) {
        Remove-item $env:APPDATA\Spotify\SpotifyMigrator.bak -Recurse -Force
    }
    if ($migrator_bak) {
        Rename-Item -path $env:APPDATA\Spotify\SpotifyMigrator.bak -NewName $env:APPDATA\Spotify\SpotifyMigrator.exe
    }
    Write-Host "Обновления разблокированы" -ForegroundColor Green
    

}
    

elseif (!($ch -eq 'n' -or $ch -eq 'y' -or $ch -eq 'u')) {
    Write-Host "Ой, неудачно" -ForegroundColor Red
    
}




# automatic cache clearing


$ch = Read-Host -Prompt "Хотите установить автоматическую очистку кеша ? (Y/N) Хочу удалить (U)"
if ($ch -eq 'y') {


    $test_cache_spotify_ps = Test-Path -Path $env:APPDATA\Spotify\cache-spotify.ps1
    $test_spotify_vbs = Test-Path -Path $env:APPDATA\Spotify\Spotify.vbs

    
    If ($test_cache_spotify_ps) {
        Remove-item $env:APPDATA\Spotify\cache-spotify.ps1 -Recurse -Force
    }
    If ($test_spotify_vbs) {
        Remove-item $env:APPDATA\Spotify\Spotify.vbs -Recurse -Force
    }
    sleep -Milliseconds 200

    # cache-spotify.ps1
    $webClient.DownloadFile('https://raw.githubusercontent.com/amd64fox/SpotX/main/cache-spotify.ps1', "$env:APPDATA\Spotify\cache-spotify.ps1")

    # Spotify.vbs
    $webClient.DownloadFile('https://raw.githubusercontent.com/amd64fox/SpotX/main/Spotify.vbs', "$env:APPDATA\Spotify\Spotify.vbs")

    # Spotify.lnk
    $source = "$env:APPDATA\Spotify\Spotify.vbs"
    $target = "$env:USERPROFILE\Desktop\Spotify.lnk"
    $WshShell = New-Object -comObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut($target)
    $Shortcut.IconLocation = "$env:APPDATA\Spotify\Spotify.exe"
    $Shortcut.TargetPath = $source
    $Shortcut.Save()

    $ch = Read-Host -Prompt "Файлы кэша, которые не использовались более XX дней, будут удалены.
    Пожалуйста, введите количество дней от 1 до 100"
    if ($ch -match "^[1-9][0-9]?$|^100$") {
        $file_cache_spotify_ps1 = Get-Content $env:APPDATA\Spotify\cache-spotify.ps1 -Raw
        $new_file_cache_spotify_ps1 = $file_cache_spotify_ps1 -replace 'seven', $ch -replace '-7', - $ch
        Set-Content -Path $env:APPDATA\Spotify\cache-spotify.ps1 -Force -Value $new_file_cache_spotify_ps1
        $contentcache_spotify_ps1 = [System.IO.File]::ReadAllText("$env:APPDATA\Spotify\cache-spotify.ps1")
        $contentcache_spotify_ps1 = $contentcache_spotify_ps1.Trim()
        [System.IO.File]::WriteAllText("$env:APPDATA\Spotify\cache-spotify.ps1", $contentcache_spotify_ps1)
        Write-Host "Скрипт для очистки кэша был успешно установлен" -ForegroundColor Green
        Write-Host "Установка завершена" -ForegroundColor Green
        exit
    }
    if (!($ch -match "^[1-9][0-9]?$|^100$")) {
        $ch = Read-Host -Prompt "Ой, неудачно, давайте попробуем еще раз
        Файлы кэша, которые не использовались более XX дней, будут удалены.
    Пожалуйста, введите количество дней от 1 до 100"
        if ($ch -match "^[1-9][0-9]?$|^100$") {
            $file_cache_spotify_ps1 = Get-Content $env:APPDATA\Spotify\cache-spotify.ps1 -Raw
            $new_file_cache_spotify_ps1 = $file_cache_spotify_ps1 -replace 'seven', $ch -replace '-7', - $ch
            Set-Content -Path $env:APPDATA\Spotify\cache-spotify.ps1 -Force -Value $new_file_cache_spotify_ps1
            $contentcache_spotify_ps1 = [System.IO.File]::ReadAllText("$env:APPDATA\Spotify\cache-spotify.ps1")
            $contentcache_spotify_ps1 = $contentcache_spotify_ps1.Trim()
            [System.IO.File]::WriteAllText("$env:APPDATA\Spotify\cache-spotify.ps1", $contentcache_spotify_ps1)
            Write-Host "Скрипт для очистки кэша был успешно установлен" -ForegroundColor Green
            Write-Host "Установка завершена" -ForegroundColor Green
            exit
        }
        else {
            Write-Host "Снова неудачно" -ForegroundColor Red
            Write-Host 'Пожалуйста, откройте файл cache-spotify.ps1 по этому пути "AppData\Roaming\Spotify" и введите своё кол-во дней вручную'
            Write-Host "Установка завершена" -ForegroundColor Green
            exit
        }

    }
    

}

if ($ch -eq 'n') {

    Write-Host "Установка завершена" -ForegroundColor Green

    exit
}
if ($ch -eq 'u') {

    $test_cache_spotify_ps = Test-Path -Path $env:APPDATA\Spotify\cache-spotify.ps1
    $test_spotify_vbs = Test-Path -Path $env:APPDATA\Spotify\Spotify.vbs

    If ($test_cache_spotify_ps -and $test_spotify_vbs) {
        Remove-item $env:APPDATA\Spotify\cache-spotify.ps1 -Recurse -Force
        Remove-item $env:APPDATA\Spotify\Spotify.vbs -Recurse -Force

        $source = "$env:APPDATA\Spotify\Spotify.exe"
        $target = "$env:USERPROFILE\Desktop\Spotify.lnk"
        $WshShell = New-Object -comObject WScript.Shell
        $Shortcut = $WshShell.CreateShortcut($target)
        $Shortcut.IconLocation = "$env:APPDATA\Spotify\Spotify.exe"
        $Shortcut.TargetPath = $source
        $Shortcut.Save()
        Write-Host "Скрипт для очистки кэша был удален" -ForegroundColor Green
        Write-Host "Установка завершена" -ForegroundColor Green
        exit
    }
    If (!($test_cache_spotify_ps -and $test_spotify_vbs)) {
        Write-Host "Ого, скрипт очистки кэша не найден" 
        Write-Host "Установка завершена" -ForegroundColor Green
        exit
    }
}

else {
    Write-Host "Ой, неудачно" -ForegroundColor Red
    Write-Host "Установка завершена" -ForegroundColor Green
}

exit
