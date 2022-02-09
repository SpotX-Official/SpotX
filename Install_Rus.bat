@echo off
Setlocal EnableDelayedExpansion
chcp 65001 >nul
for /f %%i in ('curl --write-out %%{http_code} --silent --output /dev/null --insecure https://raw.githubusercontent.com/amd64fox/SpotX/main/Install_rus.ps1') do set STATUS_CODE=%%i 2>nul
if %STATUS_CODE% EQU 200 (
chcp 866 >nul
powershell -Command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12}"; "& {(Invoke-WebRequest -UseBasicParsing 'https://raw.githubusercontent.com/amd64fox/SpotX/main/Install_rus.ps1').Content | Invoke-Expression}"
)
if %STATUS_CODE% LSS 1 (
echo Нет подключения к сети
echo Попытка повторного подключения через ...
TIMEOUT /T 5
cls
for /f %%i in ('curl --write-out %%{http_code} --silent --output /dev/null --insecure https://raw.githubusercontent.com/amd64fox/SpotX/main/Install_rus.ps1') do set STATUS_CODE=%%i 2>nul
if "!STATUS_CODE!" EQU "200 " (
cls
chcp 866 >nul
powershell -Command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12}"; "& {(Invoke-WebRequest -UseBasicParsing 'https://raw.githubusercontent.com/amd64fox/SpotX/main/Install_rus.ps1').Content | Invoke-Expression}"
) else ( 
echo Снова ошибка 
echo Проверьте свое интернет соединение
echo Скрипт остановлен
pause
exit
)
)
if %STATUS_CODE% GTR 100 if not %STATUS_CODE% EQU 200 (
echo Не удалось подключиться к github.com
echo Код ответа HTTP %STATUS_CODE%
echo Попытка повторного подключения через ...
TIMEOUT /T 5
cls
for /f %%i in ('curl --write-out %%{http_code} --silent --output /dev/null --insecure https://raw.githubusercontent.com/amd64fox/SpotX/main/Install_rus.ps1') do set STATUS_CODE=%%i 2>nul
if "!STATUS_CODE!" EQU "200 " (
cls
chcp 866 >nul
powershell -Command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12}"; "& {(Invoke-WebRequest -UseBasicParsing 'https://raw.githubusercontent.com/amd64fox/SpotX/main/Install_rus.ps1').Content | Invoke-Expression}"
) else (
echo Снова ошибка
echo Попробуйте запустить спустя некоторое время 
echo Скрипт остановлен
)
)
pause
exit