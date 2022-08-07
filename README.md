# Autohotkey scripts

## Launching Playnite via L3 button long press

1. Install autohotkey v2: https://www.autohotkey.com/

2. Download the `playnite-overlay.ahk` script and the splash video (if you want that functionality) : https://github.com/alextiley/autohotkey-scripts/blob/master/splash.mp4 (or replace with another splash video).

3. If you want the splash video, install mpv somewhere (https://mpv.io/) and make a note of the install directory. If you don't want the video, you'll need to tweak the script and remove the splash video code (removing `StartPlayniteSplashScreen()` from line 63 should do it).

4. Edit the `playnite-overlay.ahk` file and change the variables near the top for your system (`SplashVideo`, `MpvExecutable`, `PlayniteInstallDir`, `EmulatorExecutables`).

5. Double click the `playnite-overlay.ahk` to test. This will run autohotkey and add an icon to your notification area.

If it works, you can make this run at startup by adding it to your startup folder. See https://support.microsoft.com/en-us/windows/add-an-app-to-run-automatically-at-startup-in-windows-10-150da165-dcd9-7230-517b-cf3c295d89dd.
