@echo off

ping www.github.com >nul 2>&1
if %errorlevel% neq 0 (
  color 0C 
  echo Please Connect to the Internet First.
  pause
  color 07 
  exit /b 1
)

%SYSTEMROOT%\System32\WindowsPowerShell\v1.0\powershell.exe -Command "&{[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12}; """"& { $((Invoke-WebRequest -UseBasicParsing 'https://raw.githubusercontent.com/amd64fox/SpotX/main/Install.ps1').Content)} -new_theme """" | Invoke-Expression"

pause
exit /b
