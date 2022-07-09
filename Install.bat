@echo off
Setlocal EnableDelayedExpansion
set "exec=powershell $PSVersionTable.PSVersion.major"
for /f %%i in ('%exec%') do set ps-v=%%i 2>nul
if  %ps-v% LEQ 2 (
    Echo Powershell %ps-v%is not supported
    @echo.
    Echo Please read the instruction "Outdated versions of PowerShell" at the following link
    @echo.
    Echo "https://github.com/amd64fox/SpotX#possible-problems"
    @echo.
    pause
    exit
)
curl -V >nul 2>&1
if %errorlevel% EQU 9009 (
    echo "Curl" command line utility not found
    @echo.
    echo Please follow the link, download and install "Curl" manually
    @echo.
    echo "http://www.confusedbycode.com/curl/#downloads"
    @echo.
    pause
    exit
)
for /f %%i in ('curl --write-out %%{http_code} --silent --output /dev/null --insecure https://raw.githubusercontent.com/amd64fox/SpotX/main/Install.ps1') do set STATUS_CODE=%%i 2>nul
if %STATUS_CODE% EQU 200 (
    powershell -Command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12}"; "& {(Invoke-WebRequest -UseBasicParsing 'https://raw.githubusercontent.com/amd64fox/SpotX/main/Install.ps1').Content | Invoke-Expression}"
)
if %STATUS_CODE% LSS 1 (
    echo No network connection
    @echo.
    echo Trying to reconnect via...
    TIMEOUT /T 5
    cls
    for /f %%i in ('curl --write-out %%{http_code} --silent --output /dev/null --insecure https://raw.githubusercontent.com/amd64fox/SpotX/main/Install.ps1') do set STATUS_CODE=%%i 2>nul
    if "!STATUS_CODE!" EQU "200 " (
        cls
        powershell -Command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12}"; "& {(Invoke-WebRequest -UseBasicParsing 'https://raw.githubusercontent.com/amd64fox/SpotX/main/Install.ps1').Content | Invoke-Expression}"
    ) else ( 
        echo Error again
        @echo.
        echo Check your internet connection
        @echo.
        echo Script stopped
        @echo.
        pause
        exit
    )
)
if %STATUS_CODE% GTR 100 if not %STATUS_CODE% EQU 200 (
    echo Failed to connect to github.com
    @echo.
    echo HTTP response code %STATUS_CODE%
    @echo.
    echo Trying to reconnect via...
    TIMEOUT /T 5
    cls
    for /f %%i in ('curl --write-out %%{http_code} --silent --output /dev/null --insecure https://raw.githubusercontent.com/amd64fox/SpotX/main/Install.ps1') do set STATUS_CODE=%%i 2>nul
    if "!STATUS_CODE!" EQU "200 " (
        cls
        powershell -Command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12}"; "& {(Invoke-WebRequest -UseBasicParsing 'https://raw.githubusercontent.com/amd64fox/SpotX/main/Install.ps1').Content | Invoke-Expression}"
    ) else (
        echo Error again
        @echo.
        echo Try to run after some time
        @echo.
        echo Script stopped
        @echo.
    )
)
pause
exit /b
