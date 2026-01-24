#!/usr/bin/env bash

buildVer="1.2.81.264.gb4ad4efa"

command -v perl >/dev/null || { echo -e "\n${red}Error:${clr} perl command not found.\nInstall perl on your system then try again.\n" >&2; exit 1; }

case $(uname | tr '[:upper:]' '[:lower:]') in
  darwin*) platformType='macOS' ;;
        *) platformType='Linux' ;;
esac

clr='\033[0m'
green='\033[0;32m'
red='\033[0;31m'
yellow='\033[0;33m'

show_help() {
  echo -e \
"Options:
-B, --blockupdates     : block client auto-updates [macOS]
-c, --clearcache       : clear client app cache
-d, --devmode          : enable developer mode
-e, --noexp            : exclude all experimental features
-f, --force            : force SpotX-Bash to run
-h, --hide             : hide non-music on home screen
--help                 : print this help message
-i, --interactive      : enable interactive mode
--installdeb           : install latest client deb pkg on APT-based distros [Linux]
--installmac           : install latest supported client version [macOS]
-l, --lyricsbg         : set lyrics background color to black
--nocolor              : remove colors from SpotX-Bash output
-o, --oldui            : use old home screen UI
-p, --premium          : paid premium-tier subscriber
-P <path>              : set path to client
-S, --skipcodesign     : skip codesigning [macOS]
--stable               : use with '--installdeb' for stable branch [Linux]
--uninstall            : uninstall SpotX-Bash
-v, --version          : print SpotX-Bash version
-V <version>           : install specific client version [macOS]
"
}

while getopts ':BcdefF:hilopP:SvV:-:' flag; do
  case "${flag}" in
    -)
      case "${OPTARG}" in
        blockupdates) [[ "${platformType}" == "macOS" ]] && blockUpdates='true' ;;
        clearcache) clearCache='true' ;;
        debug) debug='true' ;;
        devmode) devMode='true' ;;
        force) forceSpotx='true' ;;
        help) show_help; exit 0 ;;
        hide) hideNonMusic='true' ;;
        installdeb) [[ "${platformType}" == "Linux" ]] && installDeb='true' ;;
        installmac) [[ "${platformType}" == "macOS" ]] && installMac='true' ;;
        interactive) interactiveMode='true' ;;
        logo) logoVar='true' ;;
        lyricsbg) lyricsBg='true' ;;
        nocolor) unset clr green red yellow ;;
        noexp) excludeExp='true' ;;
        oldui) oldUi='true' ;;
        premium) paidPremium='true' ;;
        skipcodesign) [[ "${platformType}" == "macOS" ]] && skipCodesign='true' ;;
        stable) [[ "${platformType}" == "Linux" ]] && stableVar='true' ;;
        uninstall) uninstallSpotx='true' ;;
        version) verPrint='true' ;;
        $(date +"%y%d%m%H:%M")) t='true' ;;
        *) echo -e "${red}Error:${clr} '--""${OPTARG}""' not supported\n\n$(show_help)\n" >&2; exit 1 ;;
      esac ;;
    B) [[ "${platformType}" == "macOS" ]] && blockUpdates='true' ;;
    c) clearCache='true' ;;
    d) devMode='true' ;;
    e) excludeExp='true' ;;
    f) forceSpotx='true' ;;
    F) forceVer="${OPTARG}"; clientVer="${forceVer}" ;;
    h) hideNonMusic='true' ;;
    i) interactiveMode='true' ;;
    l) lyricsBg='true' ;;
    o) oldUi='true' ;;
    p) paidPremium='true' ;;
    P) p="${OPTARG}"; installPath="${p}"; installOutput=$(echo "${installPath}" | perl -pe 's|^$ENV{HOME}|~|') ;;
    S) [[ "${platformType}" == "macOS" ]] && skipCodesign='true' ;;
    v) verPrint='true' ;;
    V) [[ "${platformType}" == "macOS" ]] && {
         [[ "${OPTARG}" =~ ^1\.[12]\.[0-9]{1,2}\.[0-9]{3,}.*$ ]] && {
           versionVar="${OPTARG}"
           installMac='true'
         } || {
           echo -e "${red}Error:${clr} Invalid or unsupported version\n" >&2
           exit 1
         }
       } || {
         echo -e "${red}Error:${clr} SpotX-Bash does not support '-V' on Linux\n" >&2
         exit 1
       } ;;
    \?) echo -e "${red}Error:${clr} '-""${OPTARG}""' not supported\n\n$(show_help)\n" >&2; exit 1 ;;
    :) echo -e "${red}Error:${clr} '-""${OPTARG}""' requires additional argument\n\n$(show_help)\n" >&2; exit 1 ;;
  esac
done

gVer=$(echo "==QP9EkW0VzUS5kUVFlRKFDT1x2VZRXOplld41WW2dmMjhmSVxUWSNjY35UMMNnRXFmas1mWtlTVMllUzI2dOFDT0ljMZVXSXR2bShVYulTeMZTTINGMShUY" | rev | base64 --decode | base64 --decode)
sxbLiveVer=$(echo "=0zdHJWM1IDTyY1RaZHNq10ZjNlZnNnaJhXUpl0ZR5mYwpESjd2cU10aBNFUnF1Va9mTHRGaxckSnNHSJZnUHlUbZNUSwF1Va9mTHRGaxckSvF1VaVHbtpFbSdVSnlVaKdGOTtkcwwmW0V0VPRXQ6dlb1MEWyF1RYV3dxs0a4xGTjR3QaNWNDhlcRdEWvhTeKdWVtJGdBNkY5Z1Rjd2dIlUaw42YspVMadjUpl0Z3BzY0F0UjRXQDJWeWNTW" | rev | base64 --decode | base64 --decode)
sxbLive=$(eval "${sxbLiveVer}")
sxbVer=$(echo ${buildVer} | perl -ne '/(.*)\./ && print "$1"')
verCk=$(echo "9QzRYNGayMGaKdUZwkzRjpXODplb1k3YwJ0QRdWVHJWaGdkYwZUbkhmQ5NGcCNlZ5hnMZdjUplUOW1GZwh3aZRjTzU2aJNlZ1Z1ValHZyU2aBlmY2xmMjlnVtZVd4ZEW1F1VaBjRHpFMWNjYn1EWhd2ZyMGaKVFTZJ1MidnTGlUb5cUS1lzVhpnSYplMCl3Ywh2RWdGMuN2cOJTZr9meaVHbtJWeGJjV5Q2MiNHeXpVN0hkS" | rev | base64 --decode | base64 --decode)
verCk2=$(eval echo "${verCk}")
ver() { echo "$@" | perl -lane 'printf "%d%03d%04d%05d\n", split(/\./, $_), (0)x4'; }
ver_check() { (($(ver "${sxbVer}") > $(ver "1.1.0.0") && $(ver "${sxbVer}") < $(ver "${sxbLive}"))) && echo -e "${verCk2}"; }
[[ "${verPrint}" ]] && { echo -e "SpotX-Bash version ${sxbVer}\n"; ver_check; exit 0; }

echo
echo "████╗███╗  ███╗ █████╗█╗  █╗  ███╗  ██╗ ████╗█╗ █╗"
echo "█╔══╝█╔═█╗█╔══█╗╚═█╔═╝╚█╗█╔╝  █╔═█╗█╔═█╗█╔══╝█║ █║"
echo "████╗███╔╝█║  █║  █║   ╚█╔╝██╗███╔╝████║████╗████║"
echo "╚══█║█╔═╝ █║  █║  █║   █╔█╗╚═╝█╔═█╗█╔═█║╚══█║█╔═█║"
echo "████║█║   ╚███╔╝  █║  █╔╝ █╗  ███╔╝█║ █║████║█║ █║"
echo "╚═══╝╚╝    ╚══╝   ╚╝  ╚╝  ╚╝  ╚══╝ ╚╝ ╚╝╚═══╝╚╝ ╚╝"
echo
[[ "${logoVar}" ]] && exit 0

command -v unzip >/dev/null || { echo -e "\n${red}Error:${clr} unzip command not found.\nInstall unzip on your system then try again.\n" >&2; exit 1; }
command -v zip >/dev/null || { echo -e "\n${red}Error:${clr} zip command not found.\nInstall zip on your system then try again.\n" >&2; exit 1; }

macos_requirements_check() {
  (("${OSTYPE:6:2}" < 15)) && {
    echo -e "\n${red}Error:${clr} OS X 10.11+ required\n" >&2
    exit 1
  }
  [[ -z "${skipCodesign+x}" ]] && {
    command -v codesign >/dev/null || {
      echo -e "\n${red}Error:${clr} codesign command not found.\nInstall Xcode Command Line Tools then try again.\n\nEnter the following command in Terminal to install:\n${yellow}xcode-select --install${clr}\n" >&2
      exit 1
    }
  }
}

macos_set_version() {
  macOSVer=$(sw_vers -productVersion | cut -d '.' -f 1,2)
  [[ "${debug}" ]] && echo -e "${green}Debug:${clr} macOS ${macOSVer} detected"
  [[ $macOSVer =~ ^(1[1-9]|[2-9][0-9])\. ]] && macOSVer=${macOSVer%%.*}
  [[ -z ${versionVar+x} ]] && {
    [[ "${macOSVer}" == "10.11" || "${macOSVer}" == "10.12" ]] && {
      versionVar="1.1.89.862"
      return
    }
    [[ "${macOSVer}" == "10.13" || "${macOSVer}" == "10.14" ]] && {
      versionVar="1.2.20.1218"
      return
    }
    [[ "${macOSVer}" == "10.15" ]] && {
      versionVar="1.2.37.701"
      return
    }
    [[ "${macOSVer}" == "11" ]] && {
      versionVar="1.2.66.447"
      return
    }
    versionVar="${buildVer}"
  }
  [[ "${macOSVer}" == "10.11" || "${macOSVer}" == "10.12" ]] && (($(ver "${versionVar}") > $(ver "1.1.89.862"))) && {
    echo -e "${red}Error:${clr} Client version ${versionVar} is not supported on macOS 10.11 or 10.12.\nPlease install version 1.1.89.862 or lower.\n" >&2
    exit 1
  }
  [[ "${macOSVer}" == "10.13" || "${macOSVer}" == "10.14" ]] && (($(ver "${versionVar}") > $(ver "1.2.20.1218"))) && {
    echo -e "${red}Error:${clr} Client version ${versionVar} is not supported on macOS 10.13 or 10.14.\nPlease install version 1.2.20.1218 or lower.\n" >&2
    exit 1
  }
  [[ "${macOSVer}" == "10.15" ]] && (($(ver "${versionVar}") > $(ver "1.2.37.701"))) && {
    echo -e "${red}Error:${clr} Client version ${versionVar} is not supported on macOS 10.15.\nPlease install version 1.2.37.701 or lower.\n" >&2
    exit 1
  }
  [[ "${macOSVer}" == "11" ]] && (($(ver "${versionVar}") > $(ver "1.2.66.447"))) && {
    echo -e "${red}Error:${clr} Client version ${versionVar} is not supported on macOS 11.\nPlease install version 1.2.66.447 or lower.\n" >&2
    exit 1
  }
}

macos_set_path() {
  [[ -z "${installPath+x}" ]] && {
    appPath="/Applications/Spotify.app"
    [[ -d "${HOME}${appPath}" ]] && {
      installPath="${HOME}/Applications"
      installOutput=$(echo "${installPath}" | perl -pe 's|^$ENV{HOME}|~|')
      return
    }
    [[ -d "${appPath}" ]] && {
      installPath="/Applications"
      installOutput="${installPath}"
      return
    }
    interactiveMode='true'
    notInstalled='true'
    installPath="/Applications"
    installOutput="${installPath}"
    echo -e "\n${yellow}Warning:${clr} Client not found. Starting interactive mode...\n" >&2
  } || {
    [[ -d "${installPath}/Spotify.app" ]] || {
      echo -e "${red}Error:${clr} Spotify.app not found in the path set by '-P'.\nConfirm the directory and try again.\n" >&2
      exit 1
    }
  }
}

macos_autoupdate_check() {
  autoupdatePath="${HOME}/Library/Application Support/Spotify/PersistentCache/Update"
  [[ -d "${autoupdatePath}" && "$(ls -A "${autoupdatePath}")" ]] && {
    rm -rf "${autoupdatePath}" 2>/dev/null
    echo -e "${green}Notice:${clr} Deleted stock auto-update file waiting to be installed"
  }
}

