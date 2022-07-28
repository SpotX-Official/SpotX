  <p align="center">
  <a href="https://github.com/amd64fox/SpotX/releases"><img src="https://github.com/amd64fox/SpotX/raw/main/.github/Pic/logo.png" />
</p>

<p align="center">        
      <a href="https://t.me/spotify_windows_mod"><img src="https://raw.githubusercontent.com/amd64fox/SpotX/main/.github/Pic/Shields/tg.svg"></a>
      <a href="https://www.youtube.com/results?search_query=https%3A%2F%2Fgithub.com%2Famd64fox%2FSpotX"><img src="https://raw.githubusercontent.com/amd64fox/SpotX/main/.github/Pic/Shields/youtube.svg"></a>
      <a href="https://cutt.ly/8EH6NuH"><img src="https://raw.githubusercontent.com/amd64fox/SpotX/main/.github/Pic/Shields/excel.svg"></a>
      <a href="https://github.com/amd64fox/SpotX/blob/main/.github/Doc/FAQ.md"><img src="https://raw.githubusercontent.com/amd64fox/SpotX/main/.github/Pic/Shields/faq.svg"></a>
      </p>

    <h2> <div align="center"><b> Modified Spotify Client for Windows </b></div> </h2>

<h1>System requirements</h1>

- <strong>OS: Windows 7-11</strong>
- <strong>Spotify: Recommended official version [1.1.90.859](https://cutt.ly/8EH6NuH)</strong>
- <strong>For Windows Desktop only (Microsoft store version is not suitable).</strong>
- <strong>PowerShell: 3 or higher</strong>

<h1>Features</h1>

- <strong>Blocks all banner, video and audio ads in the client</strong>
- <strong>Unlocks the skip function of any track</strong>
- <strong>Full screen mode activated</strong>
- <strong>Hidden podcasts and episodes from the homepage (optional)</strong>
- <strong>Blocks automatic updates (optional)</strong>
- <strong>Automatic [cache clearing](https://github.com/amd64fox/SpotX/discussions/2) (optional)</strong>
- <strong>Enabled [enhance playlist](https://github.com/amd64fox/SpotX/discussions/50#discussion-4108773)</strong>
- <strong>Enabled [enhance liked songs UI](https://github.com/amd64fox/SpotX/discussions/50#discussioncomment-2851482)</strong>
- <strong>Enabled [new lyrics](https://github.com/amd64fox/SpotX/discussions/50#discussioncomment-2851485)</strong>
- <strong>Enabled [a condensed discography shelf on artist pages](https://github.com/amd64fox/SpotX/discussions/50#discussioncomment-2851591)</strong>
- <strong>Enabled [Ignore In Recommendations](https://github.com/amd64fox/SpotX/discussions/50#discussioncomment-2996165)</strong>
- <strong>Enabled [Equalizer](https://github.com/amd64fox/SpotX/discussions/50#discussioncomment-3179778)</strong>
- <strong>Enabled [new device picker panel](https://github.com/amd64fox/SpotX/discussions/50#discussioncomment-3179782)</strong>
- <strong>Activated ["Made For You" in the left sidebar](https://github.com/amd64fox/SpotX/discussions/50#discussioncomment-2853981)</strong>
- <strong>Disabled Sentry (Prevented Sentry from sending console log/error/warning to Spotify developers)</strong>
- <strong>Disabled logging (Stopped various elements to log user interaction)</strong>
- <strong>Removed RTL rules (Removed all right-to-left CSS rules to simplify CSS files)</strong>
- <strong>Code minification</strong>

<h1>Fast installation / Update</h1>
<h3>Choose installation type:</h3>
<details>
<summary><small>Usual installation</small></summary><p>
  
  #### During installation, you need to confirm some actions, also contains:

  - All [experimental features](https://github.com/amd64fox/SpotX/discussions/50) included

  <h4> </h4>
  
#### Just download and run [Install.bat](https://raw.githack.com/amd64fox/SpotX/main/Install.bat)

or

#### Run The following command in PowerShell:

```ps1
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (iwr -useb 'https://raw.githubusercontent.com/amd64fox/SpotX/main/Install.ps1').Content | iex
```

</details>
  
<details>
<summary><small>Automated basic installation</small></summary><p>
  
  #### Automated basic installation without confirmation, what does it do? 
  
  - Automatic removal of Spotify MS if it was found 
  - Automatic installation of the recommended version of Spotify (if another client has already been found, it will be installed over)
  - After the installation is completed, the client will autorun
  
<h4> </h4>

#### Just download and run [Install_Basic.bat](https://raw.githack.com/amd64fox/SpotX/main/scripts/Install_Basic.bat)

or

#### Run The following command in PowerShell:

```ps1
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; iex "& { $((iwr -useb 'https://raw.githubusercontent.com/amd64fox/SpotX/main/Install.ps1').Content) } -confirm_uninstall_ms_spoti -confirm_spoti_recomended_over -podcasts_on -cache_off -block_update_off -exp_standart -hide_col_icon_off -start_spoti"
```

</details>
  
<details>
<summary><small>Automatic full installation</small></summary><p>
  
  <h4>Automatic installation without confirmation, what does it do?</h4> 
  
  - Automatic removal of Spotify MS if it was found 
  - Automatic installation of the recommended version of Spotify (if another client has already been found, it will be installed over) 
  - Removal of podcasts from the main page 
  - Automatic blocking of Spotify updates
  - All [experimental features](https://github.com/amd64fox/SpotX/discussions/50) included
  - After the installation is completed, the client will autorun.
  
<h4> </h4>

#### Just download and run [Install_Auto.bat](https://raw.githack.com/amd64fox/SpotX/main/scripts/Install_Auto.bat)

or

#### Run The following command in PowerShell:

```ps1
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; iex "& { $((iwr -useb 'https://raw.githubusercontent.com/amd64fox/SpotX/main/Install.ps1').Content) } -confirm_uninstall_ms_spoti -confirm_spoti_recomended_over -podcasts_off -cache_off -block_update_on -start_spoti"
```

</details>
<details>
<summary><small>Installing with Scoop</small></summary><p>
  
  #### Installing SpotX via the Scoop package manager includes:

  - Automatic removal of Spotify MS if it was found 
  - Automatic installation of the recommended version of Spotify (if another client has already been found, it will be installed over) 
  - Removal of podcasts from the main page 
  - Automatic blocking of Spotify updates
  - All [experimental features](https://github.com/amd64fox/SpotX/discussions/50) included 
  
  <h4> </h4>
  
#### Installing SpotX with Scoop
Just run these commands in the command prompt or powershell:
<br>
<br>```scoop bucket add nonportable```
<br>```scoop install spotx-np```

#### Updating SpotX with Scoop

To update SpotX or check for updates run this command in the command prompt or powershell:

```scoop update spotx-np```

#### Uninstalling SpotX with Scoop

To fully uninstall SpotX and Spotify run this command in the command prompt or powershell:

```scoop uninstall spotx-np```

</details>

<details>
<summary><small>Installation for premium</small></summary><p>
  
  #### Usual installation only without ad blocking, for those who have a premium account, also contains:

  - All [experimental features](https://github.com/amd64fox/SpotX/discussions/50) included

  <h4> </h4>
  
#### Just download and run [Install_Prem.bat](https://raw.githack.com/amd64fox/SpotX/main/scripts/Install_Prem.bat)

or

#### Run The following command in PowerShell:

```ps1
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; iex "& { $((iwr -useb 'https://raw.githubusercontent.com/amd64fox/SpotX/main/Install.ps1').Content) } -premium"
```

</details>

<details>
<summary><small>Installing with parameters</small></summary><p>

You can specify various parameters for a more flexible installation, more [details here](https://github.com/amd64fox/SpotX/discussions/60)

</details>

<h1>Uninstall</h1>

- Just run [Uninstall.bat](https://raw.githack.com/amd64fox/SpotX/main/Uninstall.bat)

or

- Reinstall Spotify ([Full uninstall](https://github.com/amd64fox/Uninstall-Spotify) recommended)

<h1>FAQ</h1>

- Please see [FAQ](https://github.com/amd64fox/SpotX/blob/main/.github/Doc/FAQ.md)

<h1>Credits</h1>

- The repository is based on <a href="https://github.com/mrpond/BlockTheSpot">BlockTheSpot</a>, and also some tricks were taken from <a href="https://github.com/khanhas/spicetify-cli">spicetify-cli</a>, many thanks to the contributors
