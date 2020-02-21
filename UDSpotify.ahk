#MaxHotkeysPerInterval 200
#UseHook On
#Include %A_ScriptDir%
#Include lib\SpotifyAPI.ahk

global cond1 := True
global apier := new Spotify
global OSDColour1 := 

IniSetup()
OSDColour2 := ColourCheck(OSDColour1)
Gui, 2: +LastFound +AlwaysOnTop -Caption +ToolWindow  ; +ToolWindow avoids a taskbar button and an alt-tab menu item.
Gui, 2:Font, s128, Times New Roman  ; Set a large font size (32-point).
Gui, 2:Add, Text, vOSDControl c%OSDColour1% x60 y200, Loading Script... ; XX & YY serve to auto-size the window; add some random letters to enable a longer string of text (but it might not fit on the screen).
Gui, 2:Color, %OSDColour2%
WinSet, TransColor, %OSDColour2% 200 ; Make all pixels of this color transparent and make the text itself translucent
Gui, 2:Show, NoActivate, OSDGui
SetTitleMatchMode 2
SetKeyDelay, 1000
StartUp()
Gui, 2:Show, Hide



;All Hotkeys to start the software
!r::
	if MouseIsOver("ahk_class Shell_TrayWnd") || MouseIsOver("ahk_class Shell_SecondaryTrayWnd")
		VolUp()
	else
		Send {Alt Down}r{Alt Up}
	return
!f::
	if MouseIsOver("ahk_class Shell_TrayWnd") || MouseIsOver("ahk_class Shell_SecondaryTrayWnd")
		VolDown()
	else
		Send {Alt Down}f{Alt Up}
	return
!v::
	if MouseIsOver("ahk_class Shell_TrayWnd") || MouseIsOver("ahk_class Shell_SecondaryTrayWnd")
		VolMute()
	else
		Send {Alt Down}v{Alt Up}
	return
!e::
	if MouseIsOver("ahk_class Shell_TrayWnd") || MouseIsOver("ahk_class Shell_SecondaryTrayWnd")
		PlayNext()
	else
		Send {Alt Down}e{Alt Up}
	return
!q::
	if MouseIsOver("ahk_class Shell_TrayWnd") || MouseIsOver("ahk_class Shell_SecondaryTrayWnd")
		PlayPrev()
	else
		Send {Alt Down}q{Alt Up}
	return
!w::
	if MouseIsOver("ahk_class Shell_TrayWnd")
		PlayPause()
	else
		Send {Alt Down}w{Alt Up}
	return
!s::
	if (MouseIsOver("ahk_class Shell_TrayWnd") || MouseIsOver("ahk_class Shell_SecondaryTrayWnd")) && cond1 = true
		StartSpotify()
	else
		Send {Alt Down}s{Alt Up}
	return
!x::
	if MouseIsOver("ahk_class Shell_TrayWnd") || MouseIsOver("ahk_class Shell_SecondaryTrayWnd")
		ShuffleSwitch()
	else
		Send {Alt Down}x{Alt Up}
	return
!a::
	if (MouseIsOver("ahk_class Shell_TrayWnd") || MouseIsOver("ahk_class Shell_SecondaryTrayWnd")) && cond1 = true
		SongInfo()
	else
		Send {Alt Down}a{Alt Up}
	return
!i::
	if (MouseIsOver("ahk_class Shell_TrayWnd") || MouseIsOver("ahk_class Shell_SecondaryTrayWnd")) && cond1 = true
		TransOn()
	else
		Send {Alt Down}i{Alt Up}
	return
!k::
	if (MouseIsOver("ahk_class Shell_TrayWnd") || MouseIsOver("ahk_class Shell_SecondaryTrayWnd")) && cond1 = true
		TransOff()
	else
		Send {Alt Down}k{Alt Up}
	return
!l::
	if MouseIsOver("ahk_class Shell_TrayWnd") || MouseIsOver("ahk_class Shell_SecondaryTrayWnd")
		LockScreen()
	else
		Send {Alt Down}l{Alt Up}
	return
