# Запускаем Spotify.exe и ждем завершения процесса
Start-Process -FilePath $env:APPDATA\Spotify\Spotify.exe; wait-process -name Spotify

# Этот блок удаляет файлы кэша по времени последнего доступа к нему, тоесть файлы которые не были изменены и не открывались больше указанного вами количества дней, будут удалены. Если нужно заменить на другое значение подставьте своё значение в 6 строку и 118 столбец (По умолчанию равно 7 дней).
If (Test-Path -Path $env:LOCALAPPDATA\Spotify\Data) {
    Get-ChildItem $env:LOCALAPPDATA\Spotify\Data -File -Recurse | Where-Object lastaccesstime -lt (get-date).AddDays(-7) | Remove-Item
}

# Удаляем файл mercury.db если его размер привышает 100 MB.
If (Test-Path -Path $env:LOCALAPPDATA\Spotify\mercury.db) {
    $file_mercury = Get-Item "$env:LOCALAPPDATA\Spotify\mercury.db"
    if ($file_mercury.length -gt 100MB) { Get-ChildItem $env:LOCALAPPDATA\Spotify\mercury.db -File -Recurse | Remove-Item }
}