macos_prepare() {
  macos_requirements_check
  macos_set_version
  archVar=$(sysctl -n machdep.cpu.brand_string | grep -q "Apple" && echo "arm64" || echo "x86_64")
  [[ "${debug}" ]] && echo -e "${green}Debug:${clr} ${archVar} detected"
  grab1=$(echo "==wSRhUZwUTejxGeHNGdGdUZslTaiBnRXJmdJJjYzpkMMVjWXFWYKVkV21kajBnWHRGbwJDT0ljMZVXSXR2bShVYulTeMZTTINGMShUY" | rev | base64 --decode | base64 --decode)
  grab2=$(echo "=0zYTZ2ZzpWS4FVaJdWUuJGcKh0YnNHVNtWQTB1ZRdlWv50RkhWMHp0ZzhUS2J1RJ1WWDlEcRdlWv50RkhWMHp0bRdlW1xWbaxmUXl0ZZlmSnhzULZjSXZ2dJRET4NnbM5WSTZWeG1mV1lzVhpnSYplM0hkSpN2UMlDbU10N1knSpBjbjhmWGFmaKhVW3IVaJ5GMTZmeNpXZ1VFWmJzcuxEMod0S2N2QJxWNXx0Z312YsJESJhjQplUOGpWWop0MadjUpl0Z3BzY0F0UjRXQDJWeWNTW" | rev | base64 --decode | base64 --decode)
  grab3=""; for i in {1..5}; do grab3=$(eval "${grab2}"); [[ -n "${grab3}" ]] && break || sleep 2; done
  [[ -z "${grab3}" ]] && { echo -e "\n${red}Error:${clr} Unable to retrieve download link\n" >&2; exit 1; }
  fileVar=$(basename "${grab3}")
  [[ "${installMac}" ]] && installClient='true' && downloadVer=$(echo "${fileVar}" | perl -ne '/-(\d+\.\d+\.\d+\.\d+)/ && print "$1"')
  [[ "${downloadVer}" ]] && (($(ver "${downloadVer}") < $(ver "1.1.59.710"))) && { echo -e "${red}Error:${clr} ${downloadVer} not supported by SpotX-Bash\n" >&2; exit 1; }
  macos_set_path
  macos_autoupdate_check
  [[ "${debug}" ]] && echo -e "${green}Debug:${clr} Install directory: ${installOutput}\n"
  appPath="${installPath}/Spotify.app"
  appBinary="${appPath}/Contents/MacOS/Spotify"
  appBak="${appBinary}.bak"
  cachePath="${HOME}/Library/Caches/com.spotify.client"
  snapshotBinary="${appPath}/Contents/Frameworks/Chromium Embedded Framework.framework/Resources/v8_context_snapshot.${archVar}.bin"
  xpuiPath="${appPath}/Contents/Resources/Apps"
  [[ "${skipCodesign}" ]] && echo -e "${yellow}Warning:${clr} Codesigning has been skipped.\n" >&2 || true
}

linux_client_variant() {
  [[ "${installPath}" == *"flatpak"* ]] && {
    command -v flatpak >/dev/null && flatpak list | grep spotify >/dev/null && {
      flatpakVer=$(LANG=C.UTF-8 flatpak info com.spotify.Client | grep Version: | perl -ne '/Version: (1\.[0-9]+\.[0-9]+\.[0-9]+)\.g[0-9a-f]+/ && print "$1"')
      [[ -z "${flatpakVer+x}" ]] && versionFailed='true' || { clientVer="${flatpakVer}"; flatpakClient='true'; }
      cachePath=$(timeout 10 find /var/lib/flatpak/ $HOME/.var/app -type d -path "*com.spotify.Client/cache/spotify*" -name "spotify" -print -quit 2>/dev/null)
    }
    return 0
  }
  [[ "${installPath}" == *"opt/spotify"* || "${installPath}" == *"spotify-launcher"* || "${installPath}" == *"usr/share/spotify"* ]] && {
    cachePath=$(timeout 10 find $HOME/.cache/ -type d -path "*.cache/spotify*" -not -path "*snap/spotify*" -name "spotify" -print -quit 2>/dev/null)
    return 0
  }
  return 0
}

linux_deb_prepare() {
  command -v apt >/dev/null || { echo -e "${red}Error:${clear} Debian-based Linux distro with APT support is required." >&2; exit 1; }
  installPath=/usr/share/spotify
  installOutput="${installPath}"
  linux_client_variant
  installClient='true'
  grab1=$(echo "=0TP3xEd5ITW1tmbaBnUzI2dO5GT1o0MiBDbyMmdChlW5lTeMZTTINGMShUY" | rev | base64 --decode | base64 --decode)
  [[ "${stableVar}" ]] && \
  grab2=$(echo "==QP9cWS6ZlMahGdykFaCFDTwkFRaRnRXxUNKhVW1xWbZZXVXpVeadFT1lTbiZXVHJWaGdEZ6lTejBjTYF2axgVTpZUbj5GdIpUaBl3Y0F0UjRXQDJWeWNTW" | rev | base64 --decode | base64 --decode) || \
  grab2=$(echo "==QPJl3YsR2VZJnTXlVU5MkTyE1VihWMTVWeG1mYwpkMMxmVtNWbxkmY2VjMM5WNXFGMOhlWwkTejBjTYF2axgVTpZUbj5GdIpUaBl3Y0F0UjRXQDJWeWNTW" | rev | base64 --decode | base64 --decode)
  grab3=$(eval "${grab2}" 2>/dev/null)
  grab4=$(echo "${grab3}" | grep -m 1 "^Filename: " | perl -pe 's/^Filename: //')
  grab5="${grab1}${grab4}"
  fileVar=$(basename "${grab4}")
  downloadVer=$(echo "${fileVar}" | perl -pe 's/^[a-z-]+_([0-9.]+)\.g.*/\1/')
  [[ ! -f "${installPath}/Apps/xpui.spa" ]] && notInstalled='true'
}

linux_no_client() {
  command -v snap >/dev/null && snap list spotify &>/dev/null && {
    echo -e "${red}Error:${clr} Snap client not supported. See FAQ for more info.\nIf another Spotify package is installed, set directory path with '-P' flag.\n" >&2
    exit 1
  }
  command -v apt >/dev/null && {
    interactiveMode='true'
    linux_deb_prepare
    echo -e "\n${yellow}Warning:${clr} Client not found. Starting interactive mode...\n" >&2
    return
  }
  echo -e "${red}Error:${clr} Client installation not found.\nInstall client or set directory path with '-P' flag.\n" >&2
  command -v spicetify >/dev/null && echo -e "If client is installed but Spicetify has been applied,\nrun ${yellow}'spicetify restore'${clr} then try again.\n" >&2
  exit 1
}

linux_search_path() {
  local timeout=6
  local paths=("/opt" "/usr/share" "/var/lib/flatpak" "$HOME/.local/share" "/")
  for path in "${paths[@]}"; do
    local path="${path}"
    local timeLimit=$(($(date +%s) + timeout))
    while (( $(date +%s) < "${timeLimit}" )); do
      installPath=$(find "${path}" -type f -path "*/spotify*Apps/*" -not -path "*snapd/snap*" -not -path "*snap/spotify*" -not -path "*snap/bin*" -not -path "*flatpak/.removed*" -name "xpui.spa" -size -20M -size +3M -print -quit 2>/dev/null | rev | cut -d/ -f3- | rev)
      [[ -n "${installPath}" ]] && return 0
      pgrep -x find > /dev/null || break
      sleep 1
    done
  done
  return 1
}

linux_set_path() {
  [[ "${installDeb}" ]] && { linux_deb_prepare; return; }
  [[ -z "${installPath+x}" ]] && {
    echo -e "Searching for client directory...\n"
    linux_search_path
    [[ -d "${installPath}" ]] && {
      installOutput=$(echo "${installPath}" | perl -pe 's|^$ENV{HOME}|~|')
      echo -e "Found client Directory: ${installOutput}\n"
      linux_client_variant
    } || linux_no_client
    return
  }
  [[ "${installPath}" == *"snapd/snap"* || "${installPath}" == *"snap/spotify"* || "${installPath}" == *"snap/bin"* ]] && {
    echo -e "${red}Error:${clr} Snap client not supported. See FAQ for more info.\n" >&2
    exit 1
  }
  [[ -f "${installPath}/Apps/xpui.spa" ]] && {
    echo -e "Using client Directory: ${installOutput}\n"
    linux_client_variant
  } || {
    echo -e "${red}Error:${clr} Client not found in path set by '-P'.\nConfirm directory and try again.\n" >&2
    exit 1
  }
}

linux_prepare() {
  archVar="x86_64"
  linux_set_path
  appPath="${installPath}"
  appBinary="${appPath}/spotify"
  appBak="${appBinary}.bak"
  snapshotBinary="${appPath}/v8_context_snapshot.bin"
  xpuiPath="${appPath}/Apps"
  [[ -z "${cachePath}" ]] && cachePath=$(timeout 10 find / -type d -path "*cache/spotify*" -not -path "*snap/spotify*" -name "spotify" -print -quit 2>/dev/null)
  [[ "${debug}" ]] && echo -e "${green}Debug:${clr} $(cat /etc/*release | grep PRETTY_NAME | cut -d '"' -f2)"
  [[ "${debug}" ]] && echo -e "${green}Debug:${clr} $(uname -m) detected"
  [[ "${debug}" ]] && command -v apt >/dev/null && echo -e "${green}Debug:${clr} APT detected"
  [[ "${debug}" ]] && command -v flatpak >/dev/null && echo -e "${green}Debug:${clr} flatpak detected"
  [[ "${debug}" ]] && command -v snap >/dev/null && echo -e "${green}Debug:${clr} snap detected"
  [[ "${debug}" ]] && { [[ "${cachePath}" ]] && { cacheOutput=$(echo "${cachePath}" | perl -pe 's|^$ENV{HOME}|~|'); echo -e "${green}Debug:${clr} Cache directory: ${cacheOutput}\n"; } || echo; }
}

existing_client_ver() {
  [[ "${platformType}" == "macOS" ]] && {
    [[ -z "${installMac+x}" || -z "${notInstalled+x}" ]] && [[ -z "${forceVer+x}" ]] && {
      [[ -f "${appPath}/Contents/Info.plist" ]] && {
        clientVer=$(defaults read "${appPath}/Contents/Info.plist" CFBundleShortVersionString 2>/dev/null | perl -pe 's/\.g[0-9a-f]+//')
        [[ -z "${clientVer}" ]] && versionFailed='true' ; :
      } || versionFailed='true'
    }
    return
  }
  [[ "${platformType}" == "Linux" ]] && {
    [[ -z "${installClient+x}" || -z "${notInstalled+x}" ]] && [[ -z "${forceVer+x}" && -z "${flatpakClient}" ]] && {
      "${appBinary}" --version >/dev/null 2>/dev/null && {
        clientVer=$("${appBinary}" --version 2>/dev/null | cut -d " " -f3- | rev | cut -d. -f2- | rev)
        [[ -z "${clientVer}" ]] && versionFailed='true' ; :
      } || versionFailed='true'
    }
  }
}

client_version_output() {
  echo -e "Latest supported version: ${sxbVer}"
  [[ "${forceVer}" ]] && {
    echo -e "Forced client version: ${forceVer}\n"; return
  }
  [[ "${notInstalled}" || "${versionFailed}" ]] && [[ -z "${installClient+x}" ]] && {
    echo -e "Detected client version: ${red}N/A${clr}\n"; return
  }
  [[ "${installClient}" ]] && (($(ver "${downloadVer}") <= $(ver "${sxbVer}") && $(ver "${downloadVer}") > $(ver "0"))) && {
    echo -e "Requested client version: ${green}${downloadVer}${clr}\n"; return
  }
  [[ "${installClient}" ]] && (($(ver "${downloadVer}") > $(ver "${sxbVer}"))) && {
    echo -e "Requested client version: ${red}${downloadVer}${clr}\n"; return
  }
  (($(ver "${clientVer}") <= $(ver "${sxbVer}") && $(ver "${clientVer}") > $(ver "0"))) && {
    echo -e "Detected client version: ${green}${clientVer}${clr}\n"; return
  }
  (($(ver "${clientVer}") > $(ver "${sxbVer}"))) && {
    echo -e "Detected client version: ${red}${clientVer}${clr}\n"; return
  }
}

run_prepare() {
  [[ "${platformType}" == "macOS" ]] && macos_prepare || linux_prepare
  xpuiBak="${xpuiPath}/xpui.bak"
  xpuiDir="${xpuiPath}/xpui"
  xpuiSpa="${xpuiPath}/xpui.spa"
  dwpPanelSectionJs="${xpuiDir}/dwp-panel-section.js"
  homeHptoJs="${xpuiDir}/home-hpto.js"
  indexHtml="${xpuiDir}/index.html"
  vendorXpuiJs="${xpuiDir}/vendor~xpui.js"
  xpuiCss="${xpuiDir}/xpui.css"
  xpuiDesktopModalsJs="${xpuiDir}/xpui-desktop-modals.js"
  xpuiJs="${xpuiDir}/xpui.js"
  xpuiSnapshotJs="${xpuiDir}/xpui-snapshot.js"
  existing_client_ver
  client_version_output
  ver_check
  command pgrep [sS]potify 2>/dev/null | xargs kill -9 2>/dev/null
  [[ -f "${appBinary}" ]] && cleanAB=$(perl -ne '$found1 = 1 if /\x00\x73\x6C\x6F\x74\x73\x00/; $found2 = 1 if /\x2D\x70\x72\x65\x72\x6F\x6C\x6C/; END { print "true" if $found1 && $found2 }' "${appBinary}")
}

check_write_permission() {
  local paths=("$@")
  for path in "${paths[@]}"; do
    local path="${path}"
    [[ ! -w "${path}" ]] && {
      sudo -n true 2>/dev/null || {
        echo -e "${yellow}Warning:${clr} SpotX-Bash does not have write permission in client directory.\nRequesting sudo permission..." >&2
        sudo -v || {
          echo -e "\n${red}Error:${clr} SpotX-Bash was not given sudo permission. Exiting...\n" >&2
          exit 1
        }
      }
      sudo chmod -R a+wr "${appPath}"
    }
  done
}

