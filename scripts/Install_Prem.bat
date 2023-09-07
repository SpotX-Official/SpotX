@echo off

%SYSTEMROOT%\System32\WindowsPowerShell\v1.0\powershell.exe -Command "&{[Net.ServicePointManager]::SecurityProtocol = 3072}; """"& { $(Invoke-WebRequest -UseBasicParsing 'https://amd64fox.github.io/SpotX/Install.ps1')} -premium -new_theme """" | Invoke-Expression"

pause
exit /b