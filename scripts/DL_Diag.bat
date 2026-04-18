@echo off
setlocal

set "script_name=DL_Diag.ps1"
set "branch_name=dl-diag-scripts"
set "script_dir=%~dp0"
set "local_script=%script_dir%%script_name%"
set "branch_url=https://raw.githubusercontent.com/SpotX-Official/SpotX/refs/heads/%branch_name%/scripts/%script_name%"
set "main_url=https://raw.githubusercontent.com/SpotX-Official/SpotX/refs/heads/main/scripts/%script_name%"
set "temp_script=%TEMP%\SpotX-%script_name%"
set "ps=%SYSTEMROOT%\System32\WindowsPowerShell\v1.0\powershell.exe"

if exist "%local_script%" (
    %ps% -NoProfile -ExecutionPolicy Bypass -File "%local_script%"
) else (
    %ps% -NoProfile -ExecutionPolicy Bypass ^
    -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12; $out='%temp_script%'; $urls=@('%branch_url%','%main_url%'); $downloaded=$false; foreach ($url in $urls) { try { Invoke-WebRequest -UseBasicParsing -Uri $url -OutFile $out -ErrorAction Stop; $downloaded=$true; break } catch {} }; if (-not $downloaded) { throw 'Failed to download diagnostic script' }; & $out"
)

pause
endlocal
exit /b
