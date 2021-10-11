# Ignore errors from `Stop-Process`
$PSDefaultParameterValues['Stop-Process:ErrorAction'] = 'SilentlyContinue'

# Check Tls12
$tsl_check = [Net.ServicePointManager]::SecurityProtocol 
if (!($tsl_check -match '^tls12$' )) {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
}






Write-Host "*****************" -ForegroundColor DarkYellow
Write-Host "Rollback Spotify" -ForegroundColor DarkYellow
Write-Host "*****************" -ForegroundColor DarkYellow






$SpotifyexePatch = "$env:APPDATA\Spotify\Spotify.exe"
$SpotifyDirectory = "$env:APPDATA\Spotify"



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
The Microsoft Store version of Spotify has been detected which is not supported.
'@`n
        $ch = Read-Host -Prompt "Uninstall Spotify Windows Store edition (Y/N) "
        if ($ch -eq 'y') {
            Write-Host @'
Uninstalling Spotify.
'@`n
            Get-AppxPackage -Name SpotifyAB.SpotifyMusic | Remove-AppxPackage
        }
        else {
            Write-Host @'
Exiting...
'@`n
            Pause 
            exit
        }
    }
}







if (Test-Path $SpotifyexePatch) {
    do {
        $verlast = (Get-Item $SpotifyexePatch).VersionInfo.FileVersion
        Write-Host "Client was found"
        "`n"
        Write-Host "You have version installed " -NoNewline
        Write-Host  $verlast -ForegroundColor Green
        "`n"


        $ch = Read-Host -Prompt "Want to remove (y) or replace (r) ? "
        "`n"
        if (!($ch -eq 'y' -or $ch -eq 'r')) {
    
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
    while ($ch -notmatch '^y$|^r$')

}

If ($ch -eq 'y') {
    "`n"
    Write-Host "Click Ok to delete Spotify"
    "`n"
    Start-Process -FilePath $SpotifyexePatch /UNINSTALL
    Start-Sleep -Milliseconds 1500
    wait-process -Name SpotifyUninstall
    Start-Sleep -Milliseconds 1100

 
}
 


 
$wget = Invoke-WebRequest -UseBasicParsing -Uri https://docs.google.com/spreadsheets/d/1wztO1L4zvNykBRw7X4jxP8pvo11oQjT0O5DvZ_-S4Ok/edit#gid=0
$result = $wget.RawContent | Select-String "1.\d.\d{1,2}.\d{1,5}.g[0-9a-z][0-9a-z][0-9a-z][0-9a-z][0-9a-z][0-9a-z][0-9a-z][0-9a-z]" -AllMatches
$version1 = $result.Matches.Value[3]
$version2 = $result.Matches.Value[5]
$version3 = $result.Matches.Value[7]
$version4 = $result.Matches.Value[9]
$version5 = $result.Matches.Value[11]



do {
    $ch2 = Read-Host -Prompt "1) $version1
2) $version2
3) $version3
4) $version4
5) $version5

