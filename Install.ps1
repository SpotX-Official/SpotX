# Ignore errors from `Stop-Process`
$PSDefaultParameterValues['Stop-Process:ErrorAction'] = 'SilentlyContinue'

# Check Tls12
$tsl_check = [Net.ServicePointManager]::SecurityProtocol 
if (!($tsl_check -match '^tls12$' )) {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
}


Write-Host "*****************"
Write-Host "Author: " -NoNewline
Write-Host "@Amd64fox" -ForegroundColor DarkYellow
Write-Host "*****************"`n


$SpotifyDirectory = "$env:APPDATA\Spotify"
$SpotifyExecutable = "$SpotifyDirectory\Spotify.exe"
$Podcasts_off = $false


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
        Write-Host 'The Microsoft Store version of Spotify has been detected which is not supported.'`n
        $ch = Read-Host -Prompt "Uninstall Spotify Windows Store edition (Y/N) "
        if ($ch -eq 'y') {
            Write-Host 'Uninstalling Spotify.'`n
            Get-AppxPackage -Name SpotifyAB.SpotifyMusic | Remove-AppxPackage
        }
        else {
            Write-Host 'Exiting...'`n
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


Write-Host 'Downloading latest patch BTS...'`n

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
    mkdir $SpotifyDirectory | Out-Null

    # Check version Spotify
    $version_client_check = (get-item $PWD\SpotifySetup.exe).VersionInfo.ProductVersion
    $version_client = $version_client_check -split '.\w\w\w\w\w\w\w\w\w'
   
    Write-Host "Downloading and installing Spotify " -NoNewline
    Write-Host  $version_client -ForegroundColor Green
    Write-Host "Please wait..."`n
    
    Start-Process -FilePath $PWD\SpotifySetup.exe; wait-process -name SpotifySetup

  
  
    Stop-Process -Name Spotify 
    Stop-Process -Name SpotifyWebHelper 
    Stop-Process -Name SpotifyFullSetup 


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
    Move-Item $SpotifyDirectory\chrome_elf.dll $SpotifyDirectory\chrome_elf_bak.dll 
}

Write-Host 'Patching Spotify...'`n
$patchFiles = "$PWD\chrome_elf.dll", "$PWD\config.ini"
Copy-Item -LiteralPath $patchFiles -Destination "$SpotifyDirectory"

$tempDirectory = $PWD
Pop-Location


Start-Sleep -Milliseconds 200
Remove-Item -Recurse -LiteralPath $tempDirectory 



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
if ($ch -eq 'y') { $Podcasts_off = $true }


# Мофифицируем файлы 

$xpui_spa_patch = "$env:APPDATA\Spotify\Apps\xpui.spa"
$xpui_js_patch = "$env:APPDATA\Spotify\Apps\xpui\xpui.js"

If (Test-Path $xpui_js_patch) {
    Write-Host "Spicetify detected"`n 

    $xpui_js = Get-Content $xpui_js_patch -Raw
    
    If (!($xpui_js -match 'patched by spotx')) {
        

        Copy-Item $xpui_js_patch "$xpui_js_patch.bak"

        $new_js = $xpui_js `
            <# Removing an empty block #> `
            -replace 'adsEnabled:!0', 'adsEnabled:!1' `
            <# Full screen mode activation and removing "Upgrade to premium" menu, upgrade button #> `
            -replace '(session[,]{1}[a-z]{1}[=]{1}[a-z]{1}[=]{1}[>]{1}[{]{1}var [a-z]{1}[,]{1}[a-z]{1}[,]{1}[a-z]{1}[;]{1}[a-z]{6})(["]{1}free["]{1})', '$1"premium"' `
            -replace '([a-z]{1}[.]{1}toLowerCase[(]{1}[)]{2}[}]{1}[,]{1}[a-z]{1}[=]{1}[a-z]{1}[=]{1}[>]{1}[{]{1}var [a-z]{1}[,]{1}[a-z]{1}[,]{1}[a-z]{1}[;]{1}return)(["]{1}premium["]{1})', '$1"free"' `
            <# Disabling a playlist sponsor #>`
            -replace "allSponsorships", ""

        # Disable Podcast
        if ($Podcasts_off) {
            $new_js = $new_js `
                -replace '"album,playlist,artist,show,station,episode"', '"album,playlist,artist,station"' -replace ',this[.]enableShows=[a-z]', ""
        }

        Set-Content -Path $xpui_js_patch -Force -Value $new_js
        add-content -Path $xpui_js_patch -Value '// Patched by SpotX' -passthru | Out-Null
        $contentjs = [System.IO.File]::ReadAllText($xpui_js_patch)
        $contentjs = $contentjs.Trim()
        [System.IO.File]::WriteAllText($xpui_js_patch, $contentjs)

    }
    else {
        Write-Host "Spotify is already patched"`n 
    }
}

