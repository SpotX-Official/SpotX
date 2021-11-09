# Ignore errors from `Stop-Process`
$PSDefaultParameterValues['Stop-Process:ErrorAction'] = 'SilentlyContinue'

# Check Tls12
$tsl_check = [Net.ServicePointManager]::SecurityProtocol 
if (!($tsl_check -match '^tls12$' )) {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
}


Write-Host "*****************"
Write-Host "Автор: " -NoNewline
Write-Host "@Amd64fox" -ForegroundColor DarkYellow
Write-Host "*****************"


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
    Start-Sleep
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

    # Удалить инсталятор после установки
    if (test-path "$env:LOCALAPPDATA\Microsoft\Windows\Temporary Internet Files\") {
        get-childitem -path "$env:LOCALAPPDATA\Microsoft\Windows\Temporary Internet Files\" -Recurse -Force -Filter  "SpotifyFullSetup*" | remove-item  -Force
    }
    if (test-path $env:LOCALAPPDATA\Microsoft\Windows\INetCache\) {
        get-childitem -path "$env:LOCALAPPDATA\Microsoft\Windows\INetCache\" -Recurse -Force -Filter  "SpotifyFullSetup*" | remove-item  -Force
    
    }
    
}

if (!(test-path $SpotifyDirectory/chrome_elf_bak.dll)) {
    Move-Item $SpotifyDirectory\chrome_elf.dll $SpotifyDirectory\chrome_elf_bak.dll >$null 2>&1
}

Write-Host 'Модифицирую Spotify...'
$patchFiles = "$PWD\chrome_elf.dll", "$PWD\config.ini"
Copy-Item -LiteralPath $patchFiles -Destination "$SpotifyDirectory"

$tempDirectory = $PWD
Pop-Location


Start-Sleep -Milliseconds 200
Remove-Item -Recurse -LiteralPath $tempDirectory 




# Removing an empty block, "Upgrade button", "Upgrade to premium" menu
$xpui_spa = "$env:APPDATA\Spotify\Apps\xpui.spa"
$zipFilePath = "$env:APPDATA\Spotify\Apps\xpui.zip"
$extractPath = "$env:APPDATA\Spotify\Apps\temporary"
$extractPath_removeRTL = "$env:APPDATA\Spotify\Apps\temporary\removeRTL"

Rename-Item -path $xpui_spa -NewName $zipFilePath

if (Test-Path $extractPath) {
    Remove-item $extractPath -Recurse
}
New-Item -Path $extractPath -ItemType Directory | Out-Null
New-Item -Path $extractPath_removeRTL -ItemType Directory | Out-Null

# Достаем из архива xpui.zip файлы js
Add-Type -Assembly 'System.IO.Compression.FileSystem'
$zip = [System.IO.Compression.ZipFile]::Open($zipFilePath, 'read')
$zip.Entries | Where-Object Name -eq xpui.js | ForEach-Object { [System.IO.Compression.ZipFileExtensions]::ExtractToFile($_, "$extractPath\$($_.Name)", $true) }
$zip.Entries | Where-Object Name -eq vendor~xpui.js | ForEach-Object { [System.IO.Compression.ZipFileExtensions]::ExtractToFile($_, "$extractPath\$($_.Name)", $true) }
# Достаем из архива xpui.zip файлы css
$zip.Entries | Where-Object Name -like *.css | ForEach-Object { [System.IO.Compression.ZipFileExtensions]::ExtractToFile($_, "$extractPath_removeRTL\$($_.Name)", $true) }
$zip.Dispose()

# Делает резервную копию xpui.spa

$xpui_js = Get-Content $extractPath\xpui.js -Raw
$vendor_xpui_js = Get-Content $extractPath\vendor~xpui.js -Raw
    
If (!($xpui_js -match 'patched by spotx')) {
    Copy-Item $zipFilePath $env:APPDATA\Spotify\Apps\xpui.bak
}

   
# Мофифицируем и кладем обратно в архив файлы 

