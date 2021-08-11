@echo off
echo *****************
echo Author: @rednek46
echo Modified: @Amd64fox
echo *****************
echo Removing Patch...
if exist "%APPDATA%\Spotify\chrome_elf.dll.bak" (
    del /s /q "%APPDATA%\Spotify\chrome_elf.dll" > NUL 2>&1
    move "%APPDATA%\Spotify\chrome_elf.dll.bak" "%APPDATA%\Spotify\chrome_elf.dll" > NUL 2>&1
) 


if exist "%APPDATA%\Spotify\config.ini" (
    del /s /q "%APPDATA%\Spotify\config.ini" > NUL 2>&1
) 


if exist "%APPDATA%\Spotify\Apps\xpui.bak" (
    del /s /q "%APPDATA%\Spotify\Apps\xpui.spa" > NUL 2>&1
    move "%APPDATA%\Spotify\Apps\xpui.bak" "%APPDATA%\Spotify\Apps\xpui.spa" > NUL 2>&1
) 

echo Deletion completed.
pause
