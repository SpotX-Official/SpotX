  <p align="center">
  <a href="https://github.com/SpotX-Official/SpotX/releases"><img src="https://raw.githubusercontent.com/amd64fox/SpotX/main/.github/Pic/logo.png" />
</p>

<p align="center">        
      <a href="https://t.me/spotify_windows_mod"><img src="https://raw.githubusercontent.com/amd64fox/SpotX/main/.github/Pic/Shields/SpotX_Channel.svg"></a>
      <a href="https://t.me/SpotxCommunity"><img src="https://raw.githubusercontent.com/amd64fox/SpotX/main/.github/Pic/Shields/SpotX_Community.svg"></a>
      <a href="https://github.com/jetfir3/SpotX-Bash"><img src="https://raw.githubusercontent.com/amd64fox/SpotX/main/.github/Pic/Shields/SpotX_for_Mac&Linux.svg"></a>
      <a href="https://telegra.ph/SpotX-FAQ-09-19"><img src="https://raw.githubusercontent.com/amd64fox/SpotX/main/.github/Pic/Shields/faq.svg"></a>
      </p>

   <h2> <div align="center"><b> Modified Spotify Client for Windows </b></div> </h2>

<h1>System requirements</h1>

- <strong>OS: Windows 7-11</strong>
- <strong>Spotify: latest official [versions](https://cutt.ly/8EH6NuH)</strong>
- <strong>For Windows Desktop only (Microsoft store version is not suitable).</strong>
- <strong>PowerShell: version 5 and above recommended</strong>

<h1>Features</h1>

- <strong>Blocks all banner, video and audio ads in the client</strong>
- <strong>Hiding podcasts, episodes and audiobooks from the homepage (optional)</strong>
- <strong>Block Spotify automatic updates (optional)</strong>
- <strong>More experimental features have been activated ([see the full list](https://github.com/SpotX-Official/SpotX/discussions/50))</strong>
- <strong>Disabled Sentry (Prevented Sentry from sending console log/error/warning to Spotify developers)</strong>
- <strong>Disabled logging (Stopped various elements to log user interaction)</strong>
- <strong>Removed RTL rules (Removed all right-to-left CSS rules to simplify CSS files)</strong>
- <strong>Code minification</strong>

<h1>Fast installation / Update</h1>
<h3>Choose installation type:</h3>
<details>
<summary><small>Usual installation (New theme)</small></summary><p>
  
  #### During installation, you need to confirm some actions, also contains:
  
  - New theme activated (new right and left sidebar, some cover change)
  - All [experimental features](https://github.com/SpotX-Official/SpotX/discussions/50) included

  <h4> </h4>
  
#### Just download and run [Install.bat](https://raw.githack.com/amd64fox/SpotX/main/Install_New_theme.bat)

or

#### Run The following command in PowerShell:

```ps1
[Net.ServicePointManager]::SecurityProtocol = 3072; iex "& { $(iwr -useb 'https://spotx-official.github.io/SpotX/Install.ps1') } -new_theme"
```

</details>
  

<details>
<summary><small>Usual installation (Old theme)</small></summary><p>
  
  #### During installation, you need to confirm some actions, also contains:
  - Forced installation of version 1.2.13 (since the old theme was removed in subsequent versions)
  - Old theme activated
  - Automatic blocking of Spotify updates
  - All [experimental features](https://github.com/SpotX-Official/SpotX/discussions/50) included

  <h4> </h4>
  
#### Just download and run [Install.bat](https://raw.githack.com/amd64fox/SpotX/main/Install_Old_theme.bat)

or

#### Run The following command in PowerShell:

```ps1
[Net.ServicePointManager]::SecurityProtocol = 3072; iex "& { $(iwr -useb 'https://spotx-official.github.io/SpotX/Install.ps1') } -v 1.2.13.661.ga588f749-4064 -confirm_spoti_recomended_over -block_update_on"
```

</details>
 
<details>
<summary><small>Automatic full installation</small></summary><p>
  
  <h4>Automatic installation without confirmation, what does it do?</h4> 
  
  - New theme activated (new right and left sidebar, some cover change)
  - Hiding podcasts/episodes/audiobooks from the homepage
  - Activated [static theme](https://github.com/SpotX-Official/SpotX/discussions/50#discussioncomment-4096066) <kbd>spotify</kbd> for lyrics
  - Hiding [ad-like sections](https://github.com/SpotX-Official/SpotX/discussions/50#discussioncomment-4478943)
  - All [experimental features](https://github.com/SpotX-Official/SpotX/discussions/50) included
  - Automatic removal of Spotify MS if it was found 
  - Automatic installation of the recommended version of Spotify (if another client has already been found, it will be installed over) 
  - Automatic blocking of Spotify updates
  - After the installation is completed, the client will autorun.
  
<h4> </h4>

#### Just download and run [Install_Auto.bat](https://raw.githack.com/amd64fox/SpotX/main/scripts/Install_Auto.bat)

or

#### Run The following command in PowerShell:

```ps1
[Net.ServicePointManager]::SecurityProtocol = 3072; iex "& { $(iwr -useb 'https://spotx-official.github.io/SpotX/Install.ps1') } -confirm_uninstall_ms_spoti -confirm_spoti_recomended_over -podcasts_off -block_update_on -start_spoti -new_theme -adsections_off -lyrics_stat spotify"
```

</details>

<details>
<summary><small>Other types of installations</summary><p>

<details>
<summary><small>Installation for premium</small></summary><p>
  
  #### Usual installation only without ad blocking, for those who have a premium account, also contains:
  
  - New theme activated (new right and left sidebar, some cover change)
  - Disabled only audio ads in podcasts
  - All [experimental features](https://github.com/SpotX-Official/SpotX/discussions/50) included

  <h4> </h4>
  
#### Just download and run [Install_Prem.bat](https://raw.githack.com/amd64fox/SpotX/main/scripts/Install_Prem.bat)

or

#### Run The following command in PowerShell:

```ps1
[Net.ServicePointManager]::SecurityProtocol = 3072; iex "& { $(iwr -useb 'https://spotx-official.github.io/SpotX/Install.ps1') } -premium -new_theme"
```

</details>

<details>
<summary><small>Installing with parameters</small></summary><p>

You can specify various parameters for a more flexible installation, more [details here](https://github.com/SpotX-Official/SpotX/discussions/60)

</details>

</details>

<h1>Uninstall</h1>

- Just run [Uninstall.bat](https://raw.githack.com/amd64fox/SpotX/main/Uninstall.bat)

or

- Reinstall Spotify ([Full uninstall Spotify](https://github.com/SpotX-Official/Uninstall-Spotify) recommended)

<h1>FAQ</h1>

 Read [FAQ](https://telegra.ph/SpotX-FAQ-09-19)

<h1>Credits</h1>

 Some tricks were taken from <a href="https://github.com/khanhas/spicetify-cli">spicetify-cli</a>, many thanks to the contributors.

<h1>Disclaimer</h1>

 SpotX is a modified version of the official Spotify client, provided as an evaluation version, you use it at your own risk.
