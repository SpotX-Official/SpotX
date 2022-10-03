@echo off

%SYSTEMROOT%\System32\WindowsPowerShell\v1.0\powershell.exe -Command "&{[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12}; """"& { $((Invoke-WebRequest -UseBasicParsing 'https://raw.githubusercontent.com/SpotX-CLI/SpotX/main/Install.ps1').Content)} -confirm_uninstall_ms_spoti -confirm_spoti_recomended_over -podcasts_off -cache_off -block_update_on -start_spoti """" | Invoke-Expression"

pause
exit /b