uninstall_spotx() {
  rm "${appBinary}" 2>/dev/null
  mv "${appBak}" "${appBinary}"
  rm "${xpuiSpa}" 2>/dev/null
  mv "${xpuiBak}" "${xpuiSpa}"
  rm -rf "${xpuiDir}" 2>/dev/null
}

run_uninstall_check() {
  [[ "${uninstallSpotx}" ]] && {
    [[ ! -f "${appBak}" || ! -f "${xpuiBak}" ]] && {
      echo -e "${red}Error:${clr} No backup found, exiting...\n" >&2
      exit 1
    }
    check_write_permission "${appPath}" "${appBinary}" "${xpuiPath}" "${xpuiSpa}"
    [[ "${cleanAB}" ]] && {
      echo -e "${yellow}Warning:${clr} SpotX-Bash has detected abnormal behavior.\nClient reinstallation may be required...\n" >&2
      rm "${appBak}" 2>/dev/null
      rm "${xpuiBak}" 2>/dev/null
    } || {
      uninstall_spotx
    }
    printf "\xE2\x9C\x94\x20\x46\x69\x6E\x69\x73\x68\x65\x64\x20\x75\x6E\x69\x6E\x73\x74\x61\x6C\x6C\n\n"
    exit 0
  }
}

perlvar() {
  { local e; e=$($perlVar 'BEGIN { $m = 0; $c = 0 } $c += s&'"${a[1]}"'&'"${a[2]}"'&'"${a[3]}"' and $m = 1; END { print "$m,$c" }' "${p}")
    local s="$?"
    local m=$(echo "${e}" | cut -d',' -f1)
    local c=$(echo "${e}" | cut -d',' -f2)
    { { [[ "${s}" != 0 && "${debug}" && "${devMode}" && "${t}" ]] && echo -e "${red}Error:${clr} ${a[0]} invalid entry"; } ||
      { [[ "${m}" == 0 && "${debug}" && "${devMode}" && "${t}" ]] && echo -e "${yellow}Warning:${clr} ${a[0]} missing"; } ||
      { [[ "${a[9]}" && "${c}" != "${a[9]}" && "${debug}" && "${devMode}" && "${t}" ]] && echo -e "${yellow}Warning:${clr} ${a[0]} ${a[9]}, ${c}"; }
    }
  }
}

read_yn() {
  local yn
  while : ; do
    read -rp "$*" yn
    case "$yn" in
      [Yy]* ) return 0 ;;
      [Nn]* ) return 1 ;;
          * ) echo "Please enter [y]es or [n]o." ;;
    esac
  done
}

run_interactive_check() {
  [[ "${interactiveMode}" ]] && {
    printf "\xE2\x9C\x94\x20\x53\x74\x61\x72\x74\x65\x64\x20\x69\x6E\x74\x65\x72\x61\x63\x74\x69\x76\x65\x20\x6D\x6F\x64\x65\x20\x5B\x65\x6E\x74\x65\x72\x20\x79\x2F\x6E\x5D\n\n"
    [[ "${platformType}" == "macOS" && -z "${clientVer+x}" ]] && clientVer="${versionVar}"
    [[ "${platformType}" == "macOS" && -z "${installMac+x}" ]] && { read_yn "Download & install client ${versionVar}? " && { installClient='true'; installMac='true'; }; }
    [[ "${platformType}" == "macOS" ]] && { read_yn "Block client auto-updates? " && blockUpdates='true'; }
    [[ "${platformType}" == "Linux" && -z "${installDeb+x}" && "${notInstalled}" ]] && { read_yn "Download & install client ${downloadVer} deb pkg? " && installDeb='true' clientVer="${downloadVer}" || installClient='false'; }
    [[ -d "${cachePath}" ]] && read_yn "Clear client app cache? " && clearCache='true'
    (($(ver "${clientVer}") >= $(ver "1.1.93.896") && $(ver "${clientVer}") <= $(ver "1.2.13.661"))) && { read_yn "Enable new home screen UI? " || oldUi='true'; }
    (($(ver "${clientVer}") > $(ver "1.1.99.878"))) && { read_yn "Enable developer mode? " && devMode='true'; }
    (($(ver "${clientVer}") >= $(ver "1.1.70.610"))) && { read_yn "Hide non-music categories on home screen? " && hideNonMusic='true'; }
    (($(ver "${clientVer}") >= $(ver "1.2.0.1165"))) && { read_yn "Set lyrics background color to black? " && lyricsBg='true'; }
    echo
  }
}

sudo_check() {
  command -v sudo &> /dev/null || {
    echo -e "\n${red}Error:${clr} sudo command not found. Install sudo or run this script as root.\n" >&2
    exit 1
  }
  sudo -n true &> /dev/null || {
    echo -e "This script requires sudo permission to install the client.\nPlease enter your sudo password..."
    sudo -v || {
      echo -e "\n${red}Error:${clr} Failed to obtain sudo permission. Exiting...\n" >&2
      exit 1
    }
  }
}

linux_working_dir() { [[ -d "/tmp" ]] && workDir="/tmp" || workDir="$HOME"; }

linux_deb_install() {
  sudo_check
  linux_working_dir
  lc01=$(echo "=kjQ59EeBNEZwhGWad2cq1Ub0QUSpRzRYtmVHJGcG1mWnF1VZZHetJ2M5ckWnFlbixGbHJGRCNlZ5hnMZdjUp9Ue502Y5ZVVmtmVtN2NSlmYjp0QJxWMDlkdoJTWsJUeld2dIZ2ZJNlTpZUbj5mUpl0Z3dkYxUjMMJjVHpldBlnY0FUejRXQTNFdBlmW0F0UjRXQDJWeWNTW" | rev | base64 --decode | base64 --decode)
  lc02=$(echo "9ADSJdTRElEMsdUZsJUePlXWpB1ZJlmYjJ1VaNHbXlVbCNkWolzRiVHZzI2aCNEZ1Z1VhNnTFlUOKhkYqRHSKZTSzIWeKhlU5I1ValHdIpUd4xWSnV1VMdGOHFmaWdUS3I0QmhjQplUMJdVW5R2RKlWQplUOKhVWXZ1RiBnWyU2a4MlZ5x2RSJnSzI2M0hkSpFUeiRXQT50Zr52YwYVbjRHMDlEdBlXU0FUaaRXQpNGaKdFT65EWalHZyIWeChFT0F0UjRXQDJWeWNTW" | rev | base64 --decode | base64 --decode)
  eval "${lc01}"; eval "${lc02}"
  printf "\xE2\x9C\x94\x20\x44\x6F\x77\x6E\x6C\x6F\x61\x64\x65\x64\x20\x61\x6E\x64\x20\x69\x6E\x73\x74\x61\x6C\x6C\x69\x6E\x67\x20\x53\x70\x6F\x74\x69\x66\x79\n"
  [[ -f "${appBak}" ]] && sudo rm "${appBak}" 2>/dev/null
  [[ -f "${xpuiBak}" ]] && sudo rm "${xpuiBak}" 2>/dev/null
  [[ -d "${xpuiDir}" ]] && sudo rm -rf "${xpuiDir}" 2>/dev/null
  sudo dpkg -i "${workDir}/${fileVar}" &>/dev/null || {
    sudo apt-get -f install -y &>/dev/null || {
      rm "${workDir}/${fileVar}" 2>/dev/null
      echo -e "\n${red}Error:${clr} Failed to install missing dependencies. Exiting...\n" >&2
      exit 1
    }
  } && sudo dpkg -i "${workDir}/${fileVar}" &>/dev/null || {
    rm "${workDir}/${fileVar}" 2>/dev/null
    echo -e "\n${red}Error:${clr} Client install failed. Exiting...\n" >&2
    exit 1
  }
  printf "\xE2\x9C\x94\x20\x49\x6E\x73\x74\x61\x6C\x6C\x65\x64\x20\x69\x6E\x20'"${installOutput}"'\n"
  rm "${workDir}/${fileVar}" 2>/dev/null
  clientVer=$(echo "${fileVar}" | perl -pe 's/^[a-z-]+_([0-9.]+)\.g.*/\1/')
  unset notInstalled versionFailed
}

macos_client_install() {
  [[ ! -w "${installPath}" ]] && {
    echo -e "${red}Error:${clr} SpotX-Bash does not have write permission in ${installOutput}.\nConfirm permissions or set custom install path to writable directory.\n" >&2
    exit 1
  }
  mc01=$(echo "=kjQ59EeBNEZwhGWad2cq1Ub0QUSpRzRYtmVHJGcG1mWnF1VZZHetJ2M5ckWnFlbixGbHJGRCNlZ5hnMZdjUp9Ue502Y5ZVVmtmVtN2NSlmYjp0QJxWMDlkdoJTWsJUeld2dIZ2ZJlXTpZUbj5mUpl0Z3dkYxUjMMJjVHpldBlnY0FUejRXQTNFdBlmW0F0UjRXQDJWeWNTW" | rev | base64 --decode | base64 --decode)
  mc02=$(echo "=0TPRZ2ZzRVTnFFWhRjVHl0NJpmSrEUaJVHeGpFb4dVYop1RJtmRyI2c1IDZ2J1RJBTNXpFc4JTUnBjbjNnTyU2avp2Y2pkbjZUMIpFbKNTZrRzRYlWQTpFdBlnYv50Vad2cIlEO4hUSp1kaZhmSzo1aJNUSpBjbjhmWWp1cs1mW3IVeMpnUXlld41mYzkzRSZXVVRFUoVkSpFUeiRXQT50Zr52YwYVbjRHMDlEdBlXU0FUaaRXQpNGaKdFT65EWalHZyIWeChFT0F0UjRXQDJWeWNTW" | rev | base64 --decode | base64 --decode)
  eval "${mc01}"; eval "${mc02}"
  printf "\xE2\x9C\x94\x20\x44\x6F\x77\x6E\x6C\x6F\x61\x64\x65\x64\x20\x61\x6E\x64\x20\x69\x6E\x73\x74\x61\x6C\x6C\x69\x6E\x67\x20\x53\x70\x6F\x74\x69\x66\x79\n"
  rm -rf "${appPath}" 2>/dev/null
  mkdir "${appPath}"
  tar -xpf "$HOME/Downloads/${fileVar}" -C "${appPath}" && unset notInstalled versionFailed || {
    rm "$HOME/Downloads/${fileVar}" 2>/dev/null
    echo -e "\n${red}Error:${clr} Client install failed. Exiting...\n" >&2
    exit 1
  }
  printf "\xE2\x9C\x94\x20\x49\x6E\x73\x74\x61\x6C\x6C\x65\x64\x20\x69\x6E\x20'"${installOutput}"'\n"
  rm "$HOME/Downloads/${fileVar}"
  clientVer=$(echo "${fileVar}" | perl -ne '/te-(.*)\..*\./ && print "$1"')
}

run_install_check() {
  [[ "${installClient}" ]] && {
    [[ "${installDeb}" ]] && linux_deb_install
    [[ "${installMac}" ]] && macos_client_install
  }
}

run_cache_check() {
  [[ "${clearCache}" ]] && {
    rm -rf "${cachePath}/Browser" 2>/dev/null
    rm -rf "${cachePath}/Data" 2>/dev/null
    rm -rf "${cachePath}/Default/Local Storage/leveldb" 2>/dev/null
    rm -rf "${cachePath}/public.ldb" 2>/dev/null
    rm "${cachePath}/LocalPrefs.json" 2>/dev/null
    printf "\xE2\x9C\x94\x20\x43\x6C\x65\x61\x72\x65\x64\x20\x61\x70\x70\x20\x63\x61\x63\x68\x65\n"
  }
}

final_setup_check() {
  [[ "${notInstalled}" ]] && { echo -e "${red}Error:${clr} Client not found\n" >&2; exit 1; }
  [[ ! -f "${xpuiSpa}" ]] && { echo -e "${red}Error:${clr} Detected a modified client installation!\nReinstall client then try again.\n" >&2; exit 1; }
  [[ "${clientVer}" ]] && (($(ver "${clientVer}") < $(ver "1.1.59.710"))) && { echo -e "${red}Error:${clr} ${clientVer} not supported by SpotX-Bash\n" >&2; exit 1; }
}

perlVar() {
  local A=("$@")
  for cmd in "${A[@]}"; do
    IFS='&' read -r -a a <<< "${cmd}"
    local f="${a[4]}"
    local p="${!f}"
    [[ ! -f "${p}" && "${debug}" && "${devMode}" && "${t}" ]] && {
      echo -e "${red}Error:${clr} ${a[0]} invalid entry"
      continue
    }
    { { [[ -z "${a[5]}" ]] || (( $(ver "${clientVer}") >= $(ver "${a[5]}") )); } &&
      { [[ -z "${a[6]}" ]] || (( $(ver "${clientVer}") <= $(ver "${a[6]}") )); } &&
      { [[ -z "${a[7]}" ]] || [[ "${a[7]}" =~ (^|\|)"${platformType}"($|\|) ]]; } &&
      { [[ -z "${a[8]}" ]] || [[ "${a[8]}" =~ (^|\|)"${archVar}"($|\|) ]]; }
    } && perlvar "${xpuiSpa}"
  done
}

