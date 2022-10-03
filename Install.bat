@echo off

IF EXIST "%ProgramFiles%\PowerShell\7\pwsh.exe" (
         "%ProgramFiles%\PowerShell\7\pwsh.exe" -Command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (iwr -useb 'https://raw.githubusercontent.com/amd64fox/SpotX/main/Install.ps1').Content | iex}"
  ) ELSE (%SYSTEMROOT%\System32\WindowsPowerShell\v1.0\powershell.exe -Command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12}"; "& {(Invoke-WebRequest -UseBasicParsing 'https://raw.githubusercontent.com/amd64fox/SpotX/main/Install.ps1').Content | Invoke-Expression}")

pause
exit /b
