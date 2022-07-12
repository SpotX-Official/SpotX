  <p align="center">
  <a href="https://github.com/amd64fox/SpotX/releases"><img src="https://github.com/amd64fox/SpotX/raw/main/.github/Pic/logo.png" />
</p>



<p align="center">        
      <a href="https://t.me/spotify_windows_mod"><img src="https://raw.githubusercontent.com/amd64fox/SpotX/main/.github/Pic/Shields/tg.svg"></a>
      <a href="https://www.youtube.com/results?search_query=https%3A%2F%2Fgithub.com%2Famd64fox%2FSpotX"><img src="https://raw.githubusercontent.com/amd64fox/SpotX/main/.github/Pic/Shields/youtube.svg"></a>
      <a href="https://cutt.ly/8EH6NuH"><img src="https://raw.githubusercontent.com/amd64fox/SpotX/main/.github/Pic/Shields/excel.svg"></a>
      </p>
     <h2> <div align="center"><b> Modified Spotify Client for Windows </b></div> </h2>

<h1>System requirements</h1>


* <strong>OS: Windows 7-11</strong>
* <strong>Spotify: Recommended official version [1.1.89.862](https://cutt.ly/8EH6NuH)</strong>
* <strong>For Windows Desktop only (Microsoft store version is not suitable).</strong>
* <strong>PowerShell: 3 or higher</strong>

<h1>Features</h1>

* <strong>Blocks all banner, video and audio ads in the client</strong>
* <strong>Unlocks the skip function of any track</strong>
* <strong>Full screen mode activated</strong>
* <strong>Hidden podcasts and episodes from the homepage (optional)</strong>
* <strong>Blocks automatic updates (optional)</strong>
* <strong>Automatic [cache clearing](https://github.com/amd64fox/SpotX/discussions/2) (optional)</strong>
* <strong>Enabled [enhance playlist](https://github.com/amd64fox/SpotX/discussions/50#discussion-4108773)</strong>
* <strong>Enabled [enhance liked songs UI](https://github.com/amd64fox/SpotX/discussions/50#discussioncomment-2851482)</strong>
* <strong>Enabled [new lyrics](https://github.com/amd64fox/SpotX/discussions/50#discussioncomment-2851485)</strong>
* <strong>Enabled [new search with chips experience](https://github.com/amd64fox/SpotX/discussions/50#discussioncomment-2851545)</strong>
* <strong>Enabled [a condensed discography shelf on artist pages](https://github.com/amd64fox/SpotX/discussions/50#discussioncomment-2851591)</strong>
* <strong>Enabled [Ignore In Recommendations](https://github.com/amd64fox/SpotX/discussions/50#discussioncomment-2996165)</strong>
* <strong>Activated ["Made For You" in the left sidebar](https://github.com/amd64fox/SpotX/discussions/50#discussioncomment-2853981)</strong>
* <strong>Disabled Sentry (Prevented Sentry from sending console log/error/warning to Spotify developers)</strong>
* <strong>Disabled logging (Stopped various elements to log user interaction)</strong>
* <strong>Removed RTL rules (Removed all right-to-left CSS rules to simplify CSS files)</strong>
* <strong>Code minification</strong>


<h1>Fast installation / Update</h1>
<h3>Choose installation type:</h3>
<details>
<summary><small>Usual installation</small></summary><p>
  
  <h4>During installation, you need to confirm some actions</h4>
  
* Just download and run [Install.bat](https://raw.githack.com/amd64fox/SpotX/main/Install.bat) 

or

* Run The following command in PowerShell:
```ps1
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (iwr -useb 'https://raw.githubusercontent.com/amd64fox/SpotX/main/Install.ps1').Content | iex
```

</details>
  
  
<details>
<summary><small>Automatic installation</small></summary><p>
  
  <h4>Automatic installation without confirmation, what does it do?</h4> 
  
  - Automatic removal of Spotify MS if it was found 
  - Automatic installation of the recommended version of Spotify (if another client has already been found, it will be installed over) 
  - Removal of podcasts from the main page 
  - Automatic blocking of Spotify updates
  - Without clearing the cache
  - After the installation is completed, the client will autorun.
  
<h4> </h4>

* Just download and run [Install_Auto.bat](https://raw.githack.com/amd64fox/SpotX/main/scripts/Install_Auto.bat)

or 
  - Run The following command in PowerShell:
```ps1
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; iex "& { $((iwr -useb 'https://raw.githubusercontent.com/amd64fox/SpotX/main/Install.ps1').Content) } -confirm_uninstall_ms_spoti -confirm_spoti_recomended_over -podcasts_off -cache_off -block_update_on -start_spoti"
```


</details>


<details>
<summary><small>Installation for premium</small></summary><p>
  
  <h4>Usual installation only without ad blocking, for those who have a premium account</h4>
  
* Just download and run [Install_Prem.bat](https://raw.githack.com/amd64fox/SpotX/main/scripts/Install_Prem.bat)

or

* Run The following command in PowerShell:
```ps1
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; iex "& { $((iwr -useb 'https://raw.githubusercontent.com/amd64fox/SpotX/main/Install.ps1').Content) } -premium"
```

</details>


<details>
<summary><small>Installing with parameters</small></summary><p>

You can specify various parameters for a more flexible installation, more [details here](https://github.com/amd64fox/SpotX/discussions/60)

</details>


<details>
<summary><small>Установка на русском</small></summary><p>
  
Теперь установка на русском языке доступна в основном скрипте, просто скачайте и запустите `Install.bat` или выполните другие типы установки указанные выше.

</details>


<h1>Uninstall</h1>

* Just run [Uninstall.bat](https://cutt.ly/dErpPEK)

or

* Reinstall Spotify ([Full uninstall](https://github.com/amd64fox/Uninstall-Spotify) recommended)



<h1>Possible problems</h1>


 <details>
<summary><small>In most cases, this helps solve problems.</small></summary><p>

If you notice an error or other malfunction in the mod or in its installation, then do not rush to create a problem report, try this couple of simple steps, this helps to solve a large number of different bugs:
   * Completely remove Spotify so that there are no tails from the old versions of the client, [this patch](https://github.com/amd64fox/Uninstall-Spotify) will do it for you in one click.
   * Also, as an additional measure, look at your host file, it should not contain different URLs that can cause the client to work incorrectly, even if you are sure that you did not add anything to it, then go into it anyway and check it for sure, since Some ad blockers that you may have used in the past may have added entries to the host file automatically without your consent.
   To quickly open the host file, press `Win + R` and enter `%WinDir%\System32\Drivers\Etc\hosts`, in order for the system to allow you to edit the file, you need to open it as an administrator.
   * If you still see errors, then install the original client and check this error there, if the error is present in the original client, then here you need to wait for a fix from the Spotify developers.
    To expedite resolution of a problem in the original client, please create a problem report on their [support forum](https://community.spotify.com/t5/Desktop-Windows/bd-p/desktop_windows).
    In the meantime, you are waiting for a fix, you can temporarily return to the previous version of Spotify that worked for you and block updates in it, [this instruction](https://github.com/amd64fox/Rollback-Spotify) will help you with this.

</details>

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



<h1>Additional Notes</h1>

* The repository is based on <a href="https://github.com/mrpond/BlockTheSpot">BlockTheSpot</a>, and also some tricks were taken from <a href="https://github.com/khanhas/spicetify-cli">spicetify-cli</a>, many thanks to the contributors
* SpotX will only work correctly on the latest versions of Spotify, please make sure of this before asking a question.  
* The modifiable files are replaced by the Spotify installer every time it is updated, so you will need to apply the patch again when this happens.
* [SpotX will be installed even if you are using Spicetify](https://github.com/amd64fox/SpotX/discussions/28#discussioncomment-2389043), but you may need to run Install.bat again after running the `spicetify apply` or other commands.
