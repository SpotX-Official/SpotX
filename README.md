<p align="center">
  <a href="https://github.com/NimuthuGanegoda/SpotFreedom/releases"><img src="https://spotx-official.github.io/images/logos/logo.png" /></a>
</p>

<p align="center">
  <a href="https://t.me/spotify_windows_mod"><img src="https://spotx-official.github.io/images/shields/SpotX_Channel.svg"></a>
  <a href="https://t.me/SpotxCommunity"><img src="https://spotx-official.github.io/images/shields/SpotX_Community.svg"></a>
  <a href="https://github.com/SpotX-Official/SpotX-Bash"><img src="https://spotx-official.github.io/images/shields/SpotX_for_Mac&Linux.svg"></a>
  <a href="https://telegra.ph/SpotX-FAQ-09-19"><img src="https://spotx-official.github.io/images/shields/faq.svg"></a>
</p>

<h2>
  <div align="center">
    <b>SpotFreedom - Patcher for Spotify Desktop Client</b>
  </div>
</h2>

<p align="center"> •
  <a href="#requirements">Requirements</a> •
  <a href="#perks">Why SpotFreedom?</a> •
  <a href="#features">Features</a> •
  <a href="#installation--update">Installation</a> •
  <a href="#uninstall">Uninstall</a> •
  <a href="#faq">FAQ</a> •
  <a href="#disclaimer">Disclaimer</a>
</p>

<h1 id="requirements">Requirements</h1>

