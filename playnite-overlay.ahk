#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.

#include %A_ScriptDir%\xinput.ahk

XInput_Init()

SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.

DetectHiddenWindows Off

; Video courtesy of https://www.reddit.com/r/playnite/comments/nhwafk/comment/gz2ov2j/?utm_source=share&utm_medium=web2x&context=3
; See https://mega.nz/folder/gkgSQTBT#0BhXiRZoKlIrqTXrCnX7vQ

SplashVideo := "C:\Users\alext\Games\Playnite\splash.mp4"
MpvExecutable := "C:\Program Files (x86)\MPV\mpv.exe"
PlayniteInstallDir := "C:\Users\alext\AppData\Local\Playnite"
EmulatorExecutables := ["DeSmuME_0.9.13_x64.exe", "Dolphin.exe", "duckstation-qt-x64-ReleaseLTCG.exe", "flycast.exe", "Mesen.exe", "mGBA.exe", "PPSSPPWindows64.exe", "Project64.exe", "redream.exe", "retroarch.exe", "snes9x-x64.exe"]

IsPlayniteRunning() {
  Process, Exist, Playnite.FullscreenApp.exe
  return ErrorLevel
}

IsPlayniteActive() {
  CurrentActiveHwnd := WinExist("A")
  return WinExist("Playnite") and !WinExist("Playnite Splash Screen") and CurrentActiveHwnd = WinActive("Playnite")
}

IsEmulatorRunning() {
  global EmulatorExecutables

  For _, Emulator In EmulatorExecutables {
    Process, Exist, %Emulator%
    if (ErrorLevel) {
      return 1
    }
  }
  return 0
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

CloseCurrentWindow() {
  SendInput, !{F4}
}

TogglePlayniteVisibility() {
  If (IsPlayniteRunning()) {
    If (IsPlayniteActive()) {
      HidePlaynite()
    } Else If (!IsEmulatorRunning()) {
      ShowPlaynite()
    }
  } Else {
    StartPlayniteFullScreen()
  }
}

Interval := 250
LongPressTargetTime := 750
ButtonHeldTime := 0

Loop {
  If (State := XInput_GetState(0)) {

    ; Close the current app whenever Back, Start, LB and RB are pressed together/
    ; Wait a couple of seconds to guard against closing multiple windows
    If (State.Buttons & State.Buttons = XINPUT_GAMEPAD_BACK + XINPUT_GAMEPAD_START + XINPUT_GAMEPAD_LEFT_SHOULDER + XINPUT_GAMEPAD_RIGHT_SHOULDER) {
      ; Disallow closing Playnite fullscreen
      If (!IsPlayniteActive()) {
        CloseCurrentWindow()
        Sleep, 2000
      }
    }

    ; Open or close Playnite upon long presses of L3
    if (State.Buttons & State.Buttons = XINPUT_GAMEPAD_LEFT_THUMB) {
      ButtonHeldTime += Interval
      Sleep, Interval
    } else {
      if (ButtonHeldTime != LongPressTargetTime & ButtonHeldTime != 0) {
        ; Single press code goes here if needed
      }
      ButtonHeldTime := 0
    }

    if (ButtonHeldTime = LongPressTargetTime) {
      TogglePlayniteVisibility()
      ButtonHeldTime := 0
      Sleep, Interval
    }
  }
}
