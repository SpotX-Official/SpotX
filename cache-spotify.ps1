# Запускаем Spotify.exe и ждем завершения процесса
Start-Process -FilePath $env:APPDATA\Spotify\Spotify.exe; wait-process -name Spotify

# Этот блок удаляет файлы кэша по времени последнего доступа к нему, тоесть файлы которые не были изменены и не открывались больше указанного вами количества дней, будут удалены. Если нужно заменить на другое значение подствьте своё число в ln 6 col 98 (количество дней = seven)
If (Test-Path -Path $env:LOCALAPPDATA\Spotify\Data) {
    dir $env:LOCALAPPDATA\Spotify\Data -File -Recurse | ? lastaccesstime -lt (get-date).AddDays(-7) | del
}

# Удаляем файл mercury.db если его размер привышает 100 MB.
If (Test-Path -Path $env:LOCALAPPDATA\Spotify\mercury.db) {
    $file_mercury = Get-Item "$env:LOCALAPPDATA\Spotify\mercury.db"
    if ($file_mercury.length -gt 100MB) { dir $env:LOCALAPPDATA\Spotify\mercury.db -File -Recurse | del }
}