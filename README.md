# UDSpotify
Creates hotkeys for controlling Spotify and other mediaprograms with standard keyboards

## Installation

  ### Easy Mode:
    * Run the executable
   ### Medium Mode:
    * Install AutoHotkey
    * Run the .ahk-File


## Controls

>All Hotkeys only start if the Cursor is placed on the taskbar. If it is somewhere else on the screen the normal hotkey will be replicated.
>As for now, the script requires a screenresolution of 1680x1050 to work correctly. A automatic screenadjustment is in work.


Hotkey | Description
------------ | -------------
Alt + s | Show / Hide Spotify (no Taskbar icon)<sup>[1](#foot1)</sup>
Alt + w | Play / Pause Current Sound<sup>[2](#foot2)</sup>
Alt + e | Next Track<sup>[2](#foot2)</sup>
Alt + q | Previous Track<sup>[2](#foot2)</sup>
Alt + r | Increase Volume<sup>[3](#foot3)</sup>
Alt + f | Decrease Volume<sup>[3](#foot3)</sup>
Alt + v | Mute Sound<sup>[3](#foot3)</sup>
Alt + x | Activate Shuffle<sup>[1](#foot1)</sup>
Alt + i | Turn On Transparency on Spotify<sup>[1](#foot1)</sup>
Alt + k | (Almost) Turn Off Transparency on Spotify<sup>[1](#foot1)</sup>
Alt + a | Display current song in a message box<sup>[1](#foot1)</sup>
Alt + F1 | Show all controls

### Explanation

<a name="foot1">1</a>: Only works if Spotify is installed. Else it will show the OSD but nothing else will happen.

<a name="foot2">2</a>: Utilizes Windows Media functions. Will also work in other players that register those events (f.e. Chrome)

<a name="foot3">3</a>: Utilizes Windows System Control. Will take effect on all Windows Applications

The Controls `Alt + s`, `Alt + x`, `Alt + a` and `Alt + i / k` only work if Spotify is installed.
If it is not installed the OSD will still trigger but nothing else will happen.
