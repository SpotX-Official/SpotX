@echo off
chcp 65001 >nul
FOR /f %%i IN ('curl --write-out %%{http_code} --silent --output /dev/null --insecure https://raw.githubusercontent.com/amd64fox/SpotX/main/Install_rus.ps1') do SET STATUS_CODE=%%i 2>nul
IF %STATUS_CODE% == 200 (
chcp 866 >nul
powershell -Command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12}"; "& {(Invoke-WebRequest -UseBasicParsing 'https://raw.githubusercontent.com/amd64fox/SpotX/main/Install_rus.ps1').Content | Invoke-Expression}"
) else (
  echo Нет доступа к github.com, проверьте свое интернет соединение.
  echo Код ответа HTTP %STATUS_CODE% 
  echo Скрипт завершен.
)
pause
exit