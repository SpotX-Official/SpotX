<# 
Name: Clear Spotify Cache.

Description: The script clears outdated cache from the listened music in Spotify.
Fires every time you completely close the client (If the client was minimized to tray then the script will not work).

For the APPDATA\Spotify\Data folder, the rule is that all cache files that are not used
by the customer more than the specified number of days will be deleted.

#>

$day = 7 # Number of days after which the cache is considered stale 

# Clear the \Data folder if it finds an outdated cache

try {
    If (!(Test-Path -Path $env:LOCALAPPDATA\Spotify\Data)) {
        "$(Get-Date -Format "dd/MM/yyyy HH:mm:ss") Folder Local\Spotify\Data not found" | Out-File log.txt -append
        exit	
    }
    $check = Get-ChildItem $env:LOCALAPPDATA\Spotify\Data -File -Recurse | Where-Object lastaccesstime -lt (get-date).AddDays(-$day)
    if ($check.Length -ge 1) {

        $count = $check
        $sum = $count | Measure-Object -Property Length -sum
        if ($sum.Sum -ge 104434441824) {
            $gb = "{0:N2} Gb" -f (($check | Measure-Object Length -s).sum / 1Gb)
            "$(Get-Date -Format "dd/MM/yyyy HH:mm:ss") Removed $gb obsolete cache" | Out-File log.txt -append
        }
        else {
            $mb = "{0:N2} Mb" -f (($check | Measure-Object Length -s).sum / 1Mb)
            "$(Get-Date -Format "dd/MM/yyyy HH:mm:ss") Removed $mb obsolete cache" | Out-File log.txt -append
        }
        Get-ChildItem $env:LOCALAPPDATA\Spotify\Data -File -Recurse | Where-Object lastaccesstime -lt (get-date).AddDays(-$day) | Remove-Item
    }
    if ($check.Length -lt 1) {
        "$(Get-Date -Format "dd/MM/yyyy HH:mm:ss") Stale cache not found" | Out-File log.txt -append
    }   
}
catch {
    "$(Get-Date -Format "dd/MM/yyyy HH:mm:ss") $error[0].Exception" | Out-File log.txt -append
}
exit