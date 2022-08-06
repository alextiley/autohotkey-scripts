#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.

DetectHiddenWindows Off

; Video courtesy of https://www.reddit.com/r/playnite/comments/nhwafk/comment/gz2ov2j/?utm_source=share&utm_medium=web2x&context=3
; See https://mega.nz/folder/gkgSQTBT#0BhXiRZoKlIrqTXrCnX7vQ
SplashVideo := "C:\Users\<your-user>\Games\Playnite\splash.mp4"
MpvExecutable := "C:\Program Files (x86)\MPV\mpv.exe"
PlayniteInstallDir := "C:\Users\<your-user>\AppData\Local\Playnite"

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

; Xbox Guide Button
; Could be replaced with PS button (not sure of code though. See https://www.autohotkey.com/docs/KeyList.htm#SpecialKeys for details on how to find keycode)
$vk07::

While, GetKeyState("vk07") And !IsLongGuideButtonPress := A_TimeSinceThisHotkey > 750
  ; Suppress auto repeat after 0.75 seconds
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
  ; Perhaps it would be nice to close the game (Alt+F4).
  ; -------------------------------------------------------------------------------------------

  ; Default behaviour: open Xbox Game Bar
  } else {
    OpenGameBar()
  }
}
return

; Close fullscreen overlay with escape and open desktop app
; Optional: feel free to remove this!
$Esc::
  ; Launch desktop mode if on main menu and user presses Escape
  if (IsPlayniteRunning() and IsPlayniteActive() and !HasPlayniteSubWindows()) {
    StartPlayniteDesktop()
  ; Default behaviour for Escape key
  } else {
    SendInput, {Esc}
  }