Select the version to rollback"
    "`n"

    if (!($ch2 -match '^1$|^2$|^3$|^4$|^5$')) {
    
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
while ($ch2 -notmatch '^1$|^2$|^3$|^4$|^5$')

if ($ch2 -eq 1) {
    $result2 = $wget.RawContent | Select-String "https:[/][/]upgrade.scdn.co[/]upgrade[/]client[/]win32-x86[/]spotify_installer-$version1-\d{1,3}.exe" -AllMatches
    $vernew = $version1
}
if ($ch2 -eq 2) {
    $result2 = $wget.RawContent | Select-String "https:[/][/]upgrade.scdn.co[/]upgrade[/]client[/]win32-x86[/]spotify_installer-$version2-\d{1,3}.exe" -AllMatches
    $vernew = $version2
}
if ($ch2 -eq 3) {
    $result2 = $wget.RawContent | Select-String "https:[/][/]upgrade.scdn.co[/]upgrade[/]client[/]win32-x86[/]spotify_installer-$version3-\d{1,3}.exe" -AllMatches
    $vernew = $version3
}
if ($ch2 -eq 4) {
    $result2 = $wget.RawContent | Select-String "https:[/][/]upgrade.scdn.co[/]upgrade[/]client[/]win32-x86[/]spotify_installer-$version4-\d{1,3}.exe" -AllMatches
    $vernew = $version4
}
if ($ch2 -eq 5) {
    $result2 = $wget.RawContent | Select-String "https:[/][/]upgrade.scdn.co[/]upgrade[/]client[/]win32-x86[/]spotify_installer-$version5-\d{1,3}.exe" -AllMatches
    $vernew = $version5
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


   



    
Write-Host "Downloading Spotify"
"`n" 
Write-Host "Please wait..."
"`n" 

try {

    Start-BitsTransfer -Source  $result2.Matches.Value[0] -Destination "$PWD\SpotifySetup.exe"  -DisplayName "Downloading Spotify" -Description "$vernew "
    
}


catch {
    Write-Output ''
    Start-Sleep
}


mkdir $SpotifyDirectory >$null 2>&1




If ($ch -eq 'r') {

    if ($vernew -lt $verlast) {


        Write-Host "Please confirm reinstallation"
        "`n"
    }
}




Start-Process -FilePath $PWD\SpotifySetup.exe; wait-process -name SpotifySetup; Write-Host "Installing Spotify..."
"`n" 

Stop-Process -Name Spotify >$null 2>&1
Stop-Process -Name SpotifyWebHelper >$null 2>&1
Stop-Process -Name SpotifySetup >$null 2>&1




if (!(test-path $SpotifyDirectory/chrome_elf.dll.bak)) {
    Move-Item $SpotifyDirectory\chrome_elf.dll $SpotifyDirectory\chrome_elf.dll.bak >$null 2>&1
}

Write-Host 'Patching Spotify...'
"`n"
$patchFiles = "$PWD\chrome_elf.dll", "$PWD\config.ini"
Copy-Item -LiteralPath $patchFiles -Destination "$SpotifyDirectory"

$tempDirectory = $PWD
Pop-Location


Start-Sleep -Milliseconds 200
Remove-Item -Recurse -LiteralPath $tempDirectory 


# Removing an empty block, "Upgrade button", "Upgrade to premium" menu

$zipFilePath = "$env:APPDATA\Spotify\Apps\xpui.zip"
$extractPath = "$env:APPDATA\Spotify\Apps\temporary"


Rename-Item -path $env:APPDATA\Spotify\Apps\xpui.spa -NewName $env:APPDATA\Spotify\Apps\xpui.zip

if (Test-Path $env:APPDATA\Spotify\Apps\temporary) {
    Remove-item $env:APPDATA\Spotify\Apps\temporary -Recurse
}
New-Item -Path $env:APPDATA\Spotify\Apps\temporary -ItemType Directory | Out-Null

# Достаем из архива xpui.zip файл xpui.js
Add-Type -Assembly 'System.IO.Compression.FileSystem'
$zip = [System.IO.Compression.ZipFile]::Open($zipFilePath, 'read')
$zip.Entries | Where-Object Name -eq xpui.js | ForEach-Object { [System.IO.Compression.ZipFileExtensions]::ExtractToFile($_, "$extractPath\$($_.Name)", $true) }
$zip.Dispose()

# Делает резервную копию xpui.spa

$file_js = Get-Content $env:APPDATA\Spotify\Apps\temporary\xpui.js -Raw
    
If (!($file_js -match 'patched by spotx')) {
    Copy-Item $env:APPDATA\Spotify\Apps\xpui.zip $env:APPDATA\Spotify\Apps\xpui.bak
}

   
# Мофифицируем и кладем обратно в архив файл xpui.js 

If (!($file_js -match 'patched by spotx')) {
    $file_js -match 'visible:!e}[)]{1}[,]{1}[A-Za-z]{1}[(]{1}[)]{1}.createElement[(]{1}[A-Za-z]{2}[,]{1}null[)]{1}[,]{1}[A-Za-z]{1}[(]{1}[)]{1}.' | Out-Null
    $menu_split_js = $Matches[0] -split 'createElement[(]{1}[A-Za-z]{2}[,]{1}null[)]{1}[,]{1}[A-Za-z]{1}[(]{1}[)]{1}.'
    $new_js = $file_js -replace "[.]{1}createElement[(]{1}..[,]{1}[{]{1}onClick[:]{1}.[,]{1}className[:]{1}..[.]{1}.[.]{1}UpgradeButton[}]{1}[)]{1}[,]{1}.[(]{1}[)]{1}", "" -replace 'adsEnabled:!0', 'adsEnabled:!1' -replace 'visible:!e}[)]{1}[,]{1}[A-Za-z]{1}[(]{1}[)]{1}.createElement[(]{1}[A-Za-z]{2}[,]{1}null[)]{1}[,]{1}[A-Za-z]{1}[(]{1}[)]{1}.', $menu_split_js -replace "allSponsorships", ""
    Set-Content -Path $env:APPDATA\Spotify\Apps\temporary\xpui.js -Force -Value $new_js
    add-content -Path $env:APPDATA\Spotify\Apps\temporary\xpui.js -Value '// Patched by SpotX' -passthru | Out-Null
    $contentjs = [System.IO.File]::ReadAllText("$env:APPDATA\Spotify\Apps\temporary\xpui.js")
    $contentjs = $contentjs.Trim()
    [System.IO.File]::WriteAllText("$env:APPDATA\Spotify\Apps\temporary\xpui.js", $contentjs)
    Compress-Archive -Path $env:APPDATA\Spotify\Apps\temporary\xpui.js -Update -DestinationPath $env:APPDATA\Spotify\Apps\xpui.zip
}
else {
    "Xpui.js is already patched"
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

Rename-Item -path $env:APPDATA\Spotify\Apps\xpui.zip -NewName $env:APPDATA\Spotify\Apps\xpui.spa
Remove-item $env:APPDATA\Spotify\Apps\temporary -Recurse



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
$migrator_bak = Test-Path -Path $env:APPDATA\Spotify\SpotifyMigrator.bak  
$migrator_exe = Test-Path -Path $env:APPDATA\Spotify\SpotifyMigrator.exe
$Check_folder_file = Get-ItemProperty -Path $env:LOCALAPPDATA\Spotify\Update | Select-Object Attributes 
$folder_update_access = Get-Acl $env:LOCALAPPDATA\Spotify\Update




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
    if (!($Check_folder_file -match '\bSystem\b|' -and $Check_folder_file -match '\bReadOnly\b')) {  
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

  
Write-Host "Updates blocked successfully" -ForegroundColor Green


Write-Host "Rollback completed" -ForegroundColor Green