If (!($file_js -match 'patched by spotx')) {
	
    # Js
    $xpui_js -match 'visible:!e}[)]{1}[,]{1}[A-Za-z]{1}[(]{1}[)]{1}.createElement[(]{1}[A-Za-z]{2}[,]{1}null[)]{1}[,]{1}[A-Za-z]{1}[(]{1}[)]{1}.' | Out-Null
    $menu_split_js = $Matches[0] -split 'createElement[(]{1}[A-Za-z]{2}[,]{1}null[)]{1}[,]{1}[A-Za-z]{1}[(]{1}[)]{1}.'
    $new_js = $xpui_js <# Removing "Upgrade button" #> -replace "[.]{1}createElement[(]{1}..[,]{1}[{]{1}onClick[:]{1}.[,]{1}className[:]{1}..[.]{1}.[.]{1}UpgradeButton[}]{1}[)]{1}[,]{1}.[(]{1}[)]{1}", "" <# Removing an empty block #> -replace 'adsEnabled:!0', 'adsEnabled:!1' <# Removing "Upgrade to premium" menu #> -replace 'visible:!e}[)]{1}[,]{1}[A-Za-z]{1}[(]{1}[)]{1}.createElement[(]{1}[A-Za-z]{2}[,]{1}null[)]{1}[,]{1}[A-Za-z]{1}[(]{1}[)]{1}.', $menu_split_js <# Disabling a playlist sponsor #> -replace "allSponsorships", "" <# Disable Logging #> -replace "sp://logging/v3/\w+", "" 
    Set-Content -Path $extractPath\xpui.js -Force -Value $new_js
    add-content -Path $extractPath\xpui.js -Value '// Patched by SpotX' -passthru | Out-Null
    $contentjs = [System.IO.File]::ReadAllText("$extractPath\xpui.js")
    $contentjs = $contentjs.Trim()
    [System.IO.File]::WriteAllText("$extractPath\xpui.js", $contentjs)

    $new_js = $vendor_xpui_js <# Disable Sentry" #> -replace "prototype\.bindClient=function\(\w+\)\{", '${0}return;'
    Set-Content -Path $extractPath\vendor~xpui.js -Force -Value $new_js
    $contentjs = [System.IO.File]::ReadAllText("$extractPath\vendor~xpui.js")
    $contentjs = $contentjs.Trim()
    [System.IO.File]::WriteAllText("$extractPath\vendor~xpui.js", $contentjs)

    # Css
    Get-ChildItem -Path $extractPath_removeRTL\*.css | ForEach-Object {

        $Path = $_.FullName; (Get-Content $Path) -replace "}\[dir=ltr\]\s?", "} " -replace "html\[dir=ltr\]", "html" -replace ",\s?\[dir=rtl\].+?(\{.+?\})", '$1' -replace "[\w\-\.]+\[dir=rtl\].+?\{.+?\}", "" -replace "\}\[lang=ar\].+?\{.+?\}", "}" -replace "\}\[dir=rtl\].+?\{.+?\}", "}" -replace "\}html\[dir=rtl\].+?\{.+?\}", "}" -replace "\}html\[lang=ar\].+?\{.+?\}", "}" -replace "\[lang=ar\].+?\{.+?\}", "" -replace "html\[dir=rtl\].+?\{.+?\}", "" -replace "html\[lang=ar\].+?\{.+?\}", "" -replace "\[dir=rtl\].+?\{.+?\}", "" | Set-Content $Path # Remove RTL
    }

    Compress-Archive -Path $extractPath\*.js -Update -DestinationPath $zipFilePath
    Compress-Archive -Path $extractPath_removeRTL\*.css -Update -DestinationPath $zipFilePath
}
else {
    "Spotify уже был пропатчен"
}


<#
# Удаление меню через css (РЕЗЕРВНЫЙ)
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
#>


Rename-Item -path $zipFilePath -NewName $xpui_spa
Remove-item $extractPath -Recurse


# Если папки по умолчанию Dekstop не существует, то попытаться найти её через реестр.
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

$ErrorActionPreference = 'SilentlyContinue'  # Команда гасит легкие ошибки



$update_directory = Test-Path -Path $env:LOCALAPPDATA\Spotify 
$update_directory_file = Test-Path -Path $env:LOCALAPPDATA\Spotify\Update
$migrator_bak = Test-Path -Path $env:APPDATA\Spotify\SpotifyMigrator.bak  
$migrator_exe = Test-Path -Path $env:APPDATA\Spotify\SpotifyMigrator.exe
$Check_folder_file = Get-ItemProperty -Path $env:LOCALAPPDATA\Spotify\Update | Select-Object Attributes 
$folder_update_access = Get-Acl $env:LOCALAPPDATA\Spotify\Update

