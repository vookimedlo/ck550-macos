# ck550-macos 

[![GitHub license](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://raw.githubusercontent.com/vookimedlo/ck550-macos/master/LICENSE) ![Platform](https://img.shields.io/badge/platforms-macos%2010.14%2B-ff69b4.svg)
[![Latest release](https://img.shields.io/github/release/vookimedlo/ck550-macos.svg?label=latest%20release)](https://github.com/vookimedlo/ck550-macos/releases/latest)
[![codebeat badge](https://codebeat.co/badges/24d08641-db15-45e4-be57-a7412fd2d4b8)](https://codebeat.co/projects/github-com-vookimedlo-ck550-macos-master)
[![Build Status](https://travis-ci.org/vookimedlo/ck550-macos.svg?branch=master)](https://travis-ci.org/vookimedlo/ck550-macos)
[![FOSSA Status](https://app.fossa.io/api/projects/git%2Bgithub.com%2Fvookimedlo%2Fck550-macos.svg?type=shield)](https://app.fossa.io/projects/git%2Bgithub.com%2Fvookimedlo%2Fck550-macos?ref=badge_shield)

CoolerMaster has never provided any MacOS SW or SDK for their **CK550** and **CK530** keyboards.

CK550-macos project tries to fix this situation and provides a couple of the MacOS applications for controlling the
majority of available keyboard LED effects.
Applications support only the **CK550** and newly the **CK530** US-Layout keyboards.

Both applications differ only in a user interface, one is CLI-based, and the latter is GUI-based. Applications do not
overwrite any stored settings in a keyboard. Changes are temporary, so once the keyboard is unplugged, all changes made
by ck550-macos are lost. The same situation happens if you switch a keyboard to a different profile. 
The reason for this behavior is to keep the internal keyboard flash write cycles untouched.


| Supported LED effects  |
|------------------------|
| Static                 |
| Rainbow Wave           |
| Crosshair              |
| Reactive Fade          |
| Custom                 |
| Stars                  |
| Color Cycle            |
| Breathing              |
| Ripple                 |
| Snowing                |
| Reactive Punch         |
| Heartbeat              |
| Fireball               |
| Circle Spectrum        |
| Reactive Tornado       |
| Water Ripple           |
| Off                    |

All effects are previewed on [the official CoolerMaster website][2]. 

----------------------------------------------

## Command Line App

```
➜  ./ck550-cli
-= CK550 MacOS Utility =-
Available commands:

   about                     About ck550-cli...
   effect-breathing          Set a breathing effect
   effect-circle-spectrum    Set a circle spectrum effect
   effect-color-cycle        Set a color-cycle effect
   effect-crosshair          Set a crosshair effect
   effect-custom             Set a custom color for individual keys
   effect-fireball           Set a fireball effect
   effect-heartbeat          Set a heartbeat effect
   effect-off                Set an off effect
   effect-rainbow-wave       Set a rainbow-wave effect
   effect-reactive-fade      Set a reactive-fade effect
   effect-reactive-punch     Set a reactive-punch effect
   effect-reactive-tornado   Set a reactive-tornado effect
   effect-ripple             Set a ripple effect
   effect-snowing            Set a snowing effect
   effect-stars              Set a stars effect
   effect-static             Set a static effect
   effect-water-ripple       Set a water ripple effect
   help                      Display general or command-specific help
   license                   ck550-cli license
   license-components        ck550-cli 3rd party components and their licensing
   monitor                   Monitor HID devices continuously to see changes on an USB bus
   version                   Display the current ck550-cli version
```

Every available command is heavily documented.

```
➜  ./ck550-cli help effect-single-key
-= CK550 MacOS Utility =-
Set a reactive-fade effect

[--profile (integer)]
	keyboard profile to use for a modification

[--speed (speed)]
	effect speed (one of 'highest', 'higher', 'middle', 'lower', or 'lowest'), by default 'middle'

[--color (integer)]
	color (format: --color "255, 255, 255"), by default the color is white

[--background-color (integer)]
	background color (format: --background-color "255, 255, 255"), by default the color is black


➜ ./ck550-cli effect-reactive-fade --color "255, 0, 0"
```

All effects could be configured from a command line except the *Custom* effect.
This is effect too complicated, which allows to configure any key located on keyboard.
You can use [this configuration file][1] as a template to change any colors for any keys.

```
➜  ./ck550-cli help effect-custom
-= CK550 MacOS Utility =-
Set a custom color for individual keys

[--profile (integer)]
	keyboard profile to use for a modification

(string)
	the configuration file describing individual key colors


➜  ./ck550-cli effect-custom ~/myFavouriteGameKeys.json
```

----------------------------------------------


[![FOSSA Status](https://app.fossa.io/api/projects/git%2Bgithub.com%2Fvookimedlo%2Fck550-macos.svg?type=large)](https://app.fossa.io/projects/git%2Bgithub.com%2Fvookimedlo%2Fck550-macos?ref=badge_large)

## GUI App

CK550-MacOS GUI application is a MacOS menu bar (aka status bar) application.

![CK550 Main Menu](README/images/ck550-macos-main-menu.png?raw=true "")

The main menu contains two switchable options.

- *Adjust LEDs on a sleep and wake up* menu item in its *On state* controls if keyboard is instructed to use
a previously selected LED effect on system wake up or to turn off all LEDs when system sleeps. 
 
- *Set effect on a keyboard detection* menu item in its *On state* instructs a keyboard to use a previously selected
LED effect during a keyboard detection.

*Effects* menu item displays a submenu containing all available effects for a selection.

![CK550 Effect Menu](README/images/ck550-macos-effect-menu.png?raw=true "")

All effects could be configured either by selecting a general *Preferences...* menu item,
or by selecting a configuration icon on the right side of a given effect.

Changed preferences are saved immediately and are restored during the application startup.   

![CK550 Reactive Punch Preferences](README/images/ck550-macos-reactive-punch-effect-preferences.png?raw=true "")

The CK550 *Custom effect* could export and import the effect configuration, which is handy to have an ability
to load predefined keys colors for various software or games. The exported configuration files are fully compatible
with the CK550-MacOS CLI application.  

![CK550 Custom Preferences](README/images/ck550-macos-custom-effect-preferences-color-popup.png?raw=true "")

----------------------------------------------

## Installation

CK550-MacOS GUI & CLI applications are distributed in two fashions, which is either a `Homebrew CASK`, or the self-updatable DMG.

### Self-updatable DMG

The self-updatable DMG is available in a [release section][3]. Be aware that a CLI application is included in the GUI app bundle. You can run the `./ck550.app/Contents/MacOS/ck550-cli.app/Contents/MacOS/ck550-cli` or create a symbolic link to provide an easy access.

### Homebrew CASK

If you haven't install the Homebrew yet, follow [their instructions][4].

Then, applications could be installed by following commands.

```
brew tap vookimedlo/homebrew-ck550
brew cask install ck550-macos
```

If everything went well, you see a similar output and both GUI and CLI applications are ready to use.

```
➜   brew cask install ck550-macos
==> Satisfying dependencies
==> Downloading https://github.com/vookimedlo/homebrew-ck550/releases/download/v...
==> Verifying SHA-256 checksum for Cask 'ck550-macos'.
==> Installing Cask ck550-macos
==> Moving App 'ck550.app' to '/Applications/ck550.app'.
==> Linking Binary 'ck550-cli' to '/usr/local/bin/ck550-cli'.
🍺  ck550-macos was successfully installed!
```

Later, you can upgrade this application by following command.

```
brew cask upgrade ck550-macos
```

### Other CK keyboard models

It's possible that other CK keyboard models can be controlled by this software. If you are brave enough, you can enable your keyboard model by adding its USB PID to Constants.swift file. Just extend the _KeyboardPIDs_ enum, re-compile the code base, give it a try and let me know.

```
enum KeyboardPIDs: Int, CaseIterable {
    case CK550 = 0x007f; // Works - @vookimedlo - this is the only keyboard I have, any contribution for other models is welcome!!!
    case CK530 = 0x009f; // Works - @cscheib - suggested & reported - Thanks!!!
}
```

----------------------------------------------

[1]: https://github.com/vookimedlo/ck550-macos/blob/master/config/customization.json
[2]: http://www.coolermaster.com/peripheral/keyboards/ck550/
[3]: https://github.com/vookimedlo/ck550-macos/releases/latest
[4]: https://brew.sh/