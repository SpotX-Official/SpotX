<p align="center">
  <img src="https://img.shields.io/badge/SpotFreedom-Spotify_Patcher-1DB954?style=for-the-badge&logo=spotify&logoColor=white" alt="SpotFreedom"/>
</p>

<p align="center">
  <a href="https://github.com/NimuthuGanegoda/SpotFreedom"><img src="https://img.shields.io/badge/SpotFreedom-Repository-blue"></a>
  <a href="https://github.com/NimuthuGanegoda/SpotFreedom/releases"><img src="https://img.shields.io/badge/Releases-Latest-green"></a>
  <a href="https://telegra.ph/SpotX-FAQ-09-19"><img src="https://img.shields.io/badge/FAQ-Read-orange"></a>
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

- **Operating System:** Windows 7 or later / Linux / macOS
- **Spotify Client:** [Official Spotify Desktop Application](https://loadspot.pages.dev) (Microsoft Store version not supported)
- **PowerShell:** Version 5.1 or higher (Windows only)
- **Bash Shell:** Required for Linux and macOS installations
- **Internet Connection:** Required for installation and updates

<h1 id="perks">Why SpotFreedom?</h1>

SpotFreedom uses BlockTheSpot (https://github.com/mrpond/BlockTheSpot) as its core ad-blocking technology, with exclusive features designed for advanced users:

- **🚫 BlockTheSpot Integration:** Uses the proven DLL injection method from BlockTheSpot for superior ad-blocking.
- **🔄 Automatic Update Checking:** Verifies the latest Spotify version from loadspot.pages.dev to ensure patches remain compatible.
- **🌍 Built-in Proxy/VPN Support:** Easily configure proxies to bypass geo-restrictions directly via installation parameters (Windows only).
- **🎨 Seamless Spicetify Integration:** Automatically install or update Spicetify alongside your patches with the simple `-spicetify` switch (Windows only).
- **🛡️ Enhanced Stability:** Uses local patching methods to reduce reliance on external servers for patch data.
- **🧹 Auto-Cleanup:** Automatically manages and cleans up temporary files (`SpotFreedom_Temp`) for a cleaner system.

<h1 id="features">Features</h1>

- **Blocks all banner, video, and audio ads** in the client
- **Hiding podcasts, episodes, and audiobooks** from the homepage (optional)
- **Block Spotify automatic updates** (optional)
- **Automatic version checking** from loadspot.pages.dev to ensure compatibility with the latest Spotify version
- **Built-in Proxy/VPN Support** including Outline VPN (Windows only)
- **Spicetify Integration** (Windows only)
- **BlockTheSpot Integration** (Enabled by default, uses DLL injection from https://github.com/mrpond/BlockTheSpot)
- **Some native experimental features have been changed**
- **Advanced installation [parameters](https://github.com/SpotX-Official/SpotX/discussions/60)**

> **Note on BlockTheSpot:**
> BlockTheSpot (DLL Injection) is now **enabled by default** as the primary ad-blocking method. This provides enhanced ad-blocking capabilities using the proven approach from https://github.com/mrpond/BlockTheSpot. If you experience issues or prefer the native binary patching method instead, you can disable BlockTheSpot by running the installer with the `-no_bts` parameter.
>
> **Automatic Updates:** This repository is automatically monitored for BlockTheSpot updates. When a new version is released, a pull request is automatically created to track the update.

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

#### Run the following command in PowerShell:

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

#### Run the following command in PowerShell:

```ps1
iex "& { $(iwr -useb 'https://raw.githubusercontent.com/SpotX-Official/SpotX/refs/heads/main/run.ps1') } -v 1.2.13.661.ga588f749 -confirm_spoti_recomended_over -block_update_on"
```

#### mirror

```ps1
iex "& { $(iwr -useb 'https://spotx-official.github.io/SpotX/run.ps1') } -m -v 1.2.13.661.ga588f749 -confirm_spoti_recomended_over -block_update_on"
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

#### Run the following command in PowerShell:

```ps1
iex "& { $(irm 'https://raw.githubusercontent.com/NimuthuGanegoda/SpotFreedom/main/run.ps1') } -confirm_uninstall_ms_spoti -confirm_spoti_recomended_over -podcasts_off -block_update_on -start_spoti -new_theme -adsections_off -lyrics_stat spotify"
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

#### Run the following command in PowerShell:

```ps1
iex "& { $(irm 'https://raw.githubusercontent.com/NimuthuGanegoda/SpotFreedom/main/run.ps1') } -premium -new_theme"
```

</details>

<details>
<summary><small>Installing with parameters</small></summary><p>

You can specify various parameters for a more flexible installation, more [details here](https://github.com/SpotX-Official/SpotX/discussions/60)

</details>

<details>
<summary><small>Outline VPN Configuration (Windows only)</small></summary><p>

  #### Configure Spotify to use Outline VPN (Shadowsocks)

  - Ensures Spotify traffic goes through your Outline Client
  - Requires Outline Client to be running
  - **🎨 NEW: Interactive VPN Server UI** - A graphical interface will automatically open to help you select from available VPN servers
  - **Free VPN Servers from VPNBook.com:**
    - **Outline/Shadowsocks Servers (Recommended):**
      - **Poland Server 1:** `ss://Y2hhY2hhMjAtaWV0Zi1wb2x5MTMwNTpwdmd6OXBx@pl134.vpnbook.com:443/?outline=1`
      - **Poland Server 2:** `ss://Y2hhY2hhMjAtaWV0Zi1wb2x5MTMwNTpwdmd6OXBx@pl140.vpnbook.com:443/?outline=1`
      - **Canada Server 3:** `ss://Y2hhY2hhMjAtaWV0Zi1wb2x5MTMwNTpwdmd6OXBx@ca225.vpnbook.com:443/?outline=1`
    - **OpenVPN/WireGuard Servers (Requires separate client):**
      - US: US16, US178 | Canada: CA149, CA196
      - UK: UK205, UK68 | Germany: DE20, DE220 | France: FR200, FR231
      - Get credentials at: [https://www.vpnbook.com/freevpn](https://www.vpnbook.com/freevpn)

  > **Note:** VPN configuration is now prompted by default during installation with an interactive UI. To disable this prompt, use the `-no_vpn` switch.

  <h4> </h4>

#### Run the following command in PowerShell (Interactive mode with VPN prompt):

```ps1
iex "& { $(irm 'https://raw.githubusercontent.com/NimuthuGanegoda/SpotFreedom/main/run.ps1') }"
```

#### To skip VPN configuration prompt:

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
