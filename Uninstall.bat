@echo off
SETLOCAL ENABLEDELAYEDEXPANSION
echo *****************
echo Author: @amd64fox
echo *****************
echo Removing Patch...


if exist "%Appdata%\Spotify\chrome_elf_bak.dll" ( 
    del /s /q "%Appdata%\Spotify\chrome_elf.dll" > NUL 2>&1
    move "%Appdata%\Spotify\chrome_elf_bak.dll" "%Appdata%\Spotify\chrome_elf.dll" > NUL 2>&1
) 

if exist "%Appdata%\Spotify\Spotify.bak" ( 
    del /s /q "%Appdata%\Spotify.exe" > NUL 2>&1
    move "%Appdata%\Spotify\Spotify.bak" "%Appdata%\Spotify\Spotify.exe" > NUL 2>&1
)


if exist "%Appdata%\Spotify\config.ini" (
    del /s /q "%Appdata%\Spotify\config.ini" > NUL 2>&1
) 


if exist "%Appdata%\Spotify\Apps\xpui.bak" (
    del /s /q "%Appdata%\Spotify\Apps\xpui.spa" > NUL 2>&1
    move "%Appdata%\Spotify\Apps\xpui.bak" "%Appdata%\Spotify\Apps\xpui.spa" > NUL 2>&1
) 


if exist "%Appdata%\Spotify\Apps\xpui\xpui.js.bak" (
    del /s /q "%Appdata%\Spotify\Apps\xpui\xpui.js" > NUL 2>&1
	move "%Appdata%\Spotify\Apps\xpui\xpui.js.bak" "%Appdata%\Spotify\Apps\xpui\xpui.js" > NUL 2>&1
)


if exist "%Appdata%\Spotify\Apps\xpui\xpui.css.bak" (
    del /s /q "%Appdata%\Spotify\Apps\xpui\xpui.css" > NUL 2>&1
	move "%Appdata%\Spotify\Apps\xpui\xpui.css.bak" "%Appdata%\Spotify\Apps\xpui\xpui.css" > NUL 2>&1
)


if exist "%Appdata%\Spotify\Apps\xpui\licenses.html.bak" (
    del /s /q "%Appdata%\Spotify\Apps\xpui\licenses.html" > NUL 2>&1
	move "%Appdata%\Spotify\Apps\xpui\licenses.html.bak" "%Appdata%\Spotify\Apps\xpui\licenses.html" > NUL 2>&1
)


if exist "%Appdata%\Spotify\Apps\xpui\i18n\ru.json.bak" (
    del /s /q "%Appdata%\Spotify\Apps\xpui\i18n\ru.json" > NUL 2>&1
	move "%Appdata%\Spotify\Apps\xpui\ru.json.bak" "%Appdata%\Spotify\Apps\xpui\i18n\ru.json" > NUL 2>&1
)


if exist "%Appdata%\Spotify\blockthespot_log.txt" (
    del /s /q "%Appdata%\Spotify\blockthespot_log.txt" > NUL 2>&1
)

if exist "%Appdata%\Spotify\cache" (
	rd /s /q %Appdata%\Spotify\cache > NUL 2>&1

SET Esc_LinkDest=%Userprofile%\Desktop\Spotify.lnk
SET Esc_LinkTarget=%Appdata%\Spotify\Spotify.exe
SET Esc_WorkLinkTarget=%Appdata%\Spotify\
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