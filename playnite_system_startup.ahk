;--------------------------------------------------------------------------------------------------;
; Playnite: system startup script                                                                  ;
;--------------------------------------------------------------------------------------------------;
; This script will listen for controller input and perform the following actions:                  ;
;   - LB + RB + Back + Start: Send Alt F4 to the current open window or application                ;
;   - L3 (long press): Open Playnite in full screen mode and show a nice video at startup          ;
;--------------------------------------------------------------------------------------------------;

#Persistent
#SingleInstance force
;#NoTrayIcon
#NoEnv
#Warn
#include %A_ScriptDir%\lib\xinput.ahk

XInput_Init()

DetectHiddenWindows Off
SendMode Input
SetWorkingDir, %A_ScriptDir%

; Video courtesy of https://www.reddit.com/r/playnite/comments/nhwafk/comment/gz2ov2j/?utm_source=share&utm_medium=web2x&context=3
; See https://mega.nz/folder/gkgSQTBT#0BhXiRZoKlIrqTXrCnX7vQ

SplashVideo := A_ScriptDir . "\media\splash.mp4"
MpvInstallDir := "C:\Program Files (x86)\MPV"
PlayniteInstallDir := "C:\Users\alext\AppData\Local\Playnite"

IsPlayniteRunning() {
  Process, Exist, Playnite.FullscreenApp.exe
  return ErrorLevel
}

IsPlayniteActive() {
  CurrentActiveHwnd := WinExist("A")
  return WinExist("Playnite") and !WinExist("Playnite Splash Screen") and CurrentActiveHwnd = WinActive("Playnite")
}

; Depends upon game start/end scripts. See playnite_pre_game.ahk and playnite_post_game.ahk
; Could break if Playnite is closed before the game. But this should only happen in the event of a crash.
IsGameRunning() {
  IniRead, IsGameRunning, %A_ScriptDir%\playnite.ini, Playnite, IsGameRunning, %A_Space%
  return IsGameRunning || 0
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
}

CountPlayniteWindows() {
  WinGet, ProcessID, PID, Playnite
  WinGet, Count, Count, ahk_pid %ProcessID%
  return Count
}

ClosePlayniteSubWindows() {
  OpenWindowCount := CountPlayniteWindows()
  Loop %OpenWindowCount% {
    Send, {Esc}
  }
}

StartPlayniteFullScreen() {
  global MpvInstallDir
  global SplashVideo
  global PlayniteInstallDir

  ; Create a black screen and show it instantly. Play the video when possible.
  Gui, +AlwaysOnTop +ToolWindow -DPIScale -Caption -border -SysMenu
  Gui, Color, 000000
  Gui, Show, % "w" A_ScreenWidth " h" A_ScreenHeight + 200, Loading ; + 200 hack for filling menu bar space

  ; Launch the video
  Run %MpvInstallDir%\mpv.exe %SplashVideo% --fs --ontop --no-border --cursor-autohide=always --no-input-cursor --no-osc --no-osd-bar --input-vo-keyboard=no --input-media-keys=no -no-input-default-bindings --title="Playnite Splash Screen"
  Winset, Alwaysontop, On, Playnite Splash Screen

  ; Launch the app
  Run "%PlayniteInstallDir%\Playnite.FullscreenApp.exe" --startfullscreen --hidesplashscreen

  ; By now the video should be playing, hide the screen
  sleep 5000
  Gui, Destroy
}

StartPlayniteDesktop() {
  global PlayniteInstallDir
  Run "%PlayniteInstallDir%\Playnite.DesktopApp.exe" --startdesktop --hidesplashscreen
}

CloseCurrentWindow() {
  Send, !{F4}
}

TogglePlayniteVisibility() {
  ; Handle full screen visibility
  If (IsPlayniteRunning()) {
    ; Unhide the Playnite full screen window
    If (IsPlayniteActive()) {
      HidePlaynite()
    ; Open the full screen Playnite window. Disallow opening if a game is running (the experience isn't great).
    } Else If (!IsGameRunning()) {
      ShowPlaynite()
    }
  ; Launch the Playnite exe
  } Else {
    StartPlayniteFullScreen()
  }
}

Interval := 50
LongPressTargetTime := 750
LeftStickHoldTime := 0

Loop {
  If (State := XInput_GetState(0)) {

    ; Close the current app whenever Back, Start, LB and RB are pressed together
    ; Wait a couple of seconds to guard against closing multiple windows
    If (State.Buttons & State.Buttons = XINPUT_GAMEPAD_BACK + XINPUT_GAMEPAD_START + XINPUT_GAMEPAD_LEFT_SHOULDER + XINPUT_GAMEPAD_RIGHT_SHOULDER) {
      ; Disallow closing Playnite fullscreen
      If (!IsPlayniteActive()) {
        CloseCurrentWindow()
        Sleep, 2000
      } else {
        Sleep, Interval
      }
      Continue
    }

    ; Long press (L3): open or close Playnite upon long presses of L3
    if (State.Buttons & State.Buttons = XINPUT_GAMEPAD_LEFT_THUMB) {
      LeftStickHoldTime += Interval

    ; Short press (L3): Reset the timer and perform the desired short press action
    } else {
      if (LeftStickHoldTime != LongPressTargetTime & LeftStickHoldTime != 0) {
        ; Single press code goes here if needed
      }
      LeftStickHoldTime := 0
    }

    if (LeftStickHoldTime = LongPressTargetTime) {
      TogglePlayniteVisibility()
      LeftStickHoldTime := 0
    }

    Sleep, Interval
  }
}
