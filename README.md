# SpotFreedom

```
  _________              __ ________                         .___
 /   _____/dpo|___     _/  |\_   __ \_______   ____   ____   __| _/____   _____
 \_____  \ \____ \   /   _  \|    __) \_  __ \_/ __ \_/ __ \ / __ |/  _ \ /     \
 /        \|  |_> > (  (_)  )|     \   |  | \/\  ___/\  ___// /_/ (  <_> )  Y Y  \
/_______  /|   __/   \_____/ \___  /   |__|    \___  >\___  >____ |\____/|__|_|  /
        \/ |__|                  \/                \/     \/     \/            \/
```

> **"Privacy is not an option, it is the default."**

**SpotFreedom** is a fork of the legendary SpotX, engineered for those who demand absolute control over their audio experience. We've taken the core and injected it with new capabilities to bypass restrictions and maintain anonymity.

## [ MISSION ]

The original patchers are failing. The patterns have shifted. SpotFreedom is here to re-establish dominance.
We don't just patch; we liberate.

## [ CAPABILITIES ]

### 🔓 **Total Liberation**
- **Ad-Block**: Nullifies audio, video, and banner ads. Silence is golden.
- **Premium UI**: Forces the client into a premium state visually.
- **Update Blocker**: Prevents Spotify from overwriting your freedom.

### 👻 **Stealth Mode (Application-Level VPN)**
*New in SpotFreedom*

Why route your entire system through a VPN just to listen to music? SpotFreedom introduces **Application-Level Proxying** using native CEF (Chromium Embedded Framework) flags.

- **Precise**: Only Spotify traffic is routed.
- **Flexible**: Supports SOCKS5 and HTTP proxies.
- **Stealthy**: Modifies the launch parameters directly.

### 🛡️ **Privacy Hardening**
- **Analytics Nuke**: Disables Sentry, tracking, and logging.
- **Social Ghost**: Optional hiding of social features.

## [ DEPLOYMENT ]

### **PowerShell Injection**

1.  **Clone the armory:**
    ```powershell
    git clone https://github.com/YourRepo/SpotFreedom.git
    cd SpotFreedom
    ```

2.  **Execute Run.ps1:**
    ```powershell
    .\Run.ps1
    ```

### **Stealth Mode Usage**

To activate the VPN feature, pass the proxy details during execution:

```powershell
.\Run.ps1 -ProxyHost "127.0.0.1" -ProxyPort 9050 -ProxyType "socks5"
```
*Supports `http`, `https`, `socks4`, `socks5`.*

## [ DISCLAIMER ]

*SpotFreedom is for educational and research purposes only. We do not host any binaries. Use at your own risk. Respect the artists; support them if you can.*

---
*EOF*
