#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.

DetectHiddenWindows Off

MpvExecutable := "C:\Program Files (x86)\MPV\mpv.exe"
SplashVideo := "C:\Users\alext\Games\Playnite\splash.mp4"
PlayniteInstallDir := "C:\Users\alext\AppData\Local\Playnite"

IsPlayniteRunning() {
  Process, Exist, Playnite.FullscreenApp.exe
  return ErrorLevel
}

IsPlayniteActive() {
  return WinExist("Playnite") and !WinExist("Playnite Splash Screen")
}

HidePlaynite() {
  ; Press Escape until all sub-windows have been removed
  ClosePlayniteSubWindows()

  ; Hide main window
  WinHide, Playnite
  WinActivate, Program Manager
}

ShowPlaynite() {
  WinShow, Playnite
  WinActivate, Playnite
  Winset, Alwaysontop, , Playnite
}

CountPlayniteWindows() {
  WinGet, ProcessID, PID, Playnite
  WinGet, Count, Count, ahk_pid %ProcessID%
  return Count
}

ClosePlayniteSubWindows() {
  OpenWindowCount := CountPlayniteWindows()
  Loop %OpenWindowCount% {
    SendInput, {Esc}
  }
}

HasPlayniteSubWindows() {
  OpenWindowCount := CountPlayniteWindows()
  return OpenWindowCount > 1
}

StartPlayniteSplashScreen() {
  global MpvExecutable
  global SplashVideo
  Run %MpvExecutable% %SplashVideo% --fs --ontop --no-border --cursor-autohide=always --no-input-cursor --no-osc --no-osd-bar --input-vo-keyboard=no --input-media-keys=no -no-input-default-bindings --title="Playnite Splash Screen"
  Winset, Alwaysontop, , Playnite Splash Screen
}

StartPlayniteFullScreen() {
  StartPlayniteSplashScreen()
  global PlayniteInstallDir
  Run "%PlayniteInstallDir%\Playnite.FullscreenApp.exe" --startfullscreen --hidesplashscreen --nolibupdate
}

StartPlayniteDesktop() {
  global PlayniteInstallDir
  Run "%PlayniteInstallDir%\Playnite.DesktopApp.exe" --startdesktop --hidesplashscreen --nolibupdate
}

OpenPlayniteMenu() {
  SendInput, {F1}
}

OpenGameBar() {
  SendInput, #{g}
}

CloseWindow() {
  SendInput, !{F4}
}

; This repeatedly presses Escape in order to reach the main screen.
BackToPlayniteHomeScreen() {
  SendInput, {Esc 5}
}

; WIP: Figure out if an emulator is running so we can override how the guide button works upon presses
; TODO Check for RetroArch, Dreamcast, Gamecube, PS1, N64, etc.
IsEmulatorRunning() {
  IsRetroArchRunning := WinExist("RetroArch")
  MsgBox %IsRetroArchRunning%
  return IsRetroArchRunning
}

$vk07:: ; Long press (> 0.5 secs) on * substitutes the dot multiply

While, GetKeyState("vk07") And !IsLongGuideButtonPress := A_TimeSinceThisHotkey > 750
  ; Wait no more than .75s sec for key release (also suppress auto-repeat)
	Sleep, 50

if (IsLongGuideButtonPress) {
  if (IsPlayniteRunning()) {
    if (IsPlayniteActive()) {
      HidePlaynite()
    } else {
      ; TODO Don't show if running an emulator or game
      ShowPlaynite()
    }
  } else {
    StartPlayniteFullScreen()
  }

	While, GetKeyState("vk07") {
		Sleep, 50
  }

; Short press of guide button
} else {
  ; When Playnite is open on the main menu, open the sub-menu.
  if (IsPlayniteRunning() and IsPlayniteActive() and !HasPlayniteSubWindows()) {
    BackToPlayniteHomeScreen()
    OpenPlayniteMenu()

  ; When Playnite is open on a sub-menu, go back to the main menu.
  } else if (IsPlayniteRunning() and IsPlayniteActive() and HasPlayniteSubWindows()) {
    ClosePlayniteSubWindows()


  ; -------------------------------------------------------------------------------------------
  ; TODO: Figure out what to do on guide presses during games or emulators
  ; Ideally would unbind default guide button presses in those apps and override behaviour here
  ; -------------------------------------------------------------------------------------------

  ; Default behaviour: open Xbox Game Bar
  } else {
    OpenGameBar()
  }
}
return

; Close fullscreen overlay with escape and open desktop app
$Esc::
  ; Launch desktop if on main menu and press Escape
  if (IsPlayniteRunning() and IsPlayniteActive() and !HasPlayniteSubWindows()) {
    StartPlayniteDesktop()
  ; Default behaviour for Escape key
  } else {
    SendInput, {Esc}
  }
