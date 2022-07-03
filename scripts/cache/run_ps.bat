@echo off
start "" /wait "%Appdata%\Spotify\Spotify.exe"
powershell.exe -ExecutionPolicy Bypass -nologo -noninteractive -command "& '.\cache_spotify.ps1'"