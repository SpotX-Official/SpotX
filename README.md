  <p align="center">
  <a href="https://github.com/amd64fox/SpotX/releases"><img src="https://github.com/amd64fox/SpotX/raw/main/.github/Pic/logo.png" />
</p>



<p align="center">        
      <a href="https://t.me/spotify_windows_mod"><img src="https://raw.githubusercontent.com/amd64fox/SpotX/main/.github/Pic/Shields/tg.svg"></a>
      <a href="https://www.youtube.com/results?search_query=https%3A%2F%2Fgithub.com%2Famd64fox%2FSpotX"><img src="https://raw.githubusercontent.com/amd64fox/SpotX/main/.github/Pic/Shields/youtube.svg"></a>
      <a href="https://cutt.ly/8EH6NuH"><img src="https://raw.githubusercontent.com/amd64fox/SpotX/main/.github/Pic/Shields/excel.svg"></a>
      </p>
     <h2> <div align="center"><b> Modified Spotify Client for Windows </b></div> </h2>

<h1>System requirements:</h1>


* <strong>OS: Windows 7-11</strong>
* <strong>Spotify: Recommended official version [1.1.88.612](https://cutt.ly/8EH6NuH)</strong>
* <strong>For Windows Desktop only (Microsoft store version is not suitable).</strong>
* <strong>PowerShell: 3 or higher</strong>

<h1>Features:</h1>

* <strong>Blocks all banner, video and audio ads in the client</strong>
* <strong>Unlocks the skip function of any track</strong>
* <strong>Full screen mode activated</strong>
* <strong>Hidden podcasts and episodes from the homepage (optional)</strong>
* <strong>Blocks automatic updates (optional)</strong>
* <strong>Automatic [cache clearing](https://github.com/amd64fox/SpotX/discussions/2) (optional)</strong>
* <strong>Enabled [enhance playlist](https://github.com/amd64fox/SpotX/discussions/50#discussion-4108773)</strong>
* <strong>Enabled [enhance liked songs UI](https://github.com/amd64fox/SpotX/discussions/50#discussioncomment-2851482)</strong> ([temporarily disabled](https://github.com/amd64fox/SpotX/discussions/49))
* <strong>Enabled [new lyrics](https://github.com/amd64fox/SpotX/discussions/50#discussioncomment-2851485)</strong>
* <strong>Enabled [new search with chips experience](https://github.com/amd64fox/SpotX/discussions/50#discussioncomment-2851545)</strong>
* <strong>Enabled [a condensed discography shelf on artist pages](https://github.com/amd64fox/SpotX/discussions/50#discussioncomment-2851591)</strong>
* <strong>Enabled [Ignore In Recommendations](https://github.com/amd64fox/SpotX/discussions/50#discussioncomment-2996165)</strong>
* <strong>Activated ["Made For You" in the left sidebar](https://github.com/amd64fox/SpotX/discussions/50#discussioncomment-2853981)</strong>
* <strong>Disabled Sentry (Prevented Sentry from sending console log/error/warning to Spotify developers)</strong>
* <strong>Disabled logging (Stopped various elements to log user interaction)</strong>
* <strong>Removed RTL rules (Removed all right-to-left CSS rules to simplify CSS files)</strong>
* <strong>Code minification</strong>


<h1>Fast installation / Update:</h1>

<details>
<summary><small>Usual installation</small></summary><p>
  
  <h4>During installation, you need to confirm some actions</h4>
  
* Just download and run [Install.bat](https://cutt.ly/PErptD8)

or

* Run The following command in PowerShell:
```ps1
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; iwr -useb 'https://raw.githubusercontent.com/amd64fox/SpotX/main/Install.ps1' | iex
```

</details>
  
  
<details>
<summary><small>Automatic installation</small></summary><p>
  
  <h4>Automatic installation without confirmation (remove Spotify MS, install over recommended version, remove podcasts from homepage, block updates, no cache clear installation)</h4>
  
  * Just download and run [Install_Auto.bat](https://cutt.ly/AKPeK8l)

or
  
```ps1
  [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; iex "& { $(iwr -useb 'https://raw.githubusercontent.com/amd64fox/SpotX/main/Install.ps1') } -confirm_uninstall_ms_spoti -confirm_spoti_recomended_over -podcasts_off -cache_off -block_update_on"
```


</details>


<details>
<summary><small>Installation for premium</small></summary><p>
  
  <h4>Usual installation only without ad blocking, for those who have a premium account</h4>
  
* Just download and run [Install_Prem.bat](https://cutt.ly/HKPeXZc)

or

* Run The following command in PowerShell:
```ps1
  [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; iex "& { $(iwr -useb 'https://raw.githubusercontent.com/amd64fox/SpotX/main/Install.ps1') } -premium"
```

</details>


<details>
<summary><small>Русский установщик</small></summary><p>
  
  <h4>Обычный установщик с подтверждениями на русском языке</h4>
  
* Скачайте и запустите [Install_Rus.bat](https://cutt.ly/ZEnk1qf)

или

* Запустите следующую строку напрямую в терминале PowerShell:
```ps1
  [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; iwr -useb 'https://raw.githubusercontent.com/amd64fox/SpotX/main/scripts/Install_Rus.ps1' | iex
```

</details>


<h1>Uninstall:</h1>

* Just run [Uninstall.bat](https://cutt.ly/dErpPEK)

or

* Reinstall Spotify ([Full uninstall](https://github.com/amd64fox/Uninstall-Spotify) recommended)



<h1>Possible problems:</h1>

 <details>
<summary><small>Outdated versions of PowerShell</small></summary><p>

If you are using Windows 7, there may be errors in the installation process due to an outdated version of NET Framework and PowerShell. 
   Do the following:
   * Upgrade to [NET Framework 4.8](https://go.microsoft.com/fwlink/?linkid=2088631)
   * Upgrade to [WMF 5.1](https://www.microsoft.com/en-us/download/details.aspx?id=54616)
   * Reboot your PC

</details>

 <details>
<summary><small>After running Install.bat, the message "Curl command line utility not found" appeared</small></summary><p>

The curl command was not found in the system (in windows 10 and above it comes out of the box), you need to install it manually:
  *  Follow the [link](http://www.confusedbycode.com/curl/#downloads) and download the installation file, depending on the bitness of the OS.
  *  We start the installation process, at the end we must restart the PC.
  
</details>


<details>
<summary><small>How do I go back to the previous version of the client ?</small></summary><p>

  If you have problems with the patch after upgrading the client version, then use this [tool](https://github.com/amd64fox/Rollback-Spotify) to revert back to the working    version.

</details>



<h1>Additional Notes:</h1>

* The repository is based on <a href="https://github.com/mrpond/BlockTheSpot">BlockTheSpot</a>, and also some tricks were taken from <a href="https://github.com/khanhas/spicetify-cli">spicetify-cli</a>, many thanks to the contributors
* SpotX will only work correctly on the latest versions of Spotify, please make sure of this before asking a question.  
* The modifiable files are replaced by the Spotify installer every time it is updated, so you will need to apply the patch again when this happens.
* [SpotX will be installed even if you are using Spicetify](https://github.com/amd64fox/SpotX/discussions/28#discussioncomment-2389043), but you may need to run Install.bat again after running the `spicetify apply` or other commands.
