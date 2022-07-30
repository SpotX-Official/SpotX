<div align="center"><h1>FAQ</h1></div>

<div align="center"><h2>I have an error / bug / strange client behavior, what can I do ?</h2></div>

If you notice an error or other malfunction in the mod or in its installation, then do not rush to create a problem report, try this couple of simple steps, this helps to solve a large number of different bugs:

- Completely remove Spotify so that there are no tails from the old versions of the client, [this patch](https://github.com/amd64fox/Uninstall-Spotify) will do it for you in one click, after that restart pc and run the SpotX installation again, this way you will perform a clean installation, which helps to avoid a lot of bugs associated with outdated versions.
- Also, as an additional measure, look at your host file, it should not contain different URLs that can cause the client to work incorrectly, even if you are sure that you did not add anything to it, then go into it anyway and check it for sure, since Some ad blockers that you may have used in the past may have added entries to the host file automatically without your consent.
  To quickly open the host file, press `Win + R` and enter `%WinDir%\System32\Drivers\Etc\hosts`, in order for the system to allow you to edit the file, you need to open it as an administrator.
- If you still see errors, then install the original client and check this error there, if the error is present in the original client, then here you need to wait for a fix from the Spotify developers.
  To expedite resolution of a problem in the original client, please create a problem report on their [support forum](https://community.spotify.com/t5/Desktop-Windows/bd-p/desktop_windows).
  In the meantime, you are waiting for a fix, you can temporarily return to the previous version of Spotify that worked for you and block updates in it, [this instruction](https://github.com/amd64fox/Rollback-Spotify) will help you with this.


<div align="center"><h2>It seems I have an old version of PowerShell 2.0, can I install a patch with it?</h2></div>

No, you will get something like this error
 <details>
<summary><small>Screenshot</small></summary><p>

![Capture](https://user-images.githubusercontent.com/62529699/181509312-39e912b1-ac9a-4753-840c-654ce117f52b.png)

 
  
</details>
Script only works starting from version 3, you need to update NET Framework and PowerShell.

Do the following:

- Upgrade to [NET Framework 4.8](https://go.microsoft.com/fwlink/?linkid=2088631)
- Upgrade to [WMF 5.1](https://www.microsoft.com/en-us/download/details.aspx?id=54616)
- Reboot your PC




<div align="center"><h2>How to downgrade Spotify version?</h2></div>

If you have problems with the patch after upgrading the client version, then use this [tool](https://github.com/amd64fox/Rollback-Spotify) to revert back to the working version.




<div align="center"><h2>SpotX is forcibly installing/updating an outdated version of Spotify, but a new version has already been released, how do I install it?</h2></div>

SpotX installs/updates the recommended version which is the most stable according to the author of the patch.
If a new version has been released, and SpotX has not yet been updated, then you have two options:
- Stay on the recommended version and block automatic Spotify updates
- Install the latest version of Spotify and run [`Usual installation`](https://github.com/amd64fox/SpotX#choose-installation-type), confirm during the installation that you want to continue with the installation with the version that has not been tested yet, but do not forget that mistakes are possible with it.

<div align="center"><h2>I got an error editing my hosts file, how can I fix it?</h2></div>
This error can be fixed in two ways:

- Just run the bat file as administrator

or

- Manually editing the hosts file, you need to open and remove all lines from it that relate to Spotify




<div align="center"><h2>My hosts file got corrupted during installation, how do I get it back?</h2></div>

If you need your old hosts file, then you can find a backup of it in the same folder named `hosts.bak`

<div align="center"><h2>I want to translate the installer into my language, how can I do that?</h2></div>

If you would like to translate the installer into your language, you can do so [here](https://github.com/amd64fox/SpotX/issues/new?assignees=&labels=%F0%9F%8C%90+New+translation&template=installer-new-translation.yml), and if you notice a bug in current languages, you can report it [here](https://github.com/amd64fox/SpotX/issues/new?assignees=&labels=%F0%9F%8C%90+Fix+translation&template=itranslation-fix.yml).




<div align="center"><h2>Can I use SpotX and Spicetify together?</h2></div>

Yes you can do this, for example:

1. First install SpotX, then install Spicetify on top and customize it to your taste.

Or you can do the opposite.

2. first install Spicetify, customize it to your taste, and then install SpotХ on top.

But if you use the second case, then when you try to use the Spicetify commands, my patch will be reset, you will need to install it on top again.




<div align="center"><h2>I have a premium account but I still want to use SpotX, is this possible?</h2></div>

Yes, there is such an opportunity, you need to run a [special installation](https://raw.githack.com/amd64fox/SpotX/main/scripts/Install_Prem.bat) without ad blocking.