If (Test-Path $xpui_spa_patch) {
    Add-Type -Assembly 'System.IO.Compression.FileSystem'

    $zip = [System.IO.Compression.ZipFile]::Open($xpui_spa_patch, 'update')
    $entry = $zip.GetEntry('xpui.js')
    $reader = New-Object System.IO.StreamReader($entry.Open())
    $patched_by_spotx = $reader.ReadToEnd()
    $reader.Close()
 

    If (!($patched_by_spotx -match 'patched by spotx')) {

        # Делаем резервную копию xpui.spa если он оригинальный
        
        $zip.Dispose()
        Copy-Item $xpui_spa_patch $env:APPDATA\Spotify\Apps\xpui.bak
        

        Add-Type -Assembly 'System.IO.Compression.FileSystem'
        $zip = [System.IO.Compression.ZipFile]::Open($xpui_spa_patch, 'update')
    
        # xpui.js
        $entry_xpui = $zip.GetEntry('xpui.js')

        # Extract xpui.js from zip to memory
        $reader = New-Object System.IO.StreamReader($entry_xpui.Open())
        $xpuiContents = $reader.ReadToEnd()
        $reader.Close()

        $xpuiContents = $xpuiContents `
            <# Removing an empty block #> `
            -replace 'adsEnabled:!0', 'adsEnabled:!1' `
            <# Full screen mode activation and removing "Upgrade to premium" menu, upgrade button #> `
            -replace '(session[,]{1}[a-z]{1}[=]{1}[a-z]{1}[=]{1}[>]{1}[{]{1}var [a-z]{1}[,]{1}[a-z]{1}[,]{1}[a-z]{1}[;]{1}[a-z]{6})(["]{1}free["]{1})', '$1"premium"' `
            -replace '([a-z]{1}[.]{1}toLowerCase[(]{1}[)]{2}[}]{1}[,]{1}[a-z]{1}[=]{1}[a-z]{1}[=]{1}[>]{1}[{]{1}var [a-z]{1}[,]{1}[a-z]{1}[,]{1}[a-z]{1}[;]{1}return)(["]{1}premium["]{1})', '$1"free"' `
            <# Disabling a playlist sponsor #>`
            -replace "allSponsorships", "" `
            <# Disable Logging #>`
            -replace "sp://logging/v3/\w+", "" 

        # Disable Podcast
        if ($Podcasts_off) {
            $xpuiContents = $xpuiContents `
                -replace '"album,playlist,artist,show,station,episode"', '"album,playlist,artist,station"' -replace ',this[.]enableShows=[a-z]', ""
        }

        $writer = New-Object System.IO.StreamWriter($entry_xpui.Open())
        $writer.BaseStream.SetLength(0)
        $writer.Write($xpuiContents)
        $writer.Write([System.Environment]::NewLine + '// Patched by SpotX')
        $writer.Close()


        # vendor~xpui.js
        $entry_vendor_xpui = $zip.GetEntry('vendor~xpui.js')

        # Extract vendor~xpui.js from zip to memory
        $reader = New-Object System.IO.StreamReader($entry_vendor_xpui.Open())
        $xpuiContents_vendor = $reader.ReadToEnd()
        $reader.Close()

        $xpuiContents_vendor = $xpuiContents_vendor `
            <# Disable Sentry" #> -replace "prototype\.bindClient=function\(\w+\)\{", '${0}return;'

        # Rewrite it to the zip
        $writer = New-Object System.IO.StreamWriter($entry_vendor_xpui.Open())
        $writer.BaseStream.SetLength(0)
        $writer.Write($xpuiContents_vendor)
        $writer.Close()


        # *.Css
        $zip.Entries | Where-Object FullName -like '*.css' | ForEach-Object {
            $readercss = New-Object System.IO.StreamReader($_.Open())
            $xpuiContents_css = $readercss.ReadToEnd()
            $readercss.Close()

            # Remove RTL
            $xpuiContents_css = $xpuiContents_css `
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
                -replace "\[dir=rtl\].+?\{.+?\}", ""
    
            $writer = New-Object System.IO.StreamWriter($_.Open())
            $writer.BaseStream.SetLength(0)
            $writer.Write($xpuiContents_css)
            $writer.Close()

        }
     
        $zip.Dispose()
    }
    else {
        $zip.Dispose()
        Write-Host "Spotify is already patched"`n
    }
}


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
    $ch = Read-Host -Prompt "Want to block updates ? (Y/N), Unlock updates (U)"
    if (!($ch -eq 'n' -or $ch -eq 'y' -or $ch -eq 'u')) {
    
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

  
    Write-Host "Updates blocked successfully"`n -ForegroundColor Green

}


if ($ch -eq 'n') {
    Write-Host "Left unchanged"`n
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
        Write-Host "Updates unlocked"`n -ForegroundColor Green
    }


    If (!($migrator_bak -or $Check_folder_file -match '\bSystem\b|\bReadOnly\b')) {
        Write-Host "Oops, updates are not blocked"`n 
    }  
}
    


# automatic cache clearing

do {
    $ch = Read-Host -Prompt "Want to set up automatic cache cleanup? (Y/N) Delete script (U)"
    Write-Host ""
    if (!($ch -eq 'n' -or $ch -eq 'y' -or $ch -eq 'u')) {
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
    $webClient.DownloadFile('https://raw.githubusercontent.com/amd64fox/SpotX/main/cache-spotify.ps1', "$env:APPDATA\Spotify\cache-spotify.ps1")

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
        $ch = Read-Host -Prompt "Cache files that have not been used for more than XX days will be deleted.
    Enter the number of days from 1 to 100"

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


    if ($ch -match "^[1-9][0-9]?$|^100$") {
        $file_cache_spotify_ps1 = Get-Content $env:APPDATA\Spotify\cache-spotify.ps1 -Raw
        $new_file_cache_spotify_ps1 = $file_cache_spotify_ps1 -replace '-7', - $ch
        Set-Content -Path $env:APPDATA\Spotify\cache-spotify.ps1 -Force -Value $new_file_cache_spotify_ps1
        $contentcache_spotify_ps1 = [System.IO.File]::ReadAllText("$env:APPDATA\Spotify\cache-spotify.ps1")
        $contentcache_spotify_ps1 = $contentcache_spotify_ps1.Trim()
        [System.IO.File]::WriteAllText("$env:APPDATA\Spotify\cache-spotify.ps1", $contentcache_spotify_ps1)
        Write-Host "Clearing the cache has been successfully installed"`n -ForegroundColor Green
        Write-Host "installation completed"`n -ForegroundColor Green
        exit
    }
         

}

if ($ch -eq 'n') {
    Write-Host "installation completed"`n -ForegroundColor Green

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
        Write-Host "Cache cleanup script removed"`n -ForegroundColor Green
        Write-Host "Installation completed" -ForegroundColor Green
        exit
    }


    If (!($test_cache_spotify_ps -and $test_spotify_vbs)) {
        Write-Host "Oops, no cache clearing script found"`n 
        Write-Host "Installation completed"`n -ForegroundColor Green
        exit
    }
}

exit