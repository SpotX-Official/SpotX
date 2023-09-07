@echo off

%SYSTEMROOT%\System32\WindowsPowerShell\v1.0\powershell.exe -Command """""& {$(Invoke-RestMethod -UseBasicParsing 'https://cdn.jsdelivr.net/gh/amd64fox/SpotX@main/Install.ps1')} -premium -new_theme """" | Invoke-Expression"

pause
exit /b