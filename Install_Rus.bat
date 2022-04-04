@echo off
Setlocal EnableDelayedExpansion
set "exec=powershell $PSVersionTable.PSVersion.major"
for /f %%i in ('%exec%') do set ps-v=%%i 2>nul
chcp 65001 >nul
if  %ps-v% LEQ 2 (
    echo Powershell %ps-v%не поддерживается
    @echo.
    echo Пожалуйста, прочитайте инструкцию "Устаревшие версии PowerShell" по следующей ссылке
    @echo.
    echo "https://4pda.to/forum/index.php?act=findpost&pid=104279894&anchor=outdated_versions"
    @echo.
    pause
    exit
)
curl -V >nul 2>&1
if %errorlevel% EQU 9009 (
    echo Команда "Curl" отсутствует в системе
    @echo.
    echo Пожалуйста, перейдите по следующей ссылке для ручной установки "Curl"
    @echo.
    echo "http://www.confusedbycode.com/curl/#downloads"
    @echo.
    pause
    exit
)
for /f %%i in ('curl --write-out %%{http_code} --silent --output /dev/null --insecure https://raw.githubusercontent.com/amd64fox/SpotX/main/Install_Rus.ps1') do set STATUS_CODE=%%i 2>nul
if %STATUS_CODE% EQU 200 (
    chcp 866 >nul
    powershell -Command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12}"; "& {(Invoke-WebRequest -UseBasicParsing 'https://raw.githubusercontent.com/amd64fox/SpotX/main/Install_Rus.ps1').Content | Invoke-Expression}"
)
if %STATUS_CODE% LSS 1 (
    echo Нет подключения к сети
    @echo.
    echo Попытка повторного подключения через ...
    TIMEOUT /T 5
    cls
    for /f %%i in ('curl --write-out %%{http_code} --silent --output /dev/null --insecure https://raw.githubusercontent.com/amd64fox/SpotX/main/Install_Rus.ps1') do set STATUS_CODE=%%i 2>nul
    if "!STATUS_CODE!" EQU "200 " (
        cls
        chcp 866 >nul
        powershell -Command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12}"; "& {(Invoke-WebRequest -UseBasicParsing 'https://raw.githubusercontent.com/amd64fox/SpotX/main/Install_Rus.ps1').Content | Invoke-Expression}"
    ) else ( 
        echo Снова ошибка 
        @echo.
        echo Проверьте свое интернет соединение
        @echo.
        echo Скрипт остановлен
        @echo.
        pause
        exit
    )
)
if %STATUS_CODE% GTR 100 if not %STATUS_CODE% EQU 200 (
    echo Не удалось подключиться к github.com
    @echo.
    echo Код ответа HTTP %STATUS_CODE%
    @echo.
    echo Попытка повторного подключения через ...
    TIMEOUT /T 5
    cls
    for /f %%i in ('curl --write-out %%{http_code} --silent --output /dev/null --insecure https://raw.githubusercontent.com/amd64fox/SpotX/main/Install_Rus.ps1') do set STATUS_CODE=%%i 2>nul
    if "!STATUS_CODE!" EQU "200 " (
        cls
        chcp 866 >nul
        powershell -Command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12}"; "& {(Invoke-WebRequest -UseBasicParsing 'https://raw.githubusercontent.com/amd64fox/SpotX/main/Install_Rus.ps1').Content | Invoke-Expression}"
    ) else (
        echo Снова ошибка
        @echo.
        echo Попробуйте запустить спустя некоторое время
        @echo.
        echo Скрипт остановлен
        @echo.
    )
)
pause
exit