xpui_detect() {
  [[ (-f "${appBak}" || -f "${xpuiBak}") && "${cleanAB}" ]] && {
    rm "${appBak}" 2>/dev/null; rm "${xpuiBak}" 2>/dev/null
    cp "${xpuiSpa}" "${xpuiBak}"; cp "${appBinary}" "${appBak}"
    printf "\xE2\x9C\x94\x20\x43\x72\x65\x61\x74\x65\x64\x20\x62\x61\x63\x6B\x75\x70\n"
    return
  }
  [[ (-f "${appBak}" || -f "${xpuiBak}") && "${forceSpotx}" ]] && {
    [[ -f "${appBak}" ]] && { rm "${appBinary}"; cp "${appBak}" "${appBinary}"; }
    [[ -f "${xpuiBak}" ]] && { rm "${xpuiSpa}"; cp "${xpuiBak}" "${xpuiSpa}"; }
    printf "\xE2\x9C\x94\x20\x44\x65\x74\x65\x63\x74\x65\x64\x20\x26\x20\x72\x65\x73\x74\x6F\x72\x65\x64\x20\x62\x61\x63\x6B\x75\x70\n"
    return
  }
  [[ (-f "${appBak}" || -f "${xpuiBak}") && -z "${forceSpotx+x}" ]] && {
    xpuiSkip='true'
    printf "\xE2\x9C\x94\x20\x44\x65\x74\x65\x63\x74\x65\x64\x20\x62\x61\x63\x6B\x75\x70\n"
    echo -e "\n${yellow}Warning:${clr} SpotX-Bash has already been installed." >&2
    echo -e "Use the '-f' flag to force SpotX-Bash to run.\n" >&2
    return
  }
  cp "${xpuiSpa}" "${xpuiBak}"
  cp "${appBinary}" "${appBak}"
  printf "\xE2\x9C\x94\x20\x43\x72\x65\x61\x74\x65\x64\x20\x62\x61\x63\x6B\x75\x70\n"
}

snapshot_check() {
  START_XM="76006100720020005F005F007700650062007000610063006B005F006D006F00640075006C00650073005F005F003D007B00"
  END_XM="78007000750069002D006D006F00640075006C00650073002E006A0073002E006D0061007000"
  [[ ! -f "${xpuiJs}" ]] && [[ -f "${xpuiSnapshotJs}" ]] && {
    [[ "${debug}" ]] && printf "\xE2\x9C\x94\x20\x44\x65\x74\x65\x63\x74\x65\x64\x20\x53\x6E\x61\x70\x73\x68\x6F\x74${clr}\n"
    perl -e 'use strict; use warnings; use Encode qw(decode); open my $in_fh, "<:raw", $ARGV[0] or die; binmode $in_fh; my $bin_content; { local $/; $bin_content = <$in_fh>; } close $in_fh; die unless (length($bin_content) >= 2 && substr($bin_content, 0, 2) eq "\xFF\xFE") || (length($bin_content) > 100 && substr($bin_content, 1, 1) eq "\x00"); my $start_marker = pack("H*", $ARGV[1]); my $end_marker = pack("H*", $ARGV[2]); my $start_idx = index($bin_content, $start_marker, 2); die if $start_idx == -1; my $end_idx = index($bin_content, $end_marker, $start_idx + length($start_marker)); die if $end_idx == -1; my $extracted = substr($bin_content, $start_idx, $end_idx - $start_idx + length($end_marker)); my $decoded = decode("UTF-16LE", $extracted); open my $out_fh, "+<:encoding(UTF-8)", $ARGV[3] or die; my $existing_content; { local $/; $existing_content = <$out_fh>; } seek $out_fh, 0, 0; print $out_fh $decoded, "\n", $existing_content; truncate $out_fh, tell($out_fh); close $out_fh;' "${snapshotBinary}" "${START_XM}" "${END_XM}" "${xpuiSnapshotJs}" || { uninstall_spotx; echo -e "\n${red}Error:${clr} Snapshot processing failed\n" >&2; exit 1; }
    xpuiCss="${xpuiDir}/xpui-snapshot.css"
    xpuiJs="${xpuiSnapshotJs}"
  }
}

xpui_open() {
  mkdir -p "${xpuiDir}"
  unzip -qq "${xpuiSpa}" -d "${xpuiDir}"
  snapshot_check
  [[ "${versionFailed}" && -z "${forceVer+x}" || -z "${forceVer+x}" && "${debug}" && "${devMode}" && "${t}" ]] && {
    clientVer=$(perl -ne '/[Vv]ersion[:=,\x22]{1,3}(1\.[0-9]+\.[0-9]+\.[0-9]+)\.g[0-9a-f]+/ && print "$1"' "${xpuiJs}")
    [[ -z "${clientVer}" && "${debug}" && "${devMode}" && "${t}" ]] && {
      uninstall_spotx
      echo -e "${red}Error:${clr} Empty client version\n" >&2
      exit 1
    }
    [[ -z "${clientVer}" ]] && {
      clientVer="${sxbVer}"
      unknownVer='true'
      echo -e "\n${red}Warning:${clr} Client version not detected, some features may not be applied\n" >&2
    } || {
      (( $(ver "${clientVer}") < $(ver "1.1.59.710") )) && {
        uninstall_spotx
        echo -e "\n${red}Error:${clr} ${clientVer} not supported by SpotX-Bash\n" >&2
        exit 1
      }
    }
    [[ -z "${unknownVer+x}" ]] && (( $(ver "${clientVer}") <= $(ver "${sxbVer}") && $(ver "${clientVer}") > $(ver "0") )) && printf "\xE2\x9C\x94\x20\x44\x65\x74\x65\x63\x74\x65\x64\x20\x53\x70\x6F\x74\x69\x66\x79\x20${green}${clientVer}${clr}\n"
    [[ -z "${unknownVer+x}" ]] && (( $(ver "${clientVer}") > $(ver "${sxbVer}") )) && printf "\xE2\x9C\x94\x20\x44\x65\x74\x65\x63\x74\x65\x64\x20\x53\x70\x6F\x74\x69\x66\x79\x20${red}${clientVer}${clr}\n"
  }
  grep -Fq "SpotX" "${xpuiJs}" && {
    rm -rf "${xpuiBak}" "${xpuiDir}" 2>/dev/null
    echo -e "\n${red}Error:${clr} Detected SpotX-Bash but no backup file! Reinstall client. Exiting...\n" >&2
    exit 1
  }
}

run_core_start() {
  final_setup_check
  check_write_permission "${appPath}" "${appBinary}" "${xpuiPath}" "${xpuiSpa}"
  xpui_detect
  [[ "${xpuiSkip}" ]] && { printf "\xE2\x9C\x94\x20\x46\x69\x6E\x69\x73\x68\x65\x64\n\n"; exit 1; }
  xpui_open
  (($(ver "${clientVer}") > $(ver "1.2.56.9999"))) && vendorXpuiJs="${xpuiJs}"
}

run_patches() {
  perlVar "${aoEx[@]}"
  [[ "${paidPremium}" ]] && printf "\xE2\x9C\x94\x20\x44\x65\x74\x65\x63\x74\x65\x64\x20\x70\x72\x65\x6D\x69\x75\x6D\x2D\x74\x69\x65\x72\x20\x70\x6C\x61\x6E\n" || {
    perlVar "${freeEx[@]}"
    printf '\n%s\n%s\n%s\n%s\n%s' "${hideDLIcon}" "${hideDLMenu}" "${hideDLMenu2}" "${hideDLQual}" "${hideVeryHigh}"  >> "${xpuiCss}"
    printf "\xE2\x9C\x94\x20\x41\x70\x70\x6C\x69\x65\x64\x20\x66\x72\x65\x65\x2D\x74\x69\x65\x72\x20\x70\x6C\x61\x6E\x20\x70\x61\x74\x63\x68\x65\x73\n"
  }
  [[ "${devMode}" ]] && (($(ver "${clientVer}") >= $(ver "1.1.84.716"))) && {
    perlVar "${devEx[@]}"
    printf "\xE2\x9C\x94\x20\x45\x6E\x61\x62\x6C\x65\x64\x20\x64\x65\x76\x65\x6C\x6F\x70\x65\x72\x20\x6D\x6F\x64\x65\n"
  }
  [[ "${excludeExp}" ]] && printf "\xE2\x9C\x94\x20\x53\x6B\x69\x70\x70\x65\x64\x20\x65\x78\x70\x65\x72\x69\x6D\x65\x6E\x74\x61\x6C\x20\x66\x65\x61\x74\x75\x72\x65\x73\n" || {
    perlVar "${expEx[@]}"
    [[ "${paidPremium}" ]] && perlVar "${premiumExpEx[@]}"
    [[ -z "${hideNonMusic+x}" ]] && $perlVar 's|Enable Subfeed filter chips on home",default:\K!1|true|s' "${xpuiJs}" #enableHomeSubfeeds 1.2.20.1210
    printf "\xE2\x9C\x94\x20\x45\x6E\x61\x62\x6C\x65\x64\x20\x65\x78\x70\x65\x72\x69\x6D\x65\x6E\x74\x61\x6C\x20\x66\x65\x61\x74\x75\x72\x65\x73\n"
  }
  [[ "${oldUi}" ]] && {
    perlVar "${oldUiEx[@]}"
    (($(ver "${clientVer}") >= $(ver "1.1.93.896") && $(ver "${clientVer}") <= $(ver "1.2.13.661"))) && printf "\xE2\x9C\x94\x20\x45\x6E\x61\x62\x6C\x65\x64\x20\x6F\x6C\x64\x20\x55\x49\n"
    (($(ver "${clientVer}") > $(ver "1.2.13.661"))) && {
      unset oldUi
      echo -e "\n${yellow}Warning:${clr} Old UI not supported in clients after v1.2.13.661...\n" >&2
    }
  }
  [[ -z "${oldUi+x}" ]] && (($(ver "${clientVer}") >= $(ver "1.1.93.896"))) && {
    perlVar "${newUiEx[@]}"
    (($(ver "${clientVer}") <= $(ver "1.2.13.661"))) && printf "\xE2\x9C\x94\x20\x45\x6E\x61\x62\x6C\x65\x64\x20\x6E\x65\x77\x20\x55\x49\n"
  }
  [[ "${hideNonMusic}" ]] && (($(ver "${clientVer}") >= $(ver "1.1.70.610"))) && {
    perlVar "${podEx[@]}"
    (($(ver "${clientVer}") >= $(ver "1.2.45.451"))) && printf '\n%s' "${hideSubfeed}" >> "${xpuiCss}"
    printf "\xE2\x9C\x94\x20\x52\x65\x6D\x6F\x76\x65\x64\x20\x6E\x6F\x6E\x2D\x6D\x75\x73\x69\x63\x20\x63\x61\x74\x65\x67\x6F\x72\x69\x65\x73\x20\x6F\x6E\x20\x68\x6F\x6D\x65\x20\x73\x63\x72\x65\x65\x6E\n"
  }
  [[ "${lyricsBg}" ]] && {
    (($(ver "${clientVer}") >= $(ver "1.2.0.1165"))) && {
      perlVar "${lyricsBgEx[@]}"
      (($(ver "${clientVer}") >= $(ver "1.2.45.454"))) && printf '\n%b' "${lyricsBackgroundNew}" >> "${xpuiCss}"
      printf "\xE2\x9C\x94\x20\x45\x6E\x61\x62\x6C\x65\x64\x20\x62\x6C\x61\x63\x6B\x20\x62\x61\x63\x6B\x67\x72\x6F\x75\x6E\x64\x20\x66\x6F\x72\x20\x6C\x79\x72\x69\x63\x73\n"
    } || {
      echo -e "\n${yellow}Warning:${clr} Black lyrics background is not supported in this version...\n" >&2
    }
  }
  [[ "${blockUpdates}" ]] && {
    perlVar "${updatesEx[@]}"
    printf "\xE2\x9C\x94\x20\x42\x6C\x6F\x63\x6B\x65\x64\x20\x61\x75\x74\x6F\x6D\x61\x74\x69\x63\x20\x75\x70\x64\x61\x74\x65\x73\n"
  }
}

run_finish() {
  echo -e "\n//# SpotX was here" >> "${xpuiJs}"
  rm "${xpuiSpa}"
  (cd "${xpuiDir}" || exit; zip -qq -r ../xpui.spa .)
  rm -rf "${xpuiDir}"
  [[ "${platformType}" == "macOS" ]] && {
    [[ "${skipCodesign}" ]] && /usr/bin/xattr -cr "${appPath}" 2>/dev/null || {
      /usr/bin/xattr -cr "${appPath}" 2>/dev/null
      codesign -f --deep -s - "${appPath}" 2>/dev/null
      printf "\xE2\x9C\x94\x20\x43\x6F\x64\x65\x73\x69\x67\x6E\x65\x64\x20\x53\x70\x6F\x74\x69\x66\x79\n"
    }
  }
}

