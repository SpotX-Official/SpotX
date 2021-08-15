command = "powershell.exe -nologo -noninteractive -command %appdata%\Spotify\cache-spotify.ps1"
set shell = CreateObject("WScript.Shell")
shell.Run command,0, false