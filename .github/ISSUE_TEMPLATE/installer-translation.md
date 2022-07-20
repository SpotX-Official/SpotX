---
name: 🌏 Installer translation
about: Translate the installer into your language
title: Translation for [Write here your translation language]
labels: 🌏 New translation
assignees: ''

---

## 📝 Features translation

Before you start translating, you need to know how your language is called in powershell, for this you need Windows with this default language, enter the following command in the powershell terminal :

```ps1
$PSUICulture.Remove(2)
```

- Translation language powershell: *Enter here what you received in powershell*

Then you can start translating lines, they start after the equal sign.

It is important that you do not need to translate before the equal sign, these are variables.

Also, if you come across characters {0}, {1} or file names, then just skip them.

Good luck to you.

## 📝 Translation strings

```txt
    Author          = "Author:"
    Incorrect       = "Oops, an incorrect value,"
    Incorrect2      = "enter again through "
    Download        = "Error downloading"
    Download2       = "Will re-request in 5 seconds..."
    Download3       = "Error again"
    Download4       = "Try to check your internet connection and run the installation again"
    Download5       = "Downloading Spotify"
    StopScrpit      = "Script is stopped"
    MsSpoti         = "The Microsoft Store version of Spotify has been detected which is not supported"
    MsSpoti2        = "Uninstall Spotify Windows Store edition [Y/N]"
    MsSpoti3        = "Automatic uninstalling Spotify MS..."
    MsSpoti4        = "Uninstalling Spotify MS..."
    Prem            = "Modification for premium account..."
    DownBts         = "Downloading latest patch BTS..."
    OldV            = "Found outdated version of Spotify"
    OldV2           = "Your Spotify {0} version is outdated, it is recommended to upgrade to {1}"
    OldV3           = "Want to update ? [Y/N]"
    AutoUpd         = "Automatic update to the recommended version"
    DelOrOver       = "Do you want to uninstall the current version of {0} or install over it? Y [Uninstall] / N [Install Over]"
    DelOld          = "Uninstalling old Spotify..."
    NewV            = "Unsupported version of Spotify found"
    NewV2           = "Your Spotify {0} version hasn't been tested yet, currently it's a stable {1} version"
    NewV3           = "Do you want to continue with {0} version (errors possible) ? [Y/N]"
    Recom           = "Do you want to install the recommended {0} version ? [Y/N]"
    DelNew          = "Uninstalling an untested Spotify..."
    DownSpoti       = "Downloading and installing Spotify"
    DownSpoti2      = "Please wait..."
    PodcatsOff      = "Off Podcasts"
    PodcastsOn      = "On Podcasts"
    PodcatsSelect   = "Want to turn off podcasts ? [Y/N]"
    DowngradeNote   = "It is recommended to block because there was a downgrade of Spotify"
    UpdBlock        = "Updates blocked"
    UpdUnblock      = "Updates are not blocked"
    UpdSelect       = "Want to block updates ? [Y/N]"
    CacheOn         = "Clear cache enabled ({0})"
    CacheOff        = "Clearing the cache is not enabled"
    CacheSelect     = "Want to set up automatic cache cleanup? [Y/N]"
    CacheDays       = "Cache older: XX days to be cleared "
    CacheDays2      = "Enter the number of days from 1 to 100"
    NoVariable      = "Didn't find variable"
    NoVariable2     = "in xpui.js"
    NoVariable3     = "in licenses.html"
    NoVariable4     = "in html"
    ModSpoti        = "Patching Spotify..."
    Error           = "Error"
    FileLocBroken   = "Location of Spotify files is broken, uninstall the client and run the script again"
    Spicetify       = "Spicetify detected"
    NoRestore       = "SpotX has already been installed, xpui.js and xpui.css not found. `nPlease uninstall Spotify client and run Install.bat again"
    ExpOff          = "Experimental features disabled"
    NoRestore2      = "SpotX has already been installed, xpui.bak not found. `nPlease uninstall Spotify client and run Install.bat again"
    UpdateBlocked   = "Spotify updates are already blocked"
    UpdateError     = "Failed to block updates"
    NoSpotifyExe    = "Could not find Spotify.exe"
    InstallComplete = "installation completed"
    HostDel         = "Unwanted URLs found in hosts file, trying to remove them..."
    HostError       = "Something went wrong while editing the hosts file, edit it manually"
```
