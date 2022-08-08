;--------------------------------------------------------------------------------------------------;
; Playnite: pre game script                                                                        ;
;--------------------------------------------------------------------------------------------------;
; This script records game start to an ini file so we can determine if a game is in progress       ;
; It should be started from Playnite whenever a game launches, via global script config            ;
;--------------------------------------------------------------------------------------------------;
; Directions for use:
;--------------------------------------------------------------------------------------------------;
; Add the following to Playnite > Settings > Scripts > Execute before starting a game:             ;
;                                                                                                  ;
; - Start-Process -FilePath "<path>\AutoHotkey.exe" -ArgumentList "<path>\playnite_pre_game.ahk"   ;
;--------------------------------------------------------------------------------------------------;

#SingleInstance force
#NoTrayIcon
#NoEnv
#Warn

IniWrite, 1, %A_ScriptDir%\playnite.ini, Playnite, IsGameRunning
