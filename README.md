  <p align="center">
  <a href="https://github.com/amd64fox/SpotX/releases"><img src="https://user-images.githubusercontent.com/62529699/145750769-3d74b068-2d87-4292-9f21-ddd4bcea6d50.png" />
</p>



<p align="center">        
      <a href="https://t.me/spotify_windows_mod"><img src="https://img.shields.io/badge/Telegram%20Channel-%20-blue?style=flat&logo=telegram"></a>
      <a href="https://www.youtube.com/results?search_query=https%3A%2F%2Fgithub.com%2Famd64fox%2FSpotX"><img src="https://img.shields.io/badge/-red?style=flat&logo=youtube&label=Tutorial%20videos%20on%20YouTube"></a>
      <a href="https://cutt.ly/8EH6NuH"><img src="https://img.shields.io/badge/Excel%20table--brightgreen.svg?style=flat&logo=microsoftexcel&label=Download official installer"></a>
      </p>
     <h2> <div align="center"><b> Modified Spotify Client for Windows </b></div> </h2>

❗❗❗ [Search Type (Voting)](https://github.com/amd64fox/SpotX/discussions/46)

<h1>System requirements:</h1>


* <strong>OS: Windows 7-11</strong>
* <strong>Spotify: Recommended official version [1.1.85.895](https://cutt.ly/8EH6NuH)</strong>
* <strong>For Windows Desktop only (Microsoft store version is not suitable).</strong>
* <strong>Free Account</strong>
* <strong>PowerShell: 3 or higher</strong>

<h1>Features:</h1>

* <strong>Blocks all banner, video and audio ads in the client</strong>
* <strong>Unlocks the skip function of any track</strong>
* <strong>Full screen mode activated</strong>
* <strong>Hidden podcasts and episodes from the homepage (optional)</strong>
* <strong>Blocks automatic updates (optional)</strong>
* <strong>Automatic [cache clearing](https://github.com/amd64fox/SpotX/discussions/2) (optional)</strong>
* <strong>Enabled [enhance playlist](https://user-images.githubusercontent.com/62529699/166843349-f544e354-3ce2-439b-9ac6-06010c9d7f9b.jpg)</strong>
* <strong>Enabled [new lyrics](https://www.reddit.com/r/truespotify/comments/uhj8ie/just_found_out_you_can_jump_to_a_lyrics_on/)</strong>
* <strong>Enabled [new search with chips experience](https://www.reddit.com/r/truespotify/comments/tt305m/new_search_with_chips_experience/)</strong>
* <strong>Enabled [a condensed discography shelf on artist pages](https://www.reddit.com/r/truespotify/comments/svc77g/condensed_discography_shelf_on_artist_pages/)</strong>
* <strong>Activated ["Made For You" in the left sidebar](https://user-images.githubusercontent.com/62529699/166842838-6309f168-3ff1-4559-a087-82cc9ea12b4b.jpg)</strong>
* <strong>Disabled Sentry (Prevented Sentry from sending console log/error/warning to Spotify developers)</strong>
* <strong>Disabled logging (Stopped various elements to log user interaction)</strong>
* <strong>Removed RTL rules (Removed all right-to-left CSS rules to simplify CSS files)</strong>
* <strong>Code minification</strong>


<h1>Fast installation / Update:</h1>

* Just download and run [Install.bat](https://cutt.ly/PErptD8)

or

* Run The following command in PowerShell:
```ps1
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; iwr -useb 'https://raw.githubusercontent.com/amd64fox/SpotX/main/Install.ps1' | iex
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



<h1>Additional Notes:</h1>

* The repository is based on <a href="https://github.com/mrpond/BlockTheSpot">BlockTheSpot</a>, and also some tricks were taken from <a href="https://github.com/khanhas/spicetify-cli">spicetify-cli</a>, many thanks to the contributors
* SpotX will only work correctly on the latest versions of Spotify, please make sure of this before asking a question.  
* The modifiable files are replaced by the Spotify installer every time it is updated, so you will need to apply the patch again when this happens.
* [SpotX will be installed even if you are using Spicetify](https://github.com/amd64fox/SpotX/discussions/28#discussioncomment-2389043), but you may need to run Install.bat again after running the `spicetify apply` or other commands.