- **OS:** Windows 7-11 / Linux / macOS
- **Spotify:** [Official desktop version](https://loadspot.pages.dev) (Microsoft Store version is not suitable)
- **PowerShell:** 5.1 and above (Windows)
- **Bash:** (Linux / macOS)

<h1 id="perks">Why SpotFreedom?</h1>

SpotFreedom builds upon the solid foundation of SpotX with exclusive features designed for advanced users:

- **🌍 Built-in Proxy/VPN Support (Windows):** Easily configure proxies to bypass geo-restrictions directly via installation parameters.
- **🎨 Seamless Spicetify Integration (Windows):** Automatically install or update Spicetify alongside your patches with the simple `-spicetify` switch.
- **🛡️ Enhanced Stability:** Uses local patching methods to reduce reliance on external servers for patch data.
- **🧹 Auto-Cleanup:** Automatically manages and cleans up temporary files (`SpotFreedom_Temp`) for a cleaner system.

<h1 id="features">Features</h1>

- **Blocks all banner, video, and audio ads** in the client
- **Hiding podcasts, episodes, and audiobooks** from the homepage (optional)
- **Block Spotify automatic updates** (optional)
- **Built-in Proxy/VPN Support** (Windows) including Outline VPN
- **Spicetify Integration** (Windows)
- **BlockTheSpot Integration** (Optional via `-bts` switch)
- **Some native experimental features have been changed**
- **Analytics sending has been disabled**
- **Advanced installation [parameters](https://github.com/SpotX-Official/SpotX/discussions/60)**

> **Note on "Black Screen" Issues:**
> BlockTheSpot (DLL Injection) is now **disabled by default** to prevent black screen issues on newer Spotify versions (1.2.30+). The installer will automatically clean up legacy BlockTheSpot files (`dpapi.dll`, `config.ini`) to fix broken installations. If you specifically need BlockTheSpot features, run the installer with the `-bts` parameter.

<h1 id="installation--update">Installation / Update</h1>
<h3>Choose installation type:</h3>
<details>
<summary><small>Usual installation (New theme)</small></summary><p>

  #### During installation, you need to confirm some actions, also contains:

  - New theme activated (new right and left sidebar, some cover change)
  - All [experimental features](https://github.com/SpotX-Official/SpotX/discussions/50) included

  <h4> </h4>

#### Just download and run [Install_New_theme.bat](https://raw.githack.com/NimuthuGanegoda/SpotFreedom/main/Install_New_theme.bat)

or

#### Run The following command in PowerShell:

```ps1
iex "& { $(irm 'https://raw.githubusercontent.com/NimuthuGanegoda/SpotFreedom/main/run.ps1') } -new_theme"
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

#### Just download and run [Install_Old_theme.bat](https://raw.githack.com/NimuthuGanegoda/SpotFreedom/main/Install_Old_theme.bat)

or

#### Run The following command in PowerShell:

```ps1
iex "& { $(irm 'https://raw.githubusercontent.com/NimuthuGanegoda/SpotFreedom/main/run.ps1') } -v 1.2.13.661.ga588f749-4064 -confirm_spoti_recomended_over -block_update_on"
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

#### Just download and run [Install_Auto.bat](https://raw.githack.com/NimuthuGanegoda/SpotFreedom/main/scripts/Install_Auto.bat)

or

#### Run The following command in PowerShell:

```ps1
iex "& { $(irm 'https://raw.githubusercontent.com/NimuthuGanegoda/SpotFreedom/main/run.ps1') } -confirm_uninstall_ms_spoti -confirm_spoti_recomended_over -podcasts_off -block_update_on -start_spoti -new_theme -adsections_off -lyrics_stat spotify -no_vpn"
```

</details>

<details>
<summary><small>Other types of installations</small></summary><p>

<details>
<summary><small>Installation for premium</small></summary><p>

  #### Usual installation only without ad blocking, for those who have a premium account, also contains:

  - New theme activated (new right and left sidebar, some cover change)
  - Disabled only audio ads in podcasts
  - All [experimental features](https://github.com/SpotX-Official/SpotX/discussions/50) included

  <h4> </h4>

#### Just download and run [Install_Prem.bat](https://raw.githack.com/NimuthuGanegoda/SpotFreedom/main/scripts/Install_Prem.bat)

or

#### Run The following command in PowerShell:

```ps1
iex "& { $(irm 'https://raw.githubusercontent.com/NimuthuGanegoda/SpotFreedom/main/run.ps1') } -premium -new_theme"
```

</details>

<details>
<summary><small>Installing with parameters</small></summary><p>

You can specify various parameters for a more flexible installation, more [details here](https://github.com/SpotX-Official/SpotX/discussions/60)

</details>

<details>
<summary><small>Outline VPN Installation</small></summary><p>

  #### Configure Spotify to use Outline VPN (Shadowsocks)

  - Ensures Spotify traffic goes through your Outline Client
  - Requires Outline Client to be running
  - **Free Access Keys:**
    - **Poland Server 1:** `ss://Y2hhY2hhMjAtaWV0Zi1wb2x5MTMwNTpwdmd6OXBx@pl134.vpnbook.com:443/?outline=1`
    - **Poland Server 2:** `ss://Y2hhY2hhMjAtaWV0Zi1wb2x5MTMwNTpwdmd6OXBx@pl140.vpnbook.com:443/?outline=1`
    - **Canada Server 3:** `ss://Y2hhY2hhMjAtaWV0Zi1wb2x5MTMwNTpwdmd6OXBx@ca225.vpnbook.com:443/?outline=1`

  > **Note:** VPN configuration is now prompted by default during installation. To disable this prompt, use the `-no_vpn` switch.

  <h4> </h4>

#### Run The following command in PowerShell (Interactive):

```ps1
iex "& { $(irm 'https://raw.githubusercontent.com/NimuthuGanegoda/SpotFreedom/main/run.ps1') }"
```

#### To skip VPN configuration:

```ps1
iex "& { $(irm 'https://raw.githubusercontent.com/NimuthuGanegoda/SpotFreedom/main/run.ps1') } -no_vpn"
```

</details>

</details>

<h1 id="installation-linux-mac">Installation on Linux & macOS</h1>

#### Run the following command in terminal:

```bash
./spotx.sh
```

<h1 id="uninstall">Uninstall</h1>

- Just run [Uninstall.bat](https://raw.githack.com/NimuthuGanegoda/SpotFreedom/main/Uninstall.bat)

or

- Reinstall Spotify ([Full uninstall Spotify](https://github.com/amd64fox/Uninstall-Spotify) recommended)

<h1 id="faq">FAQ</h1>

 Read [FAQ](https://telegra.ph/SpotX-FAQ-09-19)

<h1 id="disclaimer">Disclaimer</h1>

SpotFreedom is a tool that modifies the official Spotify client, provided as an evaluation version — use it at your own risk.
