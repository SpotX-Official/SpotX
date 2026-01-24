@echo off

:: Line for changing spotx parameters, each parameter should be separated by a space
set param=-confirm_uninstall_ms_spoti -confirm_spoti_recomended_over -podcasts_off -block_update_on -start_spoti -new_theme -adsections_off -lyrics_stat spotify

set url='https://raw.githubusercontent.com/NimuthuGanegoda/SpotFreedom/main/run.ps1'
set tls=[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12;

%SYSTEMROOT%\System32\WindowsPowerShell\v1.0\powershell.exe ^
-Command %tls% $p='%param%'; """ & { iwr -useb %url% } $p """" | iex

pause
exit /b