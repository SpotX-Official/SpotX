@echo off
FOR /f %%i IN ('curl --write-out %%{http_code} --silent --output /dev/null --insecure https://raw.githubusercontent.com/amd64fox/SpotX/main/Install.ps1') do SET STATUS_CODE=%%i 2>nul
IF %STATUS_CODE% == 200 (
powershell -Command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12}"; "& {Invoke-WebRequest -UseBasicParsing 'https://raw.githubusercontent.com/amd64fox/SpotX/main/Install.ps1' | Invoke-Expression}"
) else (
  echo Can't access github.com, please check your internet connection.
  echo HTTP status code %STATUS_CODE%
  echo Script stopped.
) 
pause
exit