;--------------------------------------------------------------------------------------------------;
; Playnite: post game script                                                                       ;
;--------------------------------------------------------------------------------------------------;
; This script records game end to an ini file so we can determine if a game is in progress         ;
; It should be started from Playnite whenever a game launches, via global script config            ;
;--------------------------------------------------------------------------------------------------;
; Directions for use:
;--------------------------------------------------------------------------------------------------;
; Add the following to Playnite > Settings > Scripts > Execute before exiting a game:              ;
;                                                                                                  ;
; - Start-Process -FilePath "<path>\AutoHotkey.exe" -ArgumentList "<path>\playnite_post_game.ahk"  ;
;--------------------------------------------------------------------------------------------------;

#SingleInstance force
#NoTrayIcon
#NoEnv
#Warn

IniWrite, 0, %A_ScriptDir%\playnite.ini, Playnite, IsGameRunning
