@echo off

%SYSTEMROOT%\System32\WindowsPowerShell\v1.0\powershell.exe -Command "&{[Net.ServicePointManager]::SecurityProtocol = 3072}; """"& { $((Invoke-WebRequest -UseBasicParsing 'https://cdn.statically.io/gh/amd64fox/SpotX/main/Install.ps1').Content)} -new_theme """" | Invoke-Expression"

pause
exit /b