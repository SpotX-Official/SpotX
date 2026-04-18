@echo off
setlocal

set "script_name=DL_Diag.ps1"
set "raw_url=https://raw.githubusercontent.com/SpotX-Official/SpotX/refs/heads/main/scripts/%script_name%"
set "mirror_url=https://spotx-official.github.io/SpotX/scripts/%script_name%"
set "temp_script=%TEMP%\%script_name%"
set "ps=%SYSTEMROOT%\System32\WindowsPowerShell\v1.0\powershell.exe"

%ps% -NoProfile -ExecutionPolicy Bypass ^
-Command "[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12; $raw='%raw_url%'; $mirror='%mirror_url%'; $out='%temp_script%'; try { Invoke-WebRequest -UseBasicParsing -Uri $raw -OutFile $out -ErrorAction Stop } catch { Invoke-WebRequest -UseBasicParsing -Uri $mirror -OutFile $out -ErrorAction Stop }; & $out"

pause
endlocal
exit /b