do {
    $ch = Read-Host -Prompt "Хотите заблокировать обновления ? (Y/N), Хочу разблокировать (U)"
    if (!($ch -eq 'n' -or $ch -eq 'y' -or $ch -eq 'u')) {
    
        Write-Host "Ой, некорректное значение, " -ForegroundColor Red -NoNewline
        Write-Host "повторите ввод через..." -NoNewline
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
while ($ch -notmatch '^y$|^n$|^u$')


if ($ch -eq 'y') {

    # Если была установка клиента 
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


        #Удалить папку Update если она есть
        if ($Check_folder_file -match '\bDirectory\b') {  

            #Если у папки Update заблокированы права то разблокировать 
            if ($folder_update_access.AccessToString -match 'Deny') {

        ($ACL = Get-Acl $env:LOCALAPPDATA\Spotify\Update).access | ForEach-Object {
                    $Users = $_.IdentityReference 
                    $ACL.PurgeAccessRules($Users) }
                $ACL | Set-Acl $env:LOCALAPPDATA\Spotify\Update
            }
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
    If ($migrator_bak -or $Check_folder_file -match '\bSystem\b|\bReadOnly\b') {
       
    
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


    If (!($migrator_bak -or $Check_folder_file -match '\bSystem\b|\bReadOnly\b')) {
        Write-Host "Ого, обновления уже были разблокированы" 
    }  
}
    


# automatic cache clearing

do {
    $ch = Read-Host -Prompt "Хотите установить автоматическую очистку кеша ? (Y/N) Хочу удалить (U)"

    if (!($ch -eq 'n' -or $ch -eq 'y' -or $ch -eq 'u')) {
        Write-Host "Ой, некорректное значение, " -ForegroundColor Red -NoNewline
        Write-Host "повторите ввод через..." -NoNewline
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
while ($ch -notmatch '^y$|^n$|^u$')



if ($ch -eq 'y') {

    
    $test_cache_spotify_ps = Test-Path -Path $env:APPDATA\Spotify\cache-spotify.ps1
    $test_spotify_vbs = Test-Path -Path $env:APPDATA\Spotify\Spotify.vbs




    If ($test_cache_spotify_ps) {
        Remove-item $env:APPDATA\Spotify\cache-spotify.ps1 -Recurse -Force
    }
    If ($test_spotify_vbs) {
        Remove-item $env:APPDATA\Spotify\Spotify.vbs -Recurse -Force
    }
    Start-Sleep -Milliseconds 200

    # cache-spotify.ps1
    $webClient.DownloadFile('https://raw.githubusercontent.com/amd64fox/SpotX/main/cache_spotify_ru.ps1', "$env:APPDATA\Spotify\cache-spotify.ps1")

    # Spotify.vbs
    $webClient.DownloadFile('https://raw.githubusercontent.com/amd64fox/SpotX/main/Spotify.vbs', "$env:APPDATA\Spotify\Spotify.vbs")


    # Spotify.lnk
    $source2 = "$env:APPDATA\Spotify\Spotify.vbs"
    $target2 = "$desktop_folder\Spotify.lnk"
    $WorkingDir2 = "$env:APPDATA\Spotify"
    $WshShell2 = New-Object -comObject WScript.Shell
    $Shortcut2 = $WshShell2.CreateShortcut($target2)
    $Shortcut2.WorkingDirectory = $WorkingDir2
    $Shortcut2.IconLocation = "$env:APPDATA\Spotify\Spotify.exe"
    $Shortcut2.TargetPath = $source2
    $Shortcut2.Save()





    do {
        $ch = Read-Host -Prompt "Файлы кэша, которые не использовались более XX дней, будут удалены.
    Пожалуйста, введите количество дней от 1 до 100"

        if (!($ch -match "^[1-9][0-9]?$|^100$")) {
            Write-Host "Ой, некорректное значение, " -ForegroundColor Red -NoNewline
            Write-Host "повторите ввод через..." -NoNewline
		
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

        $source3 = "$env:APPDATA\Spotify\Spotify.exe"
        $target3 = "$desktop_folder\Spotify.lnk"
        $WorkingDir3 = "$env:APPDATA\Spotify"
        $WshShell3 = New-Object -comObject WScript.Shell
        $Shortcut3 = $WshShell3.CreateShortcut($target3)
        $Shortcut3.WorkingDirectory = $WorkingDir3
        $Shortcut3.IconLocation = "$env:APPDATA\Spotify\Spotify.exe"
        $Shortcut3.TargetPath = $source3
        $Shortcut3.Save()
        Write-Host "Очистка кэша удалена" -ForegroundColor Green
        Write-Host "Установка завершена" -ForegroundColor Green
        exit
    }


    If (!($test_cache_spotify_ps -and $test_spotify_vbs)) {
        Write-Host "Ого, скрипт очистки кэша не найден" 
        Write-Host "Установка завершена" -ForegroundColor Green
        exit
    }
}

exit
