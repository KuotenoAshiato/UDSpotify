#MaxHotkeysPerInterval 200
#UseHook On
OSDColour2 = fffff  ; Can be any RGB color (it will be made transparent below).
Gui, 2: +LastFound +AlwaysOnTop -Caption +ToolWindow  ; +ToolWindow avoids a taskbar button and an alt-tab menu item.
Gui, 2:Font, s128, Times New Roman  ; Set a large font size (32-point).
Gui, 2:Add, Text, vOSDControl c2dfc25 x60 y200, Loading Script... ; XX & YY serve to auto-size the window; add some random letters to enable a longer string of text (but it might not fit on the screen).
Gui, 2:Color, %OSDColour2%
WinSet, TransColor, %OSDColour2% 200 ; Make all pixels of this color transparent and make the text itself translucent (150)
Gui, 2:Show, NoActivate, OSDGui
SetTitleMatchMode 2
SetKeyDelay, 1000
StartUp()
Gui, 2:Show, Hide

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

;All Hotkeys to start the software
!r::
	if MouseIsOver("ahk_class Shell_TrayWnd")
		VolUp()
	else
		Send {Alt Down}r{Alt Up}
	return
!f::
	if MouseIsOver("ahk_class Shell_TrayWnd")
		VolDown()
	else
		Send {Alt Down}f{Alt Up}
	return
!v::
	if MouseIsOver("ahk_class Shell_TrayWnd")
		VolMute()
	else
		Send {Alt Down}v{Alt Up}
	return
!e::
	if MouseIsOver("ahk_class Shell_TrayWnd")
		PlayNext()
	else
		Send {Alt Down}e{Alt Up}
	return
!q::
	if MouseIsOver("ahk_class Shell_TrayWnd")
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
	if MouseIsOver("ahk_class Shell_TrayWnd")
		StartSpotify()
	else
		Send {Alt Down}s{Alt Up}
	return
!x::
	if MouseIsOver("ahk_class Shell_TrayWnd")
		ShuffleSwitch()
	else
		Send {Alt Down}x{Alt Up}
	return
!a::
	if MouseIsOver("ahk_class Shell_TrayWnd")
		SongInfo()
	else
		Send {Alt Down}a{Alt Up}
	return
!i::
	if MouseIsOver("ahk_class Shell_TrayWnd")
		TransOn()
	else
		Send {Alt Down}i{Alt Up}
	return
!k::
	if MouseIsOver("ahk_class Shell_TrayWnd")
		TransOff()
	else
		Send {Alt Down}k{Alt Up}
	return
!l::
if MouseIsOver("ahk_class Shell_TrayWnd")
	LockScreen()
else
	Send {Alt Down}l{Alt Up}
return
!F1::
	if MouseIsOver("ahk_class Shell_TrayWnd")
		OpenHelp()
	else
		Send {Alt Down}{F1}{Alt Up}
	return
!^y:: Reload ;Reload the script from the workspace

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
}

TransOff(){ ;Sets the Transparency of the active Spotify window to 250 (Non Transparent)
	IfWinExist ahk_exe Spotify.exe
	{
		WinSet, Transparent, 250
	}
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

LockScreen(){ ;Catches the Name of the Spotify.exe and prints it in a Message Box
	DetectHiddenWindows, On
	WinGet, winInfo, List, ahk_exe Spotify.exe
	indexer := 3
	thisID := winInfo%indexer%
	WinGetTitle, playing, ahk_id %thisID%
	var := "Spotify Premium"
	If !InStr(playing, var)
		Send {Media_Play_Pause}
	DllCall("LockWorkStation")
	DetectHiddenWindows, Off
}

OpenHelp(){ ;Shows all Hotkeys implemented
	Msgbox,64,Hotkey Combination Guide, Combination Guide:`n`nNote that all Buttons have to be pressed with the Mouse placed at the Bottom of the Screen`n`nALT+W = Play/Pause`nALT+X = Shuffle On/Off`nALT+E/ALT+Q = Next/Previous Track`nALT+R/ALT+F = Volume Up/Down`nALT+V = Sound Mute`nALT+S = Start/Hide Spotify`nALT+F1 = Help
}

OSD(Text="OSD",Colour="2dfc25",Duration="500",Font="Arial",Size="40"){ ; Displays an On-Screen Display, a text in the middle of the screen.
	Gui, 2:Font, c%Colour% s%Size%, %Font%  ;If desired, use a line like this to set a new default font for the window.
	GuiControl, 2:Font, OSDControl  ;Put the above font into effect for a control.
	GuiControl, 2:, OSDControl, %Text%
	Gui, 2:Show, X20,Y200,NoActivate, OSDGui ;NoActivate avoids deactivating the currently active window; add "X600 Y800" to put the text at some specific place on the screen instead of centred.
	SetTimer, OSDTimer, -%Duration%
	Return
}

OSDTimer:
	Gui, 2:Show, Hide
Return