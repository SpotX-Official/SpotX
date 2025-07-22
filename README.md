<p align="center">
  <a href="https://github.com/SpotX-Official/SpotX/releases"><img src="https://spotx-official.github.io/images/logos/logo.png" /></a>
</p>


<p align="center"> •
  <a href="#requirements">Requirements</a> •
  <a href="#features">Features</a> •
  <a href="#installation--update">Installation</a> •
  <a href="#uninstall">Uninstall</a> •
  <a href="#faq">FAQ</a> •
  <a href="#disclaimer">Disclaimer</a>
</p>

<h1 id="requirements">Requirements</h1>

- **OS:** Windows 7-11
- **Spotify:** Latest official [versions](https://loadspot.pages.dev)
- **For Windows Desktop only** (Microsoft Store version is not suitable)
- **PowerShell:** Version 5 and above recommended

<h1 id="features">Features</h1>

- **Blocks all banner, video, and audio ads** in the client
- **Hiding podcasts, episodes, and audiobooks** from the homepage (optional)
- **Block Spotify automatic updates** (optional)
- **More experimental features have been activated** ([see the full list](https://github.com/SpotX-Official/SpotX/discussions/50))
- **Disabled Sentry's console log/error/warning messages** to Spotify developers, halted user interaction logging, and performed code minification

<h1 id="installation--update">Installation / Update</h1>
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
iex "& { $(iwr -useb 'https://raw.githubusercontent.com/SpotX-Official/spotx-official.github.io/main/run.ps1') } -new_theme"
```

#### mirror

```ps1
iex "& { $(iwr -useb 'https://spotx-official.github.io/run.ps1') } -m -new_theme"
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
iex "& { $(iwr -useb 'https://raw.githubusercontent.com/SpotX-Official/spotx-official.github.io/main/run.ps1') } -v 1.2.13.661.ga588f749-4064 -confirm_spoti_recomended_over -block_update_on"
```

#### mirror

```ps1
iex "& { $(iwr -useb 'https://spotx-official.github.io/run.ps1') } -m -v 1.2.13.661.ga588f749-4064 -confirm_spoti_recomended_over -block_update_on"
```

</details>
 
<details>
<summary><small>Full installation</small></summary><p>
  
  <h4>Full installation without confirmation, what does it do?</h4> 
  
  - New theme activated (new right and left sidebar, some cover change)
  - Hiding podcasts/episodes/audiobooks from the homepage
  - Activated [static theme](https://github.com/SpotX-Official/SpotX/discussions/50#discussioncomment-4096066) <kbd>spotify</kbd> for lyrics
  - Hiding [ad-like sections](https://github.com/SpotX-Official/SpotX/discussions/50#discussioncomment-4478943)
  - All [experimental features](https://github.com/SpotX-Official/SpotX/discussions/50) included
  - Removal of Spotify MS if it was found 
  - Installation of the recommended version of Spotify (if another client has already been found, it will be installed over) 
  - Blocking of Spotify updates
  - After the installation is completed, the client will autorun.
  
<h4> </h4>

#### Just download and run [Install_Auto.bat](https://raw.githack.com/amd64fox/SpotX/main/scripts/Install_Auto.bat)

or

#### Run The following command in PowerShell:

```ps1
iex "& { $(iwr -useb 'https://raw.githubusercontent.com/SpotX-Official/spotx-official.github.io/main/run.ps1') } -confirm_uninstall_ms_spoti -confirm_spoti_recomended_over -podcasts_off -block_update_on -start_spoti -new_theme -adsections_off -lyrics_stat spotify"
```

#### mirror

```ps1
iex "& { $(iwr -useb 'https://spotx-official.github.io/run.ps1') } -m -confirm_uninstall_ms_spoti -confirm_spoti_recomended_over -podcasts_off -block_update_on -start_spoti -new_theme -adsections_off -lyrics_stat spotify"
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
iex "& { $(iwr -useb 'https://raw.githubusercontent.com/SpotX-Official/spotx-official.github.io/main/run.ps1') } -premium -new_theme"
```

#### mirror

```ps1
iex "& { $(iwr -useb 'https://spotx-official.github.io/run.ps1') } -m -premium -new_theme"
```

</details>

<details>
<summary><small>Installing with parameters</small></summary><p>

You can specify various parameters for a more flexible installation, more [details here](https://github.com/SpotX-Official/SpotX/discussions/60)

</details>

</details>

<h1 id="uninstall">Uninstall</h1>

- Just run [Uninstall.bat](https://raw.githack.com/amd64fox/SpotX/main/Uninstall.bat)

or

- Reinstall Spotify ([Full uninstall Spotify](https://github.com/amd64fox/Uninstall-Spotify) recommended)

<h1 id="faq">FAQ</h1>

 Read [FAQ](https://telegra.ph/SpotX-FAQ-09-19)

<h1 id="disclaimer">Disclaimer</h1>

 SpotX is a modified version of the official Spotify client, provided as an evaluation version, you use it at your own risk.
