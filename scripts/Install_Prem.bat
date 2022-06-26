@echo off

powershell -Command "&{[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12}; """"& { $(Invoke-WebRequest -UseBasicParsing 'https://raw.githubusercontent.com/amd64fox/SpotX/main/Install.ps1')} -premium """" | Invoke-Expression"

pause
exit /b