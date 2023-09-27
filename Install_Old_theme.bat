@echo off

%SYSTEMROOT%\System32\WindowsPowerShell\v1.0\powershell.exe -Command "&{[Net.ServicePointManager]::SecurityProtocol = 3072}; """"& { $(Invoke-WebRequest -UseBasicParsing 'https://spotx-official.github.io/SpotX/Install.ps1')} -v 1.2.13.661.ga588f749-4064 -confirm_spoti_recomended_over -block_update_on """" | Invoke-Expression"

pause
exit /b