!p::
	if (MouseIsOver("ahk_class Shell_TrayWnd") || MouseIsOver("ahk_class Shell_SecondaryTrayWnd")) && apier.Player.GetCurrentPlaybackInfo()["is_playing"]
		PlayLister()
	else
		Send {Alt Down}p{Alt Up}
	return
!F1::
	if MouseIsOver("ahk_class Shell_TrayWnd") || MouseIsOver("ahk_class Shell_SecondaryTrayWnd")
		OpenHelp()
	else
		Send {Alt Down}{F1}{Alt Up}
	return
!^y:: Reload ;Reload the script from the workspace


IniSetup(){
	if !FileExist("%A_ScriptDir%\settings.ini")
		FileAppend,, %A_ScriptDir%\settings.ini
	IniRead, OSDColour1, settings.ini, basics, color, c2dfc25
	if OSDColour1 = c2dfc25
		IniWrite, %OSDColour1%, settings.ini, basics, color
}

ColourCheck(colour){
	If substr(colour, 6 , 1) != 9
		return substr(colour,1,5)9
	Else
		return substr(colour,1,5)8
}

StartUp(){
	IfWinExist ahk_exe Spotify.exe
	{
		WinSet, Transparent, 120
		WinHide
		IfWinExist ahk_exe Spotify.exe
		{
			WinSet, Transparent, 120
			WinHide
			IfWinExist ahk_exe Spotify.exe
			{
				WinSet, Transparent, 120
				WinSet, AlwaysOnTop, On
			}
		}
	}
	else{
		Try {
			run "%appdata%\Spotify\Spotify.exe"

		}Catch{
			cond1 = false
			MsgBox, "Spotify not installed"
			return
		}
		sleep 5000
		Startup()
	}
}

MouseIsOver(windowtitle){ ;Enhanced Taskbar recognition
    MouseGetPos,,, window
    return WinExist(windowtitle . " ahk_id " . window)
}

VolUp(){ ;Increases the System Volume
		SoundSet +1
		SoundGet, volume
		OSD("Volume Up (" . Floor(volume) . ")")
}

VolMute(){ ;Mutes the System Volume
		Send {Volume_Mute}
		OSD("Mute/Unmute Sound")
}

VolDown(){ ;Decreases the System Volume
		SoundSet -1
		SoundGet, volume
		OSD("Volume Down (" . Floor(volume) . ")")
}

PlayNext(){ ;Uses Media Event 'Next'
		Send {Media_Next}
		OSD("Next Song")
}

PlayPrev(){ ;Uses Media Event 'Previous'
		Send {Media_Prev}
		OSD("Previous Song")
}

PlayPause(){ ;Uses Media Event 'Play Pause'
		Send {Media_Play_Pause}
		OSD("Play / Pause")
}

ShuffleSwitch(){ ;Routes Ctrl+S into the Spotify .exe to trigger the shuffle button
	DetectHiddenWindows, On
	WinGet, winInfo, List, ahk_exe Spotify.exe
	indexer := 3
	thisID := winInfo%indexer%
	ControlFocus,, ahk_id %thisID%
	Send {Ctrl Down}s{Ctrl Up}
	OSD("Shuffle Mode On / Off")
}

StartSpotify(){ ;Starts Spotify and closes non important instances of it or Hides spotify completely
	OSD("Open / Minimize Spotify")
	IfWinExist ahk_exe Spotify.exe
	{
		IfWinExist ahk_exe Spotify.exe
		{
			WinHide
			IfWinExist ahk_exe Spotify.exe
			{
				WinHide
				IfWinExist ahk_exe Spotify.exe
				{
					WinHide
				}
			}
		}
	}
	else
	{
		Try
		{
			run "%appdata%\Spotify\Spotify.exe",, Min
		}
		Catch
		{
			return
		}
		sleep 1000
		IfWinExist ahk_exe Spotify.exe
		{
			WinHide
			IfWinExist ahk_exe Spotify.exe
			{
				WinHide				
			}
			WinActivate ahk_exe Spotify.exe
		}
	}
}

