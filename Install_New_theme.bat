@echo off

:: Line for changing spotx parameters, each parameter should be separated by a space
set param=-new_theme

set url='https://raw.githubusercontent.com/NimuthuGanegoda/SpotFreedom/main/run.ps1'
set tls=[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12;

%SYSTEMROOT%\System32\WindowsPowerShell\v1.0\powershell.exe ^
-Command "%tls% $target = Join-Path $env:TEMP 'SpotFreedom_Install.ps1'; Invoke-WebRequest -Uri %url% -OutFile $target -UseBasicParsing; & $target %param%; Remove-Item $target -Force -ErrorAction SilentlyContinue"

pause
exit /b