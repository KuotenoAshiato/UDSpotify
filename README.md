# UDSpotify
Creates hotkeys for controlling Spotify and other mediaprograms with standard keyboards

## Installation

  ### Easy Mode:
  * Download .exe
  * Run the executable
   ### Medium Mode:
  * Install AutoHotkey
  * Paste UDSpotify.ahk and lib folder to the same path
  * Run the .ahk-File


## Controls

>All Hotkeys only start if the Cursor is placed on the taskbar. If it is somewhere else on the screen the normal hotkey will be replicated.


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
Alt + l | Locks screen and pauses Spotify if music is playing<sup>[1](#foot1)</sup>
Alt + a | Display current song in a message box<sup>[1](#foot1)</sup>
Alt + p | Adds current track to a (new) playlist<sup>[4](#foot4)</sup>
Alt + F1 | Show all controls

### Explanation

<a name="foot1">1</a>: Only works if Spotify is installed. Else it will show the OSD but nothing else will happen.

<a name="foot2">2</a>: Utilizes Windows Media functions. Will also work in other players that register those events (f.e. Chrome)

<a name="foot3">3</a>: Utilizes Windows System Control. Will take effect on all Windows Applications

<a name="foot4">4</a>: Utilizes [Spotify API](https://github.com/CloakerSmoker/Spotify.ahk). Needs access when starting the script.


Uses a slightly modified version of the [Spotify.ahk by CloakerSmoker](https://github.com/CloakerSmoker/Spotify.ahk), the [AHKhttp library by zhamlin](https://github.com/zhamlin/AHKhttp), the [AHKsock library by jleb](https://github.com/jleb/AHKsock) and the [Cyrpt library by Deo](https://autohotkey.com/board/topic/67155-ahk-l-crypt-ahk-cryptography-class-encryption-hashing/)