TransOn(){ ;Sets the Transparency of the active Spotify window to 120(Translucent)
	IfWinExist ahk_exe Spotify.exe
	{
		WinSet, Transparent, 120
	}
	OSD("Transparency On")
}

TransOff(){ ;Sets the Transparency of the active Spotify window to 250 (Non Transparent)
	IfWinExist ahk_exe Spotify.exe
	{
		WinSet, Transparent, 250
	}
	OSD("Transparency Off")
}

SongInfo(){ ;Catches the Name of the Spotify.exe and prints it in a Message Box
	DetectHiddenWindows, On
	WinGet, winInfo, List, ahk_exe Spotify.exe
	indexer := 3
	thisID := winInfo%indexer%
	WinGetTitle, playing, ahk_id %thisID%
	Msgbox %playing%
	clipboard = %playing%
	DetectHiddenWindows, Off
}

PlayLister(){ ;Uses the SpotifyAHK-Api by CloakerSmoker to add the current track to a designated playlist
	playlistid :=
	errorhandle := "ERROR"
	IniRead, playlistid, settings.ini, savelist, 1
	if (playlistid = errorhandle)
	{
		playlistid := apier.Playlists.CreatePlaylist("UDSpotifySaves","Songs saved using ALT+P from the UDSpotify.ahk Script (https://github.com/KuotenoAshiato/UDSpotify/)",false).ID
		IniWrite, %playlistid%, settings.ini, savelist, 1
	}
	trackid := apier.Player.GetCurrentPlaybackInfo().Track.ID
	apier.Playlists.GetPlaylist(playlistid).AddTrack(trackid)
	OSD("'" . apier.Player.GetCurrentPlaybackInfo().Track.Name . "' added",,"5000")
}

LockScreen(){ ;If the Spotify Windowtitle doesn't contain "Spotify" in it, it will pause the playing track. Afterwards the PC will be locked
	DetectHiddenWindows, On
	WinGet, winInfo, List, ahk_exe Spotify.exe
	indexer := 3
	thisID := winInfo%indexer%
	WinGetTitle, playing, ahk_id %thisID%
	var := "Spotify"
	If !InStr(playing, var)
		Send {Media_Play_Pause}
	DllCall("LockWorkStation")
	DetectHiddenWindows, Off
}

OpenHelp(){ ;Shows all Hotkeys implemented
	Msgbox,64,Hotkey Combination Guide, Combination Guide:`n`nNote that all Buttons have to be pressed with the Mouse placed at the Bottom of the Screen`n`nALT+W = Play/Pause`nALT+X = Shuffle On/Off`nALT+E/ALT+Q = Next/Previous Track`nALT+R/ALT+F = Volume Up/Down`nALT+V = Sound Mute`nALT+L = Lock Computer ans Pause Music`nALT+P = Add current song to Saved UDPlaylist`nALT+S = Start/Hide Spotify`nALT+F1 = Help
}

OSD(Text="OSD",Colour="c2dfc25",Duration="500",Font="Niagara Engraved Regular",Size="40"){ ; Displays an On-Screen Display, a text in the middle of the screen.
	Gui, 2:Font, c%OSDColour1% s%Size%, %Font%  ;If desired, use a line like this to set a new default font for the window.
	GuiControl, 2:Font, OSDControl  ;Put the above font into effect for a control.
	GuiControl, 2:, OSDControl, %Text%
	Gui, 2:Show, X20,Y200,NoActivate, OSDGui ;NoActivate avoids deactivating the currently active window; add "X600 Y800" to put the text at some specific place on the screen instead of centred.
	SetTimer, OSDTimer, -%Duration%
	Return
}

OSDTimer:
	Gui, 2:Show, Hide
Return