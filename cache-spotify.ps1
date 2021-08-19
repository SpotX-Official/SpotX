# Launch Spotify.exe and wait for the process to stop
Start-Process -FilePath $env:APPDATA\Spotify\Spotify.exe; wait-process -name Spotify

# This block deletes files by the last access time to it, files that have not been changed and have not been opened for more than the number of days you have selected will be deleted. (number of days = seven)
If(Test-Path -Path $env:LOCALAPPDATA\Spotify\Data){
dir $env:LOCALAPPDATA\Spotify\Data -File -Recurse |? lastaccesstime -lt (get-date).AddDays(-7) |del
}

# Delete the file mercury.db if its size exceeds 100 MB.
If(Test-Path -Path $env:LOCALAPPDATA\Spotify\mercury.db){
$file_mercury = Get-Item "$env:LOCALAPPDATA\Spotify\mercury.db"
if ($file_mercury.length -gt 100MB) {dir $env:LOCALAPPDATA\Spotify\mercury.db -File -Recurse|del}
}