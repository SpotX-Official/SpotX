@echo off
SETLOCAL ENABLEDELAYEDEXPANSION
echo *****************
echo Author: @amd64fox
echo *****************
echo Removing Patch...


if exist "%APPDATA%\Spotify\chrome_elf_bak.dll" ( 
    del /s /q "%APPDATA%\Spotify\chrome_elf.dll" > NUL 2>&1
    move "%APPDATA%\Spotify\chrome_elf_bak.dll" "%APPDATA%\Spotify\chrome_elf.dll" > NUL 2>&1
) 


if exist "%APPDATA%\Spotify\config.ini" (
    del /s /q "%APPDATA%\Spotify\config.ini" > NUL 2>&1
) 


if exist "%APPDATA%\Spotify\Apps\xpui.bak" (
    del /s /q "%APPDATA%\Spotify\Apps\xpui.spa" > NUL 2>&1
    move "%APPDATA%\Spotify\Apps\xpui.bak" "%APPDATA%\Spotify\Apps\xpui.spa" > NUL 2>&1
) 


if exist "%APPDATA%\Spotify\Apps\xpui\xpui.js.bak" (
    del /s /q "%APPDATA%\Spotify\Apps\xpui\xpui.js" > NUL 2>&1
	move "%APPDATA%\Spotify\Apps\xpui\xpui.js.bak" "%APPDATA%\Spotify\Apps\xpui\xpui.js" > NUL 2>&1
)


if exist "%APPDATA%\Spotify\blockthespot_log.txt" (
    del /s /q "%APPDATA%\Spotify\blockthespot_log.txt" > NUL 2>&1
)


if exist "%localappdata%\Spotify\Update" (
    del /A:sr %localappdata%\Spotify\Update > NUL 2>&1
) 


if exist "%APPDATA%\Spotify\SpotifyMigrator.bak" (
    rename %APPDATA%\Spotify\SpotifyMigrator.bak SpotifyMigrator.exe > NUL 2>&1
) 
if exist "%APPDATA%\Spotify\SpotifyMigrator.exe" (
if exist "%APPDATA%\Spotify\SpotifyMigrator.bak" (
	del /f /s /q %APPDATA%\Spotify\SpotifyMigrator.bak > NUL 2>&1
) 
)


if exist "%APPDATA%\Spotify\Spotify.vbs" (
    del /f /s /q %APPDATA%\Spotify\Spotify.vbs > NUL 2>&1
) 

if exist "%APPDATA%\Spotify\cache-spotify.ps1" (
    del /f /s /q %APPDATA%\Spotify\cache-spotify.ps1 > NUL 2>&1
	del /f /s /q %USERPROFILE%\Desktop\Spotify.lnk > NUL 2>&1


SET Esc_LinkDest=%USERPROFILE%\Desktop\Spotify.lnk
SET Esc_LinkTarget=%APPDATA%\Spotify\Spotify.exe
SET Esc_WorkLinkTarget=%APPDATA%\Spotify\
SET cSctVBS=CreateShortcut.vbs
((
echo Set oWS = WScript.CreateObject^("WScript.Shell"^) 
echo sLinkFile = oWS.ExpandEnvironmentStrings^("!Esc_LinkDest!"^)
echo Set oLink = oWS.CreateShortcut^(sLinkFile^) 
echo oLink.TargetPath = oWS.ExpandEnvironmentStrings^("!Esc_LinkTarget!"^)
echo oLink.WorkingDirectory = oWS.ExpandEnvironmentStrings^("!Esc_WorkLinkTarget!"^)
echo oLink.Save
)1>!cSctVBS!
cscript !cSctVBS!
DEL !cSctVBS! /f /q
)
) 

echo Patch successfully removed
pause
