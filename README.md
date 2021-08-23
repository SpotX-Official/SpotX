<center>
    <h1 align="center">SpotX</h1>
    <h4 align="center">A multi-purpose adblocker and skip-bypass for the <strong>Windows</strong> Spotify desktop application.</h4>
    <h5 align="center">(The repository is based on BlockTheSpot, many thanks to the contributors)</h5>
    <p align="center">
        <strong>Last tested version:</strong> 1.1.66.580
       </p> 
</center>




<h1>Features:</h1>

* <strong>For [Windows Desktop](https://www.spotify.com/download/windows/) only. (Microsoft store version is not suitable)</strong>
* <strong>Blocks all banner, video and audio ads in the client</strong>
* <strong>Unlocks the skip function of any track</strong>
* <strong>Blocks automatic updates (optional)</strong>
* <strong>[Automatic cache clearing](https://github.com/amd64fox/SpotX/discussions/2) (optional)</strong>



<h1>Fast installation / Update:</h1>

* Just download and run [Install.bat](https://github.com/amd64fox/SpotX/releases/download/1.0/Install.bat)

or

* Run The following command in PowerShell:
```ps1
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -UseBasicParsing 'https://raw.githubusercontent.com/amd64fox/SpotX/main/Install.ps1' | Invoke-Expression
```

<h1>Uninstall:</h1>

* Just run [Uninstall.bat](https://github.com/amd64fox/SpotX/releases/download/1.0/Uninstall.bat)

or

* Reinstall Spotify    



<h1>Possible problems:</h1>



<h3>Outdated versions of PowerShell</h3>
   
  If you are using Windows 7 or Windows 8.1, there may be errors in the installation process due to an outdated version of NET Framework and PowerShell. 
   Do the following:
   * Upgrade to [NET Framework 4.8](https://go.microsoft.com/fwlink/?linkid=2088631)
   * Upgrade to [WMF 5.1](https://www.microsoft.com/en-us/download/details.aspx?id=54616)
   * Reboot your PC
   
   <strong>Note:</strong> For Windows 8 it is not possible to upgrade the PowerShell version, please upgrade to Windows 8.1 or 10


<h3>High access rights are set for PowerShell</h3>

For some PCs, for full PowerShell to work, you need to set the permissions at least to the `RemoteSigned` position.
To check your access rights:
  * Call PowerShell Console `Win + R` write `powershell` and `Ok`
  * Enter the command `Get-ExecutionPolicy`
  * If your rights are `Restricted` or `AllSigned` then enter the command 
```ps1
   Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned –Force
````
  
  

<h1>Additional Notes:</h1>

* BlockTheSpot might only works as expected with the last tested version. Please check it before opening an issue.  
* "chrome_elf.dll" gets replaced by the Spotify installer each time it updates, hence why you'll probably need to apply the patch again when it happens
* [Spicetify](https://github.com/khanhas/spicetify-cli) users will need to reapply BlockTheSpot after applying a Spicetify patches.
* If you notice an error, please leave your comment in the [discussions](https://github.com/amd64fox/SpotX/discussions/new), be sure to attach screenshots.
