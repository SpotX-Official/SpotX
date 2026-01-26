@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

set "SPOTIFY_PATH=%Appdata%\Spotify"

if exist "%SPOTIFY_PATH%\dpapi.dll" (
    del /s /q "%SPOTIFY_PATH%\dpapi.dll" > NUL 2>&1
)

if exist "%SPOTIFY_PATH%\config.ini" (
    del /s /q "%SPOTIFY_PATH%\config.ini" > NUL 2>&1
)

if exist "%SPOTIFY_PATH%\chrome_elf.dll.bak" (
    del /s /q "%SPOTIFY_PATH%\chrome_elf.dll" > NUL 2>&1
    move "%SPOTIFY_PATH%\chrome_elf.dll.bak" "%SPOTIFY_PATH%\chrome_elf.dll" > NUL 2>&1
)

if exist "%SPOTIFY_PATH%\Spotify.dll.bak" (
    del /s /q "%SPOTIFY_PATH%\Spotify.dll" > NUL 2>&1
    move "%SPOTIFY_PATH%\Spotify.dll.bak" "%SPOTIFY_PATH%\Spotify.dll" > NUL 2>&1
)

if exist "%SPOTIFY_PATH%\Spotify.bak" (
    del /s /q "%SPOTIFY_PATH%\Spotify.exe" > NUL 2>&1
    move "%SPOTIFY_PATH%\Spotify.bak" "%SPOTIFY_PATH%\Spotify.exe" > NUL 2>&1
)

if exist "%SPOTIFY_PATH%\Apps\xpui.bak" (
    del /s /q "%SPOTIFY_PATH%\Apps\xpui.spa" > NUL 2>&1
    move "%SPOTIFY_PATH%\Apps\xpui.bak" "%SPOTIFY_PATH%\Apps\xpui.spa" > NUL 2>&1
)

if exist "%temp%\SpotFreedom_Temp*" (
    for /d %%i in ("%temp%\SpotFreedom_Temp*") do (
        rd /s/q "%%i" > NUL 2>&1
    )
)

echo Patch successfully removed
pause