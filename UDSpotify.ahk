#MaxHotkeysPerInterval 200
#UseHook On
#Include %A_ScriptDir%
#include lib\SpotifyAPI.ahk
#Include lib

global cond1 := True
global shuffle := 
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
StartUpFunc()
Gui, 2:Show, Hide



;All Hotkeys to start the software
!r:: ;Volume Up
	if MouseIsOver("ahk_class Shell_TrayWnd") || MouseIsOver("ahk_class Shell_SecondaryTrayWnd")
		VolUp()
	else
		Send {Alt Down}r{Alt Up}
	return
!f:: ;Volume Down
	if MouseIsOver("ahk_class Shell_TrayWnd") || MouseIsOver("ahk_class Shell_SecondaryTrayWnd")
		VolDown()
	else
		Send {Alt Down}f{Alt Up}
	return
!v:: ;Mute Sound
	if MouseIsOver("ahk_class Shell_TrayWnd") || MouseIsOver("ahk_class Shell_SecondaryTrayWnd")
		VolMute()
	else
		Send {Alt Down}v{Alt Up}
	return
!e:: ;Next Track
	if MouseIsOver("ahk_class Shell_TrayWnd") || MouseIsOver("ahk_class Shell_SecondaryTrayWnd")
		PlayNext()
	else
		Send {Alt Down}e{Alt Up}
	return
!q:: ;Previous Track
	if MouseIsOver("ahk_class Shell_TrayWnd") || MouseIsOver("ahk_class Shell_SecondaryTrayWnd")
		PlayPrev()
	else
		Send {Alt Down}q{Alt Up}
	return
!w:: ;Play / Pause
	if MouseIsOver("ahk_class Shell_TrayWnd") || MouseIsOver("ahk_class Shell_SecondaryTrayWnd")
		PlayPause()
	else
		Send {Alt Down}w{Alt Up}
	return
!s:: ;Open Spotify
	if (MouseIsOver("ahk_class Shell_TrayWnd") || MouseIsOver("ahk_class Shell_SecondaryTrayWnd")) && cond1 = true
		StartSpotify()
	else
		Send {Alt Down}s{Alt Up}
	return
!x:: ;Switch Shufflemode
	if (MouseIsOver("ahk_class Shell_TrayWnd") || MouseIsOver("ahk_class Shell_SecondaryTrayWnd")) && ActiveCheck()
		ShuffleSwitchAPI()
	else
		Send {Alt Down}x{Alt Up}
	return
!a:: ;Songinfo Msgbox + Clipboard
	if (MouseIsOver("ahk_class Shell_TrayWnd") || MouseIsOver("ahk_class Shell_SecondaryTrayWnd"))
		SongInfoAPI()
	else
		Send {Alt Down}a{Alt Up}
	return
!i:: ;Make Spotify Translucent
	if (MouseIsOver("ahk_class Shell_TrayWnd") || MouseIsOver("ahk_class Shell_SecondaryTrayWnd")) && cond1 = true
		TransOn()
	else
		Send {Alt Down}i{Alt Up}
	return
!k:: ;Make Spotify non Transparent
	if (MouseIsOver("ahk_class Shell_TrayWnd") || MouseIsOver("ahk_class Shell_SecondaryTrayWnd")) && cond1 = true
		TransOff()
	else
		Send {Alt Down}k{Alt Up}
	return
!l:: ;Lock Screen and Pause Music, if Playing
	if MouseIsOver("ahk_class Shell_TrayWnd") || MouseIsOver("ahk_class Shell_SecondaryTrayWnd")
		LockScreen()
	else
		Send {Alt Down}l{Alt Up}
	return
!u:: ;Select Playlist to Save Songs to
	if MouseIsOver("ahk_class Shell_TrayWnd") || MouseIsOver("ahk_class Shell_SecondaryTrayWnd")
		ListSelector()
	else
		Send {Alt Down}u{Alt Up}
	return
!p:: ;Save Current Track to Selected Playlist
	if (MouseIsOver("ahk_class Shell_TrayWnd") || MouseIsOver("ahk_class Shell_SecondaryTrayWnd")) && apier.Player.GetCurrentPlaybackInfo()["is_playing"]
		PlayLister()
	else
		Send {Alt Down}p{Alt Up}
	return
	if MouseIsOver("ahk_class Shell_TrayWnd") || MouseIsOver("ahk_class Shell_SecondaryTrayWnd")
	else
	return

!F1:: ;Openhelp, Discontinued
	if MouseIsOver("ahk_class Shell_TrayWnd") || MouseIsOver("ahk_class Shell_SecondaryTrayWnd")
		OpenHelp()
	else
		Send {Alt Down}{F1}{Alt Up}
	return
!^y:: Reload ;Reload the script from the workspace


IniSetup(){ ;Create the Inifile with basic Settings
	if !FileExist("%A_ScriptDir%\settings.ini")
		FileAppend,, %A_ScriptDir%\settings.ini
	IniRead, OSDColour1, settings.ini, basics, color, c2dfc25
	if OSDColour1 = c2dfc25
		IniWrite, %OSDColour1%, settings.ini, basics, color 
}

