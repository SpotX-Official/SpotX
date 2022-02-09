@echo off
Setlocal EnableDelayedExpansion
for /f %%i in ('curl --write-out %%{http_code} --silent --output /dev/null --insecure https://raw.githubusercontent.com/amd64fox/SpotX/main/Install.ps1') do set STATUS_CODE=%%i 2>nul
if %STATUS_CODE% EQU 200 (
powershell -Command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12}"; "& {Invoke-WebRequest -UseBasicParsing 'https://raw.githubusercontent.com/amd64fox/SpotX/main/Install.ps1' | Invoke-Expression}"
)
if %STATUS_CODE% LSS 1 (
echo No network connection
echo Trying to reconnect via...
TIMEOUT /T 5
cls
for /f %%i in ('curl --write-out %%{http_code} --silent --output /dev/null --insecure https://raw.githubusercontent.com/amd64fox/SpotX/main/Install.ps1') do set STATUS_CODE=%%i 2>nul
if "!STATUS_CODE!" EQU "200 " (
cls
powershell -Command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12}"; "& {Invoke-WebRequest -UseBasicParsing 'https://raw.githubusercontent.com/amd64fox/SpotX/main/Install.ps1' | Invoke-Expression}"
) else ( 
echo Error again
echo Check your internet connection
echo Script stopped
pause
exit
)
)
if %STATUS_CODE% GTR 100 if not %STATUS_CODE% EQU 200 (
echo Failed to connect to github.com
echo HTTP response code %STATUS_CODE%
echo Trying to reconnect via...
TIMEOUT /T 5
cls
for /f %%i in ('curl --write-out %%{http_code} --silent --output /dev/null --insecure https://raw.githubusercontent.com/amd64fox/SpotX/main/Install.ps1') do set STATUS_CODE=%%i 2>nul
if "!STATUS_CODE!" EQU "200 " (
cls
powershell -Command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12}"; "& {Invoke-WebRequest -UseBasicParsing 'https://raw.githubusercontent.com/amd64fox/SpotX/main/Install.ps1' | Invoke-Expression}"
) else (
echo Error again
echo Try to run after some time
echo Script stopped
)
)
pause
exit