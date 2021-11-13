# Launch Spotify.exe and wait for the process to stop
Start-Process -FilePath $env:APPDATA\Spotify\Spotify.exe; wait-process -name Spotify

# This block deletes files by the last access time to it, files that have not been changed and have not been opened for more than the number of days you have selected will be deleted. If you need to replace with another number of days, then substitute the value in the 6th row and 118th column (The default is 7 days).
If (Test-Path -Path $env:LOCALAPPDATA\Spotify\Data) {
    Get-ChildItem $env:LOCALAPPDATA\Spotify\Data -File -Recurse | Where-Object lastaccesstime -lt (get-date).AddDays(-7) | Remove-Item
}

# Delete the file mercury.db if its size exceeds 100 MB.
If (Test-Path -Path $env:LOCALAPPDATA\Spotify\mercury.db) {
    $file_mercury = Get-Item "$env:LOCALAPPDATA\Spotify\mercury.db"
    if ($file_mercury.length -gt 100MB) { Get-ChildItem $env:LOCALAPPDATA\Spotify\mercury.db -File -Recurse | Remove-Item }
}