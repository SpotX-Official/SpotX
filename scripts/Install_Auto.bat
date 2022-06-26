@echo off

powershell -Command "&{[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12}; """"& { $(Invoke-WebRequest -UseBasicParsing 'https://raw.githubusercontent.com/amd64fox/SpotX/main/Install.ps1')} -confirm_uninstall_ms_spoti -confirm_spoti_recomended_over -podcasts_off -cache_off -block_update_on """" | Invoke-Expression"

pause
exit /b