  <p align="center">
  <a href="https://github.com/amd64fox/SpotX/releases"><img src="https://user-images.githubusercontent.com/62529699/145750769-3d74b068-2d87-4292-9f21-ddd4bcea6d50.png" />
</p>



<p align="center">        
      <a href="https://t.me/amd64fox"><img src="https://img.shields.io/badge/%40Amd64fox-%40Amd64fox-blue.svg?style=flat&logo=telegram&label=Telegram"></a>
      <a href="https://youtu.be/d2-bKw6yTjo"><img src="https://img.shields.io/badge/-red?style=flat&logo=youtube&label=Tutorial%20on%20Youtube"></a>
      <a href="https://4pda.to/forum/index.php?showtopic=715234&view=findpost&p=104279894"><img src="https://img.shields.io/badge/4PDA-Post-yellow"></a>
      </p>
     <h2> <div align="center"><b> Modified Spotify Client for Windows </b></div> </h2>


<h1>System requirements:</h1>


* <strong>OS: Windows 7-11</strong>
* <strong>Spotify: Recommended official version [1.1.83.954](https://cutt.ly/8EH6NuH)</strong>
* <strong>For Windows Desktop only (Microsoft store version is not suitable).</strong>
* <strong>Free Account</strong>
* <strong>PowerShell: 3 or higher</strong>

<h1>Features:</h1>

* <strong>Blocks all banner, video and audio ads in the client</strong>
* <strong>Unlocks the skip function of any track</strong>
* <strong>Full screen mode activated</strong>
* <strong>Podcasts disabled (optional)</strong>
* <strong>Blocks automatic updates (optional)</strong>
* <strong>[Automatic cache clearing](https://github.com/amd64fox/SpotX/discussions/2) (optional)</strong>
* <strong>Enabled Enhance playlist</strong>
* <strong>Enabled the new Search with chips experience</strong>
* <strong>Enabled a condensed discography shelf on artist pages</strong>
* <strong>Activated "Made For You" in the left sidebar</strong>
* <strong>Disabled Sentry (Prevented Sentry from sending console log/error/warning to Spotify developers)</strong>
* <strong>Disabled logging (Stopped various elements to log user interaction)</strong>
* <strong>Removed RTL rules (Removed all right-to-left CSS rules to simplify CSS files)</strong>
* <strong>Code minification</strong>


<h1>Fast installation / Update:</h1>

* Just download and run [Install.bat](https://cutt.ly/PErptD8)

or

* Run The following command in PowerShell:
```ps1
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -UseBasicParsing 'https://raw.githubusercontent.com/amd64fox/SpotX/main/Install.ps1' | Invoke-Expression
```

<h1>Uninstall:</h1>

* Just run [Uninstall.bat](https://cutt.ly/dErpPEK)

or

* Reinstall Spotify    



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


 <details>
<summary><small>I want to return old icons</small></summary><p>

  [There is an answer here](https://github.com/amd64fox/SpotX/discussions/20#discussioncomment-1922206), if you do not like the new icons leave your comment there.

</details>



<h1>Additional Notes:</h1>

* The repository is based on <a href="https://github.com/mrpond/BlockTheSpot">BlockTheSpot</a>, and also some tricks were taken from <a href="https://github.com/khanhas/spicetify-cli">spicetify-cli</a>, many thanks to the contributors
* SpotX will only work correctly on the latest versions of Spotify, please make sure of this before asking a question.  
* The modifiable files are replaced by the Spotify installer every time it is updated, so you will need to apply the patch again when this happens.
* [SpotX will be installed even if you are using Spicetify](https://github.com/amd64fox/SpotX/discussions/28#discussioncomment-2389043), but you may need to run Install.bat again after running the `spicetify apply` or other commands.