perlVar="perl -0777pi -w -e"
hideDLIcon=' .BKsbV2Xl786X9a09XROH, .GWCBhKJqeZal3n5tCQwl {display:none}'
hideDLMenu=' button.wC9sIed7pfp47wZbmU6m.pzkhLqffqF_4hucrVVQA {display:none}'
hideDLMenu2=' .pzkhLqffqF_4hucrVVQA, .egE6UQjF_UUoCzvMxREj, .Y98_oiegQgSpY_o7hoKG {display:none}'
hideDLQual=' :is(.weV_qxFz4gF5sPotO10y, .BMtRRwqaJD_95vJFMFD0, .eguwzH_QWTBXry7hiNj3):has([for="desktop.settings.downloadQuality"]) {display: none}'
hideSubfeed=' .cj6vRk3nFAi80HSVqX91, .c8Z2jJUocJTdV9g741cp {display:none}'
hideVeryHigh=' #desktop\.settings\.streamingQuality>option:nth-child(5) {display:none}'
lyricsBackgroundNew=' .FUYNhisXTCmbzt9IDxnT,\n .tr8V5eHsUaIkOYVw7eSG,\n .hW9km7ku6_iggdWDR_Lg,\n .lofIAg8Ixko3mfBrbfej,\n .Li269NgzkU2gI4KOP9sM,\n .I2WIloMMjsBeMaIS8H3v,\n .McI3hD7aCfpq015LJa6X,\n .gpDSOimnzH4zTJmE7UR5 {\n \t--lyrics-color-active: #C8C8C8 !important;\n \t--lyrics-color-inactive: #575757 !important;\n \t--lyrics-color-passed: #575757 !important;\n \t--lyrics-color-background: #121212 !important;\n }'
updatesEx=(
'blockUpdates&\x64(?=\x65\x73\x6B\x74\x6F\x70\x2D\x75\x70)&\x00&g&appBinary&1.1.70.610&9.9.9.9&macOS'
)
freeEx=(
'adsB&/a\Kd(?=s/v1)|/a\Kd(?=s/v2/t)|/a\Kd(?=s/v2/se)&b&gs&appBinary&1.1.59.710&1.2.64.408'
'adsX&/a\Kd(?=s/v1)|/a\Kd(?=s/v2/t)|/a\Kd(?=s/v2/se)&b&gs&xpuiJs&1.1.59.710&1.2.60.564'
'adsX2&}/a\Kd(?=s)&b&gs&xpuiJs&1.2.55.235'
'adsBillboard&.(?=\?\[.{1,6}[a-zA-Z].leaderboard,)&false&&xpuiJs&1.1.59.710&1.2.6.863'
'adConfig&/\Kv2/config&config&gs&xpuiJs&1.2.55.235'
'adsCosmos&(case .:|async enable\(.\)\{)(this.enabled=.+?\(.{1,3},"audio"\),|return this.enabled=...+?\(.{1,3},"audio"\))((;case 4:)?this.subscription=this.audioApi).+?this.onAdMessage\)&$1$3.cosmosConnector.increaseStreamTime(-100000000000)&&xpuiJs&1.1.59.710&1.1.92.647'
'adsEmptyBlock&adsEnabled:!\K0&1&&xpuiJs'
'connectOld1& connect-device-list-item--disabled&&&xpuiJs&1.1.70.610&1.1.90.859'
'connectOld2&connect-picker.unavailable-to-control&spotify-connect&&xpuiJs&1.1.70.610&1.1.90.859'
'connectOld3&("button",\{className:.,disabled:)(..)&$1false&&xpuiJs&1.1.70.610&1.1.90.859'
'connectNew&return (..isDisabled)(\?(..createElement|\(.{1,10}\))\(..,)&return false$2&&xpuiJs&1.1.91.824&1.1.92.647'
'enableImprovedDevicePickerUI1&Enable showing a new and improved device picker UI",default:\K!.(?=})&true&&xpuiJs&1.1.91.824&1.1.92.647'
'esperantoProductState&(this\.(?:productStateApi|_product_state)(?:|_service)=(.))(?=}|(?:,.{1,30})?,this\.productStateApi|,this\._events)&$1,$2.putOverridesValues({pairs:{ads:'\''0'\'',catalogue:'\''premium'\'',type:'\''premium'\'',name:'\''Spotify'\''}})&&xpuiJs'
'hideDlQual&(\(.,..jsxs\)\(.{1,3}|(.\(\).|..)createElement\(.{1,4}),\{(filterMatchQuery|filter:.,title|(variant:"viola",semanticColor:"textSubdued"|..:"span",variant:.{3,6}mesto,color:.{3,6}),htmlFor:"desktop.settings.downloadQuality.+?).{1,6}get\("desktop.settings.downloadQuality.title.+?(children:.{1,2}\(.,.\).+?,|\(.,.\){3,4},|,.\)}},.\(.,.\)\),)&&&xpuiJs&1.1.59.710&1.2.29.605'
'hideUpgradeButton&(return|.=.=>)"free"===(.+?)(return|.=.=>)"premium"===&$1"premium"===$2$3"free"===&g&xpuiJs&1.1.59.710&1.1.92.647'
'hideUpgradeButton2&"free"===&"premium"===&g&xpuiJs&1.2.55.235'
'hptoEnabled&hptoEnabled:!\K0&1&s&xpuiJs'
'hptoShown&isHptoShown:!\K0&1&gs&homeHptoJs&1.1.85.884&1.2.20.1218'
'hptoShown2&(ADS_PREMIUM,isPremium:)\w(.*?ADS_HPTO_HIDDEN,isHptoHidden:)\w&$1true$2true&&xpuiJs&1.2.21.1104'
'payloadS&\x3F\x70\x61\x79\x6C\x6F\x61\x64&\x00\x00\x00\x00\x00\x00\x00\x00&gs&appBinary&1.2.53.437'
'stateS1&\x69\x6E\x69\x74\x69\x61\x6C\x5F(?=\x48)&\x00\x00\x00\x00\x00\x00\x00\x00&s&appBinary&1.2.53.437&1.2.55.235&macOS'
'stateS2&\x69\x6E\x69\x74\x69\x61\x6C\x5F(?=\x48)&\x00\x00\x00\x00\x00\x00\x00\x00&s&appBinary&1.2.53.437&&Linux'
'stateS3&[\x00\x0A\x1A]\K\x69\x6E\x69\x74\x69\x61\x6C\x5F(?=\x73\x74\x61\x74\x65\x00)&\x00\x00\x00\x00\x00\x00\x00\x00&s&appBinary&1.2.55.235&&macOS'
)
devEx=(
'dev1&[\x00\xFF][\x00\xFF]\x48\xB8\x65\x76\x65.{5}\x48.{36,50}\K\xE8.{4}&\xB8\x03\x00\x00\x00&s&appBinary&1.1.84.716'
'dev2&\xF8\xFF[\x37\x77\xB7\xF7][\x06-\x0F\x10-\x19]\x39\xFF.[\x00-\x04]\xB9\xE1[\x03\x43\x83\xC3][\x06-\x0F\x10-\x19]\x91\xE2.[\x02-\x0F\x13]\x91.{0,4}\K...[\x94\x97](?=[\xF5\xF7\xF8]\x03)&\x60\x00\x80\xD2&s&appBinary&1.1.84.716&&macOS'
'devDebug&(return ).{1,3}(\?(?:.{1,4}createElement|\(.{1,7}.jsxs\)))(\(.{3,7}\{displayText:"Debug Tools"(?:,children.{3,8}jsx\)|},.\.createElement))(\(.{4,6}role.*?Debug Window".*?\))(.*?Locales.{3,8})(:null)&$1true$2$4$6&&xpuiJs&1.1.92.644&1.2.59.518'
'enableDebugTools&debug tools and features for employees",default:\K!1&true&s&xpuiJs&1.2.60.564'
)
oldUiEx=(
'disableYLXSidebar&Enable Your Library X view of the left sidebar",default:\K!.(?=})&false&s&xpuiJs&1.1.93.896&1.2.13.661'
'disableRightSidebar&Enable the view on the right sidebar",default:\K!.(?=})&false&s&xpuiJs&1.1.93.896&1.2.13.661'
)
newUiEx=(
'enableNavAltExperiment&Enable the new home structure and navigation",values:.,default:\K..DISABLED&true&&xpuiJs&1.1.94.864&1.1.96.785'
'enableNavAltExperiment2&Enable the new home structure and navigation",values:.,default:.\K.DISABLED&.ENABLED_CENTER&&xpuiJs&1.1.97.956&1.2.2.582'
'enablePanelSizeCoordination&Enable Panel Size Coordination between the left sidebar, the main view and the right sidebar",default:\K!.(?=})&true&s&xpuiJs&1.2.7.1264&1.2.50.335'
'enableRightSidebar&Enable the view on the right sidebar",default:\K!1&true&s&xpuiJs&1.1.98.683&1.2.23.1125'
'enableRightSidebarLyrics&Show lyrics in the right sidebar",default:\K!1&true&s&xpuiJs&1.2.0.1165'
'enableYLXSidebar&Enable Your Library X view of the left sidebar",default:\K!1&true&s&xpuiJs&1.1.97.962&1.2.13.661'
)
podEx=(
'hidePodcasts&withQueryParameters\(.\)\{return this.queryParameters=.,this}&withQueryParameters(e){return this.queryParameters=(e.types?{...e, types: e.types.split(",").filter(_ => !["episode","show"].includes(_)).join(",")}:e),this}&&xpuiJs&1.1.70.610&1.1.85.895'
'hidePodcasts2&(case 6:|const .=await .\([^\)]*\);)((return .\.abrupt\(\"|return[ \"],?)(null!=n\x26\x26|return\",)?(.)(\);case 9|\??.errors\?.*?Promise.reject.+?errors\)+:.))&$1$5?.data?.home?.sectionContainer?.sections?.items?.forEach(x => x?.sectionItems?.items \x26\x26 (x.sectionItems.items = x.sectionItems.items.filter(i => !['\''Podcast'\'','\''Audiobook'\'','\''Episode'\''].includes(i?.content?.data?.__typename))));$2&&xpuiJs&1.1.86.857'
)
lyricsBgEx=(
'lyricsBackground1&--lyrics-color-inactive":\K(.).inactive&$1.background&&xpuiJs&1.2.0.1165&1.2.44.405'
'lyricsBackground2&--lyrics-color-background":\K(.).background&$1.inactive&&xpuiJs&1.2.0.1165&1.2.44.405'
'lyricsBackground3&--lyrics-color-inactive":\K(.\.colors).text&$1.background&&xpuiJs&1.2.0.1165&1.2.44.405'
'lyricsBackground4&--lyrics-color-background":\K(.\.colors).background&$1.text&&xpuiJs&1.2.0.1165&1.2.44.405'
)
aoEx=(
'aboutSpotX&((..createElement|children:\(.{1,7}\))\(.{1,7},\{source:).{1,7}get\("about.copyright",.\),paragraphClassName:.(?=\}\))&$1"<h3>About SpotX / SpotX-Bash</h3><br><details><summary><svg xmlns='\''http://www.w3.org/2000/svg'\'' width='\''20'\'' height='\''20'\'' viewBox='\''0 0 24 24'\''><path d='\''M12 0c-6.626 0-12 5.373-12 12 0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23.957-.266 1.983-.399 3.003-.404 1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576 4.765-1.589 8.199-6.086 8.199-11.386 0-6.627-5.373-12-12-12z'\'' fill='\''#fff'\''/></svg> Github</summary><a href='\''https://github.com/SpotX-Official/SpotX'\''>SpotX \(Windows\)</a><br><a href='\''https://github.com/SpotX-Official/SpotX-Bash'\''>SpotX-Bash \(Linux/macOS\)</a><br><br/></details><details><summary><svg xmlns='\''http://www.w3.org/2000/svg'\'' width='\''20'\'' height='\''20'\'' viewBox='\''0 0 24 24'\''><path id='\''telegram-1'\'' d='\''M18.384,22.779c0.322,0.228 0.737,0.285 1.107,0.145c0.37,-0.141 0.642,-0.457 0.724,-0.84c0.869,-4.084 2.977,-14.421 3.768,-18.136c0.06,-0.28 -0.04,-0.571 -0.26,-0.758c-0.22,-0.187 -0.525,-0.241 -0.797,-0.14c-4.193,1.552 -17.106,6.397 -22.384,8.35c-0.335,0.124 -0.553,0.446 -0.542,0.799c0.012,0.354 0.25,0.661 0.593,0.764c2.367,0.708 5.474,1.693 5.474,1.693c0,0 1.452,4.385 2.209,6.615c0.095,0.28 0.314,0.5 0.603,0.576c0.288,0.075 0.596,-0.004 0.811,-0.207c1.216,-1.148 3.096,-2.923 3.096,-2.923c0,0 3.572,2.619 5.598,4.062Zm-11.01,-8.677l1.679,5.538l0.373,-3.507c0,0 6.487,-5.851 10.185,-9.186c0.108,-0.098 0.123,-0.262 0.033,-0.377c-0.089,-0.115 -0.253,-0.142 -0.376,-0.064c-4.286,2.737 -11.894,7.596 -11.894,7.596Z'\'' fill='\''#fff'\''/></svg> Telegram</summary><a href='\''https://t.me/spotify_windows_mod'\''>SpotX Channel</a><br><a href='\''https://t.me/SpotxCommunity'\''>SpotX Community</a><br><br/></details><details><summary><svg xmlns='\''http://www.w3.org/2000/svg'\'' width='\''20'\'' height='\''20'\'' viewBox='\''0 0 24 24'\''><path d='\''M12 2c5.514 0 10 4.486 10 10s-4.486 10-10 10-10-4.486-10-10 4.486-10 10-10zm0-2c-6.627 0-12 5.373-12 12s5.373 12 12 12 12-5.373 12-12-5.373-12-12-12zm1.25 17c0 .69-.559 1.25-1.25 1.25-.689 0-1.25-.56-1.25-1.25s.561-1.25 1.25-1.25c.691 0 1.25.56 1.25 1.25zm1.393-9.998c-.608-.616-1.515-.955-2.551-.955-2.18 0-3.59 1.55-3.59 3.95h2.011c0-1.486.829-2.013 1.538-2.013.634 0 1.307.421 1.364 1.226.062.847-.39 1.277-.962 1.821-1.412 1.343-1.438 1.993-1.432 3.468h2.005c-.013-.664.03-1.203.935-2.178.677-.73 1.519-1.638 1.536-3.022.011-.924-.284-1.719-.854-2.297z'\'' fill='\''#fff'\''/></svg> FAQ</summary><a href='\''https://te.legra.ph/SpotX-FAQ-09-19'\''>Windows</a><br><a href='\''https://github.com/SpotX-Official/SpotX-Bash/wiki/SpotX%E2%80%90Bash-FAQ'\''>Linux/macOS</a></details><br><h4>DISCLAIMER</h4>SpotX is a modified version of the official Spotify\x26reg; client, provided \x26quot;as is\x26quot; for the purpose of evaluation at user'\''s own risk. Source code for SpotX is available separately and free of charge under open source software license agreements. SpotX is not affiliated with Spotify\x26reg;, Spotify AB or Spotify Group.<br><br>Spotify\x26reg; is a registered trademark of Spotify Group."&&xpuiDesktopModalsJs&1.1.79.763'
'allowSwitchingBetweenHomeAdsAndHpto&opposed to only showing the legacy HPTO format.",default:\K!.(?=})&false&s&xpuiJs&1.2.34.783'
'betamaxFilterNegativeDuration&for duration that is negative",default:\K!.(?=})&false&s&xpuiJs'
'bGabo&\x00\K\x67(?=\x61\x62\x6F\x2D\x72\x65\x63\x65\x69\x76\x65\x72\x2D\x73\x65\x72\x76\x69\x63\x65\x2F\x70)&\x00&g&appBinary&1.1.84.716'
'bLogic&\x00\K\x61(?=\x64\x2D\x6C\x6F\x67\x69\x63\x2F\x73)&\x00&&appBinary&1.1.70.610&1.2.28.581'
'bSlot&\x00\K\x73(?=\x6C\x6F\x74\x73\x00)&\x00&g&appBinary&1.1.70.610'
'disablePremiumOnlyModal&Disable the Premium Only Modal",default:\K!.(?=})&true&s&xpuiJs&1.2.39.578'
'embeddedAdImpressionDoesNotIgnoreVisilibility&If enabled, we do consider percent visibility when logging the display ad impression.{0,49}",default:\K!.(?=})&false&s&xpuiJs&1.2.78.397'
'enableAgeAssuranceComments&Enables the age assurance gating for comments feature",default:\K!.(?=})&false&s&xpuiJs&1.2.78.397'
'enableAgeAssuranceFriendActivity&Enables the age assurance gating for friend activity feed",default:\K!.(?=})&false&s&xpuiJs&1.2.78.397'
'enableAgeAssuranceProfileMenu&Enables the age assurance entry point in the profile menu .{0,43}",default:\K!.(?=})&false&s&xpuiJs&1.2.78.397'
'enableAgeAssuranceSettings&Enables the age assurance section in account settings",default:\K!.(?=})&false&s&xpuiJs&1.2.78.397'
'enableCanvasAds&Enable Canvas for ads",default:\K!.(?=})&false&s&xpuiJs&1.2.52.442'
'enableConnectedStateObserver&observer that logs errors related to connected state and ad info",default:\K!.(?=})&false&s&xpuiJs&1.2.53.437'
'enableCulturalMoments&Cultural Moment pagess",default:\K!.(?=})&false&s&xpuiJs&1.2.7.1264&1.2.50.335'
'enableDesktopMusicLeavebehinds&Enable music leavebehinds on eligible playlists for desktop",default:\K!.(?=})&false&s&xpuiJs&1.2.10.751'
'enableDsaAds&Enable showing DSA .Digital Services Act. context menu and modal for ads",default:\K!.(?=})&false&s&xpuiJs&1.2.20.1210&1.2.52.442'
'enableDSASetting&Enable DSA .Digital Service Act. features for desktop and web",default:\K!.(?=})&false&s&xpuiJs&1.2.20.1210'
'enableEnhancedAdsClientDeconfliction&Enable refactored version of ads orchestrator middleware",default:\K!.(?=})&false&s&xpuiJs&1.2.57.460&1.2.61.443'
'enableEmbeddedAdsCarousel&embedded ads carousel for the NPV",default:\K!.(?=})&false&s&xpuiJs&1.2.73.451'
'enableEmbeddedAdsFetchingOverCanvas&embedded ads fetching when canvas track is playing. Defaults to true since this is currently existing behavior",default:\K!.(?=})&false&s&xpuiJs&1.2.72.435&1.2.77.358'
'enableEmbeddedAdVisibilityLogging&When enabled, enhanced visibility logs will be sent for embedded ads",default:\K!.(?=})&false&s&xpuiJs&1.2.64.407&1.2.77.358'
'enableEmbeddedNpvAds&Enable embedded display ads on NPV",default:\K!.(?=})&false&s&xpuiJs&1.2.57.460&1.2.77.358'
'enableEsperantoMigration&Enable esperanto Migration for (HPTO\s)?Ad Formats?",default:\K!.(?=})&false&s&xpuiJs&1.2.6.861&1.2.50.335'
'enableEsperantoMigrationLeaderboard&Enable esperanto Migration for Leaderboard Ad Format",default:\K!.(?=})&false&s&xpuiJs&1.2.32.985'
'enableFraudLoadSignals&Enable user fraud signals emitted on page load",default:\K!.(?=})&false&s&xpuiJs&1.2.22.975&1.2.62.580'
'enableHomeAds&Enable Fist Impression Takeover ads on Home Page",default:\K!.(?=})&false&s&xpuiJs&1.2.31.1205'
'enableHomeAdStaticBanner&Enables temporary home banner, static version",default:\K!.(?=})&false&s&xpuiJs&1.2.25.1009&1.2.53.440'
'enableHpto&Hpto announcements on Home",default:\K!.(?=})&false&s&xpuiJs&1.2.65.255'
'enableHptoLocationRefactor&Enable new permanent location for HPTO iframe to HptoHtml.js",default:\K!.(?=})&false&s&xpuiJs&1.2.1.958&1.2.20.1218'
'enableInAppMessaging&Enables quicksilver in-app messaging modal",default:\K!.(?=})&false&s&xpuiJs&1.1.70.610'
'enableInteractionLogger&Enables the old interaction logger",default:\K!.(?=})&false&s&xpuiJs&1.2.41.434&1.2.64.408'
'enableLeavebehindsMockData&Use the mock endpoint to fetch Leavebehinds from AP4P",default:\K!.(?=})&false&s&xpuiJs&1.2.30.1135'
'enableNewAdsNpv&Enable showing new ads NPV",default:\K!.(?=})&false&s&xpuiJs&1.2.18.997&1.2.50.335'
'enableNewAdsNpvCanvasAds&Enable Canvas ads for new ads NPV",default:\K!.(?=})&false&s&xpuiJs&1.2.28.581&1.2.51.345'
'enableNewAdsNpvColorExtraction&Enable CTA card color extraction for new ads NPV",default:\K!.(?=})&false&s&xpuiJs&1.2.18.997&1.2.50.335'
'enableNewAdsNpvNewVideoTakeoverSlot&position redesigned new ads NPV VideoTakeover above all areas except RightSidebar and NPB ",default:\K!.(?=})&false&s&xpuiJs&1.2.22.975&1.2.50.335'
'enableNewAdsNpvVideoTakeover&Enable redesigned VideoTakeover for new ads NPV",default:\K!.(?=})&false&s&xpuiJs&1.2.18.997&1.2.50.335'
'enableNonUserTriggeredPopovers&Enables programmatically triggered popovers",default:\K!.(?=})&false&s&xpuiJs&1.2.23.1114'
'enablePickAndShuffle&pick and shuffle",default:\K!.(?=})&false&s&xpuiJs&1.1.85.884&1.2.42.290'
'enablePipImpressionLogging&Enables impression logging for PiP",default:\K!.(?=})&false&s&xpuiJs&1.2.32.985&1.2.78.418'
'enablePodcastSponsoredContent&Enable sponsored content information for podcasts",default:\K!.(?=})&false&s&xpuiJs&1.2.30.1135&1.2.50.335'
'enablePromotions&Enables promotions on home",default:\K!.(?=})&false&s&xpuiJs&1.2.38.720&1.2.45.454'
'enableSaxLeaderboardAds&Enable SAX Leaderboard Ad Format",default:\K!.(?=})&false&s&xpuiJs&1.2.62.575'
'enableShowLeavebehindConsolidation&Enable show leavebehinds consolidated experience",default:\K!.(?=})&false&s&xpuiJs&1.2.23.1114'
'enableSponsoredPlaylistEsperantoMigration&Enable esperanto Migration for Sponsored Playlist Ad Formats",default:\K!.(?=})&false&s&xpuiJs&1.2.32.985&1.2.50.335'
'enableSurveyAds&Enable Spotify Brand Lift .SBL. Surveys in the NPV",default:\K!.(?=})&false&s&xpuiJs&1.2.43.420&1.2.63.394'
'enableUnderAgeBlockingModal&Enables the underage blocking modal for accounts in blocked/pending disabled state",default:\K!.(?=})&false&s&xpuiJs&1.2.78.397'
'enableUserFraudCanvas&Enable user fraud Canvas Fingerprinting",default:\K!.(?=})&false&s&xpuiJs&1.2.13.656&1.2.63.394'
'enableUserFraudCspViolation&Enable CSP violation detection",default:\K!.(?=})&false&s&xpuiJs&1.2.17.832&1.2.62.580'
'enableUserFraudSignals&Enable user fraud signals",default:\K!.(?=})&false&s&xpuiJs&1.2.10.751&1.2.62.580'
'enableUserFraudVerification&Enable user fraud verification",default:\K!.(?=})&false&s&xpuiJs&1.2.3.1107&1.2.62.580'
'enableUserFraudVerificationRequest&Enable the IAV component make api requests",default:\K!.(?=})&false&s&xpuiJs&1.2.5.954&1.2.62.580'
'enableYourListeningUpsell&Enable Your Listening Upsell Banner for free . unauth users",default:\K!.(?=})&false&s&xpuiJs&1.2.25.1009&1.2.63.394'
'hideUpgradeCTA&Hide the Upgrade CTA button on the Top Bar",default:\K!.(?=})&true&s&xpuiJs&1.2.26.1180'
'logSentry&(this\.getStackTop\(\)\.client=.)&return;$1&&vendorXpuiJs&1.1.70.610&1.2.29.605'
'logSentry2&sentry\.io&localhost.io&&xpuiJs&1.1.70.610'
'lUnsupported&((?:\(?await )?.\.build.{20,60}encodeURIComponent.{20,140}"\/track\/\{trackId\}.+?)(.send)&$1.withHeaders([{key:"spotify-app-version",value:"1.2.45.454"}])$2&s&xpuiJs&1.1.70.610&1.2.45.451'
'logV3&sp://logging/v3/\w+&&g&xpuiJs&1.1.70.610'
're1&\xE8...[\xFE\xFF]\x4D\x8B.{1,2}\x4D\x85.\x75[\xA0-\xAF]\x48\x8D.{9,10}\K\xE8...[\xFE\xFF](?=[\x40-\x4F][\x80-\x8F])&\x0F\x1F\x44\x00\x00&gs&appBinary&1.2.29.605&&Linux&&2'
're2&\x24\x24\x4D\x85\xE4\x75\xA9\x48\x8D\x35...\x01\x48\x8D\xBD.[\xFE\xFF]\xFF\xFF\K\xE8....&\x0F\x1F\x44\x00\x00&gs&appBinary&1.2.29.605&&macOS&&2'
're3&[\x10-\x1F]\x01\x00\x39.{0,4}\xE0\x03[\x10-\x1F]\xAA...[\x90-\x9F].[\x02\x03]\x40\xF9[\x70-\x7F]\xFD\xFF\xB5..\x00.\x21..\x91\xE0.[\x00-\x0F]\x91\K....(?=[\xF0-\xFF][\x00-\x0F]....\x00)&\x1F\x20\x03\xD5&gs&appBinary&1.2.29.605&&macOS&&2'
'searchFix1&(typeName])&$1 || []&s&xpuiJs&1.2.28.581&1.2.57.463'
'slotMid&\x70\x6F\x64\x63\x61\x73\x74\K\x2D\x6D\x69&\x20\x6D\x69&g&appBinary&1.0.29.605&1.0.29.605&macOS'
'slotPost&\x70\x6F\x64\x63\x61\x73\x74\K\x2D\x70\x6F&\x20\x70\x6F&g&appBinary&1.0.29.605&1.0.29.605&macOS'
'slotPre&\x2D(?=\x70\x72\x65\x72\x6F\x6C\x6C)&\x20&g&appBinary&1.0.29.605&1.0.29.605&macOS'
'sponsors1&ht.{14}\...\..{7}\....\/.{8}ap4p\/&&g&xpuiJs&1.1.70.610&1.2.52.442'
'sponsors2&ht.{14}\...\..{7}\....\/s.{15}t\/v.\/&&g&xpuiJs&1.1.70.610&1.2.60.564'
'sponsors3&allSponsorships&&g&xpuiJs&1.1.59.710'
'sponsors4&\/\K.{7}-ap4p&&g&xpuiJs&1.2.53.437'
'ucsC&\x00\K\x68(?=.{30}\x2F\x75\x73\x65\x72\x2D)&\x00&s&appBinary&1.2.55.235'
'webgateGabo&\@webgate\/(gabo)&"@" . $1&ge&vendorXpuiJs&1.1.70.610'
'webgateRemote&\@webgate\/(remote)&"@" . $1&ge&vendorXpuiJs&1.1.70.610'
)
expEx=(
'enableAddPlaylistToPlaylist&support for adding a playlist to another playlist",default:\K!1&true&s&xpuiJs&1.1.98.683&1.2.3.1115'
'enableAiDubbedEpisodesInNpv&showing AI dubbed episodes in NPV",default:\K!.(?=})&true&s&xpuiJs&1.2.28.581&1.2.50.335'
'enableAlbumCoverArtModal&cover art modal on the Album page",default:\K!.(?=})&true&s&xpuiJs&1.2.13.656&1.2.50.335'
'enableAlbumPrerelease&album prerelease pages",default:\K!.(?=})&true&s&xpuiJs&1.2.18.997&1.2.50.335'
'enableAlbumReleaseAnniversaries&balloons on album release date anniversaries",default:\K!1&true&s&xpuiJs&1.1.89.854'
'enableAlignedCuration&Aligned Curation",default:\K!.(?=})&false&s&xpuiJs&1.2.21.1104&1.2.50.335'
'enableAlignedPanelHeaders&aligned panel headers",default:\K!1&true&s&xpuiJs&1.2.57.460&1.2.62.580'
'enableAnonymousVideoPlayback&anonymous users to play video podcasts",default:\K!1&true&s&xpuiJs&1.2.29.605&1.2.78.418'
'enableArtistBans&feature to ban/unban artists and have the UI reflect it",default:\K!.(?=})&true&s&xpuiJs&1.2.43.420&1.2.50.335'
'enableArtistLikedSongs&Liked Songs section on Artist page",default:\K!1&true&s&xpuiJs&1.1.59.710&1.2.17.834'
'enableAttackOnTitanEasterEgg&Titan Easter egg turning progress bar red when playing official soundtrack",default:\K!.(?=})&true&s&xpuiJs&1.2.6.861&1.2.50.335'
'enableAudiobookPrerelease&audiobook prerelease pages",default:\K!1&true&s&xpuiJs&1.2.33.1039&1.2.47.366'
'enableAudiobooks&Audiobooks feature on ClientX",default:\K!1&true&s&xpuiJs&1.1.74.631&1.2.46.462'
'enableAutoSeekToVideoBufferedStartPosition&avoid initial seek if the initial position is not buffered",default:\K!1&true&s&xpuiJs&1.2.31.1205'
'enableBackendSearchHistory&Enable backend search history",default:\K!1&true&s&xpuiJs&1.2.60.564'
'enableBanArtistAction&context menu action to ban/unban artists",default:\K!1&true&s&xpuiJs&1.2.28.581&1.2.42.290'
'enableBetamaxSdkSubtitlesDesktopX&rendering subtitles on the betamax SDK on DesktopX",default:\K!.(?=})&true&s&xpuiJs&1.1.70.610'
'enableBillboardEsperantoMigration&esperanto migration for Billboard Ad Format",default:\K!.(?=})&true&s&xpuiJs&1.2.32.985&1.2.52.442'
'enableBLEJamBroadcasting&Jam Broadcasting for Bluetooth",default:\K!1&true&s&xpuiJs&1.2.76.256'
'enableBlockUsers&block users feature in clientX",default:\K!.(?=})&true&s&xpuiJs&1.1.70.610&1.2.50.335'
'enableBrowseViaPathfinder&Fetch Browse data from Pathfinder",default:\K!1&true&s&xpuiJs&1.1.88.595&1.2.24.756'
'enableCanvasNpv&short, looping visuals on tracks.",default:..\.\KCONTROL&CANVAS_PLAY_LOOP&s&xpuiJs&1.2.33.1039&1.2.62.580'
'enableCarouselsOnHome&Use carousels on Home",default:\K!1&true&s&xpuiJs&1.1.93.896&1.2.25.1011'
'enableCenteredLayout&Enable centered layout",default:\K!.(?=})&true&s&xpuiJs&1.2.39.578&1.2.50.335'
'enableClearAllDownloads&option in settings to clear all downloads",default:\K!1&true&s&xpuiJs&1.1.92.644&1.1.98.691'
'enableCommentThreadsReactionsForEpisodes&users to react and reply to comments.",default:\K!1&true&s&xpuiJs&1.2.71.421'
'enableConcertCampaignPage&concert campaign page",default:\K!1&true&s&xpuiJs&1.2.78.397'
'enableConcertEntityPathfinderDWP&Use pathfinder for the concert entity page on DWP",default:\K!1&true&s&xpuiJs&1.2.25.1009&1.2.33.1039'
'enableConcertGenres&concert genres on the live events feed",default:\K!1&true&s&xpuiJs&1.2.46.462&1.2.58.498'
'enableConcertsCarouselForThisIsPlaylist&Concerts Carousel on This is Playlist",default:\K!1&true&s&xpuiJs&1.2.26.1180&1.2.63.394'
'enableConcertsForThisIsPlaylist&Tour Card on This is Playlist",default:\K!1&true&s&xpuiJs&1.2.11.911&1.2.62.580'
'enableConcertsInSearch&concerts in search",default:\K!1&true&s&xpuiJs&1.2.33.1039&1.2.78.418'
'enableConcertsInterested&Save . Retrieve feature for concerts",default:\K!1&true&s&xpuiJs&1.2.7.1264&1.2.62.580'
'enableConcertsNearYou&Concerts Near You Playlist",default:\K!1&true&s&xpuiJs&1.2.11.911'
'enableConcertsNearYouFeedPromoDWP&Show the promo card for Concerts Near You playlist on Concert Feed",default:\K!1&true&s&xpuiJs&1.2.23.1114&1.2.57.463'
'enableConcertsNotInterested&ser to set not interested on concerts",default:\K!1&true&s&xpuiJs&1.2.53.437'
'enableConcertsTicketPrice&Display ticket price on Event page",default:\K!1&true&s&xpuiJs&1.2.15.826&1.2.62.580'
'enableContextMenuShortcuts&inline keyboard shortcuts for common context menu items",default:\K!1&true&s&xpuiJs&1.2.69.448'
'enableContextualTrackBans&ability to ban.hide tracks from eligible contexts",default:\K!1&true&s&xpuiJs&1.2.52.442'
'enableCreateButton&create button either in the global navbar or in YLX",values:.{1,3},default:.{1,3}.\KNONE&YOUR_LIBRARY&s&xpuiJs&1.2.57.460'
'enableDiscographyShelf&condensed disography shelf on artist pages",default:\K!.(?=})&true&s&xpuiJs&1.1.79.763&1.2.50.335'
'enableDynamicNormalizer&dynamic normalizer.compressor",default:\K!1&true&s&xpuiJs&1.2.14.1141&1.2.60.564'
'enableEightShortcuts&Increase max number of shortcuts on home to 8",default:\K!1&true&s&xpuiJs&1.2.26.1180&1.2.45.454'
'enableEncoreCards&all cards throughout app to be Encore Cards",default:\K!1&true&s&xpuiJs&1.2.21.1104&1.2.33.1042'
'enableEncorePlaybackButtons&Use Encore components in playback control components",default:\K!1&true&s&xpuiJs&1.2.20.1210&1.2.43.420'
'enableEqualizer&audio equalizer for Desktop and Web Player",default:\K!1&true&s&xpuiJs&1.1.88.595'
'enableExcludeTrackFromTasteProfile&option to exclude track from taste profile via context menu",default:\K!1&true&s&xpuiJs&1.2.73.451'
'enableExtraTracklistColumns&extra tracklist columns",default:\K!1&true&s&xpuiJs&1.2.44.405&1.2.71.421'
'enableFC24EasterEgg&EA FC 24 easter egg",default:\K!1&true&s&xpuiJs&1.2.20.1210&1.2.53.440'
'enableForgetDevice&option to Forget Devices",default:\K!1&true&s&xpuiJs&1.2.0.1155&1.2.5.1006'
'enableFullscreenMode&Enable fullscreen mode",default:\K!1&true&s&xpuiJs&1.2.31.1205'
'enableGlobalCreateButton&plus button for creating different types of playlists from global nav bar",default:\K!1&true&s&xpuiJs&1.2.53.437&1.2.56.502'
'enableGlobalNavBar&Show global nav bar with home button, search input and user avatar",default:..\.\KCONTROL&HOME_NEXT_TO_SEARCH&s&xpuiJs&1.2.30.1135&1.2.45.454'
'enableHomeCarousels&carousels on home",default:\K!1&true&s&xpuiJs&1.2.44.405&1.2.62.580'
'enableHomePin&pinning of home shelves",default:\K!1&true&s&xpuiJs&1.2.45.451'
'enableIgnoreInRecommendations&Ignore In Recommendations for desktop and web",default:\K!.(?=})&true&s&xpuiJs&1.1.87.612&1.2.50.335'
'enableInlineCuration&new inline playlist curation tools",default:\K!1&true&s&xpuiJs&1.1.70.610&1.2.25.1011'
'enableLikedSongsAsPlaylist&Liked Songs on list platform with playlist uri",default:\K!1&true&s&xpuiJs&1.2.75.499'
'enableLikedSongsFilterTags&Show filter tags on the Liked Songs entity view",default:\K!1&true&s&xpuiJs&1.2.32.985'
#'enableLikedSongsListPlatform&Liked Songs on list platform",default:\K!1&true&s&xpuiJs&1.2.41.434'
'enableListPrivateByDefaultSetting&List Private By Default setting in Desktop Social Settings",default:\K!1&true&s&xpuiJs&1.2.78.397'
'enableLiveEventsListView&list view for Live Events feed",default:\K!1&true&s&xpuiJs&1.2.14.1141&1.2.18.999'
'enableLocalConcertsInSearch&local concert recommendations in search",default:\K!1&true&s&xpuiJs&1.2.36.955&1.2.78.418'
'enableLyricsCheck&clients will check whether tracks have lyrics available",default:\K!1&true&s&xpuiJs&1.1.70.610&1.1.93.896'
'enableLyricsMatch&Lyrics match labels in search results",default:\K!.(?=})&true&s&xpuiJs&1.1.87.612&1.2.50.335'
'enableLyricsNew&new fullscreen lyrics page",default:\K!1&true&s&xpuiJs&1.1.84.716&1.1.86.857'
'enableLyricsScrollToCurrentLineButton&scroll to current line button in lyrics",default:\K!1&true&s&xpuiJs&1.2.65.255&1.2.77.144'
'enableMadeForYouEntryPoint&Show "Made For You" entry point in the left sidebar.,default:\K!1&true&s&xpuiJs&1.1.70.610&1.1.95.893'
'enableMarkBookAsFinished&ability to mark a book as finished",default:\K!1&true&s&xpuiJs&1.2.44.405'
'enableMerchHubWrappedTakeover&Route merchhub url to the new genre page for the wrapped takeover",default:\K!1&true&s&xpuiJs&1.2.22.975&1.2.39.578'
'enableMoreLikeThisPlaylist&More Like This playlist for playlists the user cannot edit",default:\K!1&true&s&xpuiJs&1.2.32.985&1.2.73.474'
'enableNearbyJams&support for Nearby Jams feature in the Device Picker",default:\K!1&true&s&xpuiJs&1.2.52.442'
'enableNewArtistEventsPage&Display the new Artist events page",default:\K!1&true&s&xpuiJs&1.2.18.997&1.2.32.997'
'enableNewConcertFeed&Enables new concert feed experience",default:\K!1&true&s&xpuiJs&1.2.37.701&1.2.42.290&1.2.50.335'
'enableNewConcertLocationExperience&new concert location experience modal selector.",default:\K!1&true&s&xpuiJs&1.2.34.783&1.2.42.290'
'enableNewEntityHeaders&New Entity Headers",default:\K!1&true&s&xpuiJs&1.2.15.826&1.2.28.0'
'enableNewEpisodes&new episodes view",default:\K!1&true&s&xpuiJs&1.1.84.716&1.2.62.580'
#'enableNewOverlayScrollbars&new overlay scrollbars",default:\K!1&true&s&xpuiJs&1.2.58.492'
'enableNewPodcastTranscripts&showing podcast transcripts on desktop and web player",default:\K!1&true&s&xpuiJs&1.1.84.716&1.2.25.1011'
'enableNewRecentsPage&the new Recents page",default:\K!1&true&s&xpuiJs&1.2.76.256'
'enableNextBestEpisode&next best episode block on the show page",default:\K!1&true&s&xpuiJs&1.1.99.871&1.2.28.581'
'enableNotificationCenter&notification center for desktop . web",default:\K!1&true&s&xpuiJs&1.2.75.499'
'enableNowPlayingBarVideo&showing video in Now Playing Bar when all other video elements are closed",default:\K!1&true&s&xpuiJs&1.2.22.975'
'enableNowPlayingBarVideoSwitch&a switch to toggle video in the Now Playing Bar",default:\K!1&true&s&xpuiJs&1.2.28.581&1.2.29.605'
'enableNPVCredits enableNPVCreditsWithLinkability&credits in the right sidebar",default:\K!.(?=})&true&gs&xpuiJs&1.2.26.1180&1.2.50.335'
'enableOtfn&On-The-Fly-Normalization",default:\K!1&true&s&xpuiJs&1.2.31.1205'
'enableOverlaySidebarAnimations&Enable entry and exit animations for the overlay panels .queue, device picker, buddy feed.... in the side bar",default:\K!1&true&s&xpuiJs&1.2.38.720&1.2.45.454'
'enablePeekNpv&the Peek NPV feature",default:\K!1&true&s&xpuiJs&1.2.53.437'
'enablePiPMiniPlayer&the PiP Mini Player",default:\K!.(?=})&true&s&xpuiJs&1.2.32.985'
'enablePiPMiniPlayerQueue&PiP Queue behind miniplayer settings",default:\K!1&true&s&xpuiJs&1.2.67.553'
'enablePiPMiniPlayerSettings&PiP settings",default:\K!1&true&s&xpuiJs&1.2.65.255'
'enablePiPMiniPlayerVideo&playback of video inside the PiP Mini Player",default:\K!.(?=})&true&s&xpuiJs&1.2.32.985'
'enablePlaybackBarAnimation&animation of the playback bar",default:\K!1&true&s&xpuiJs&1.2.34.783'
'enablePlaylistCreationFlow&new playlist creation flow in Web Player and DesktopX",default:\K!1&true&s&xpuiJs&1.1.70.610&1.1.93.896'
'enablePlaylistPermissionsProd&Playlist Permissions flows for Prod",default:\K!.(?=})&true&s&xpuiJs&1.1.75.572&1.2.50.335'
'enablePodcastChaptersInNpv&showing podcast chapters in NPV",default:\K!.(?=})&true&s&xpuiJs&1.2.22.975&1.2.50.335'
'enablePodcastDescriptionAutomaticLinkification&Linkifies anything looking like a url in a podcast description.",default:\K!1&true&s&xpuiJs&1.2.19.937'
'enablePremiumUserForMiniPlayer&premium user flag for mini player",default:\K!1&true&s&xpuiJs&1.2.32.985'
'enablePrereleaseRadar&Show a curated list of upcoming albums to a user",default:\K!1&true&s&xpuiJs&1.2.39.578&1.2.45.454'
'enableProfileVisibilityControls&profile visibility controls in the settings . profile page",default:\K!1&true&s&xpuiJs&1.2.74.462'
'enableProgressBarEpisodeChapters&pisode chapters markers in the progress bar",default:\K!1&true&s&xpuiJs&1.2.68.525&1.2.74&1.2.74.477'
'enableProgressBarRefactorWithChapters&refactored ProgressBar implementation with chapter support",default:\K!1&true&s&xpuiJs&1.2.74.462'
'enableQueueOnRightPanel&Enable Queue on the right panel.",default:\K!.(?=})&true&s&xpuiJs&1.2.26.1180&1.2.61.443'
'enableQueueOnRightPanelAnimations&animations for Queue on the right panel.",default:\K!.(?=})&true&s&xpuiJs&1.2.32.985&1.2.50.335'
'enableReactQueryPersistence&React Query persistence",default:\K!.(?=})&true&s&xpuiJs&1.2.30.1135'
'enableReadAlongTranscripts&read along transcripts in the NPV",default:\K!.(?=})&true&s&xpuiJs&1.2.17.832&1.2.62.580'
'enableRecentlyPlayedShortcut&Show Recently Played shortcut in home view. Also increase max number of shortcuts to 8",default:\K!1&true&s&xpuiJs&1.2.21.1104&1.2.25.1011'
'enableRecentSearchesDropdown&recent searches dropdown in GlobalNavBar",default:\K!1&true&s&xpuiJs&1.2.45.451&1.2.52.442'
'enableRelatedVideos&Related Video section in NPV",default:\K!1&true&s&xpuiJs&1.2.21.1104'
'enableResizableTracklistColumns&resizable tracklist columns",default:\K!1&true&s&xpuiJs&1.2.28.581&1.2.66.447'
'enableRightSidebarArtistEnhanced&Enable Artist about V2 section in NPV",default:\K!.(?=})&true&s&xpuiJs&1.2.16.947&1.2.50.335'
'enableRightSidebarCollapsible&right sidebar to collapse into the right margin",default:\K!1&true&s&xpuiJs&1.2.34.783&1.2.37.701'
'enableRightSidebarCredits&Show credits in the right sidebar",default:\K!1&true&s&xpuiJs&1.2.7.1264&1.2.25.1011'
'enableRightSidebarMerchFallback&Allow merch to fallback to artist level merch if track level does not exist",default:\K!1&true&s&xpuiJs&1.2.5.954&1.2.11.916'
'enableRightSidebarTransitionAnimations&Enable the slide-in.out transition on the right sidebar",default:\K!1&true&s&xpuiJs&1.2.7.1264&1.2.33.1042'
'enableSearchBox&filter playlists when trying to add songs to a playlist using the contextmenu",default:\K!1&true&s&xpuiJs&1.1.86.857&1.1.93.896'
'enableSearchSuggestions&the search suggestions dropdown",default:\K!1&true&s&xpuiJs&1.2.72.435'
'enableSearchV3&new Search experience",default:\K!1&true&s&xpuiJs&1.1.87.612&1.2.34.783'
'enableScrollDrivenAnimations&croll driven animations for cards and shelved",default:\K!1&true&s&xpuiJs&1.2.39.578'
'enableSharingButtonOnMiniPlayer&sharing button on MiniPlayer .this also moves the ... icon close to the title.",default:\K!1&true&s&xpuiJs&1.2.39.578&1.2.43.420'
'enableShortLinks&short links for sharing",default:\K!1&true&s&xpuiJs&1.2.34.783'
'enableShowFollowsSetting&control if followers and following lists are shown on profile",default:\K!.(?=})&true&s&xpuiJs&1.2.1.958&1.2.50.335'
'enableShowRating&new UI for rating books and podcasts",default:\K!1&true&s&xpuiJs&1.2.32.985&1.2.62.580'
'enableShuffleSettings&shuffle settings section in advanced settings",default:\K!1&true&s&xpuiJs&1.2.75.499'
'enableSidebarAnimations&animations on the left and right on the sidebars and makes the right sidebar collapsible",default:\K!1&true&s&xpuiJs&1.2.34.783&1.2.37.701'
'enableSilenceTrimmer&silence trimming in podcasts",default:\K!1&true&s&xpuiJs&1.1.99.871'
'enableSkipNextTooltip&tooltip that shows a preview of the next item in queue.",values:.{1,3},default:.{1,4}\KDisabled&Expanded&s&xpuiJs&1.2.65.255'
'enableSocialConnectOnDesktop&the Social Connect API that powers group listening sessions for Desktop",values:.{1,3},default:.{1,4}\KDISABLED&ENABLED&s&xpuiJs&1.2.21.1104&1.2.45.454'
'enableSmallerLineHeight&line height 1.5 on the .body ..",default:\K!1&true&s&xpuiJs&1.2.18.997&1.2.23.1125'
'enableSmallPlaybackSpeedIncrements&playback speed range from 0.5-3.5 with every 0.1 increment",default:\K!1&true&s&xpuiJs&1.2.0.1155&1.2.14.1149'
'enableSmartShuffle&Enable Smart Shuffle",default:\K!1&true&s&xpuiJs&1.2.26.1180'
'enableStaticImage2Optimizer&static image2 optimizer to optimize image urls",default:\K!.(?=})&true&s&xpuiJs&1.2.20.1210&1.2.78.418'
'enableStrangerThingsEasterEgg&Stranger Things upside down Easter Egg",default:\K!1&true&s&xpuiJs&1.1.91.824'
'enableSubtitlesAutogeneratedLabel&label in the subtitle picker.,default:\K!.(?=})&true&s&xpuiJs&1.1.70.610&1.2.50.335'
'enableSyncingSearchHistoryToBackend&syncing search history to the backend",default:\K!1&true&s&xpuiJs&1.2.75.499'
'enableTiltable3DArtwork&tiltable 3D parallax effect on artwork .Cinema Mode and Cover Art Modal.",default:\K!1&true&s&xpuiJs&1.2.76.256'
'enableTogglePlaylistColumns&ability to toggle playlist column visibility",default:\K!1&true&s&xpuiJs&1.2.17.832&1.2.66.447'
'enableTracklistColumnsSorting&column reordering functionality in tracklists",default:\K!1&true&s&xpuiJs&1.2.69.448'
'enableUserCommentsForEpisodes&user comments for podcast episodes",default:\K!1&true&s&xpuiJs&1.2.49.439'
'enableUserCreatedArtwork&user created artworks for playlists",default:\K!1&true&s&xpuiJs&1.2.34.783&1.2.40.599'
'enableUserProfileEdit&editing of user.s own profile in Web Player and DesktopX",default:\K!1&true&s&xpuiJs&1.1.87.612&1.2.25.1011'
'enableVenuePages&Enables venus pages",default:\K!1&true&s&xpuiJs&1.2.37.701&1.2.74.477'
'enableVideoLabelForSearchResults&video label for search results",default:\K!1&true&s&xpuiJs&1.2.23.1114&1.2.29.605'
'enableVideoPip&desktop picture-in-picture surface using betamax SDK.",default:\K!1&true&s&xpuiJs&1.2.13.656'
'enableViewMode&list . compact mode in entity pages",default:\K!1&true&s&xpuiJs&1.2.24.754'
'enableWatchFeed&Enable Watch Feed feature",default:\K!1&true&s&xpuiJs&1.2.56.497'
'enableWatchFeedEntityPages&Watch Feed feature on entity pages",default:\K!1&true&s&xpuiJs&1.2.56.497'
'enableWhatsNewFeed&what.s new feed panel",default:\K!1&true&s&xpuiJs&1.2.12.902&1.2.16.947'
'enableWhatsNewFeedMainView&Whats new feed in the main view",default:\K!1&true&s&xpuiJs&1.2.17.832&1.2.45.454'
'enableWrapped2025ListenCount&displaying listen counts for tracks in Wrapped 2025 Your Top Songs playlists",default:\K!1&true&s&xpuiJs&1.2.80.349'
'enableYLXEnhancements&Your Library X Enhancements",default:\K!1&true&s&xpuiJs&1.2.18.997&1.2.50.335'
'enableYlxMultiSelect&multi selection in Your Library",default:\K!1&true&s&xpuiJs&1.2.72.435'
'enableYLXPrereleaseAlbums&album pre-releases in YLX",default:\K!1&true&s&xpuiJs&1.2.32.985'
'enableYLXPrereleaseAudiobooks&audiobook pre-releases in YLX",default:\K!1&true&s&xpuiJs&1.2.32.985&1.2.47.366'
'enableYLXPrereleases&album pre-releases in YLX",default:\K!1&true&s&xpuiJs&1.2.31.1205&1.2.31.1205'
'enableYlxReverseSorting&Enable reverse sort direction in Your Library",default:\K!1&true&s&xpuiJs&1.2.60.564'
'enableYLXTypeaheadSearch&jump to the first matching item",default:\K!1&true&s&xpuiJs&1.2.13.656'
'enableZoomSettingsUIDesktop&zoom settings from the settings page on Desktop",default:\K!1&true&s&xpuiJs&1.2.17.832&1.2.53.437'
'saveButtonAlwaysVisible&Display save button always in whats new feed",default:\K!1&true&s&xpuiJs&1.2.20.1210&1.2.28.0'
'shareButtonPositioning&Share button positioning in NPV",values:.{1,3},default:.{1,4}NPV_\K(HIDDEN|VISIBLE_ON_HOVER)&ALWAYS_VISIBLE&s&xpuiJs&1.2.39.578&1.2.50.335'
'showWrappedBanner&Show Wrapped banner on wrapped genre page",default:\K!1&true&s&xpuiJs&1.1.87.612&1.2.53.440'
)
premiumExpEx=(
'addYourDJToLibraryOnPlayback&Add Your DJ to library on playback",default:\K!1&true&s&xpuiJs&1.2.6.861&1.2.50.335'
'enableJamBroadcasting&Jam broadcasting and scanning",default:\K!1&true&s&xpuiJs&1.2.45.451&1.2.59.518'
'enableJamNearbyJoining&Jam Nearby Joining Connect devices in Connect Picker",default:\K!1&true&s&xpuiJs&1.2.60.564'
'enableOfflineAlbumsListPlatform&offline albums loaded over List Platform",default::\K!1&true&s&xpuiJs&1.2.48.404'
'enableYourDJ&the .Your DJ. feature.,default:\K!1&true&s&xpuiJs&1.2.6.861'
'enableYourSoundCapsuleModal&showing a modal on desktop to users who have clicked on a Your Sound Capsule share link",default:\K!1&true&s&xpuiJs&1.2.38.720'
)

run_prepare
run_uninstall_check
run_interactive_check
run_install_check
run_cache_check
run_core_start
run_patches
run_finish

printf "\xE2\x9C\x94\x20\x46\x69\x6E\x69\x73\x68\x65\x64\n\n"
exit 0