ColourCheck(colour){ ;Create UI Colors
	If substr(colour, 6 , 1) != 9
		return substr(colour,1,5)9
	Else
		return substr(colour,1,5)8
}
StartUpFunc(){ ;Help Function for Organizing Startup features (WIP)
	StartUpRec()

}
StartUpRec(){ ;Basic Registration and Startup of Spotify
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
		StartUpRec()
	} 
}

MouseIsOver(windowtitle){ ;Checks if the Cursor is hovering desired object
    MouseGetPos,,, window
    return WinExist(windowtitle . " ahk_id " . window) 
}

ActiveCheck(){ ;Check if a Spotify Device is Active to Catch 404 Errors
	devlist := apier.Player.GetDeviceList()
	activedev := false
	count := -1

	for index, device in devlist
		count++
	Loop, %count%
		if devlist[A_Index].isactive
		{
			return true
			MsgBox % devlist[A_Index].Name
		}
	return false
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

ShuffleSwitchNonAPI(){ ;Routes Ctrl+S into the Spotify .exe to trigger the shuffle button
	DetectHiddenWindows, On
	WinGet, winInfo, List, ahk_exe Spotify.exe
	indexer := 3
	thisID := winInfo%indexer%
	ControlFocus,, ahk_id %thisID%
	Send {Ctrl Down}s{Ctrl Up}
	OSD("Shuffle Mode On / Off")
}

ShuffleSwitchAPI(){ ;uses the API to trigger shuffle
	if shuffle = 
		shuffle := true
	shuffle := !shuffle
	apier.Player.SetShuffle(shuffle)
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

SongInfoNonAPI(){ ;Catches the Name of the Spotify.exe and prints it in a Message Box
	DetectHiddenWindows, On
	WinGet, winInfo, List, ahk_exe Spotify.exe
	indexer := 3
	thisID := winInfo%indexer%
	WinGetTitle, playing, ahk_id %thisID%
	Msgbox %playing%
	clipboard = %playing%
	DetectHiddenWindows, Off
}

SongInfoAPI(){ ;Catches the Name of the Spotify.exe and prints it in a Message Box
	playingTit := apier.Player.GetCurrentPlaybackInfo().Track.Name
	playingArt := apier.Player.GetCurrentPlaybackInfo().Track.Artists
	playingArtTit := playingArt[1].Name
	count := -1
	for index, artist in playingArt
		count++
	Loop, %count%
		playingArtTit .= ", " playingArt[A_Index+1].Name
	Msgbox %playingTit% - %playingArtTit%
	playing = %playingTit% - %playingArtTit%
	clipboard := playing
}

PlayLister(){ ;Uses the SpotifyAHK-Api by CloakerSmoker to add the current track to a designated playlist
	playlistid :=
	errorhandle := "ERROR"
	IniRead, playlistid, settings.ini, savelist, 1
	if (playlistid = errorhandle || playlistid = "")
	{
		playlistid := apier.Playlists.CreatePlaylist("UDSpotifySaves","Songs saved using ALT+P from the UDSpotify.ahk Script (https://github.com/KuotenoAshiato/UDSpotify/)",false).ID
		IniWrite, %playlistid%, settings.ini, savelist, 1
	}
	trackid := apier.Player.GetCurrentPlaybackInfo().Track.ID
	apier.Playlists.GetPlaylist(playlistid).AddTrack(trackid)
	OSD("'" . apier.Player.GetCurrentPlaybackInfo().Track.Name . "' added",,"5000")
}

ListSelector(){ ;Create a Dropdownlist which will be used for Song saves.
	newplaylists := apier.Users.getUser(apier.CurrentUser.id).GetPlaylists()
	global List :=
	Gui, 1:Destroy
	Gui, Add, Text,, Wich Playlist to add Songs to?
	namelist := newplaylists[1].Name "|"
	count := -1
	for index, playlist in newplaylists
		count++
	loop, %count% {
		zwobject := newplaylists[A_Index+1]
		if(zwobject.owner.id = apier.CurrentUser.id){
			namelist .= "|" zwobject.Name
		}
	}
	Gui, Add, DDL, vList, %namelist%
	Gui, Add, Button, Default glistsubmit, Go
	Gui, Add, Button, glistnew, New Playlist
	Gui, Show
	return
	listsubmit:
	Gui, Submit, NoHide
	Gui, 1:Destroy
	zw :=
	for k, v in newplaylists {
		if v.Name = List
			zw := % v.ID
	}
	IniWrite, %zw%, settings.ini, savelist, 1
	return
	listnew:
	Gui, Submit, NoHide
	Gui, 1:Destroy
	playlistid := apier.Playlists.CreatePlaylist("UDSpotifySaves","Songs saved using ALT+P from the UDSpotify.ahk Script (https://github.com/KuotenoAshiato/UDSpotify/)",false).ID
	IniWrite, %playlistid%, settings.ini, savelist, 1
	return
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