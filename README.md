# Autohotkey scripts

## Launching Playnite via Xbox Guide button long presses

[![Video demo](https://user-images.githubusercontent.com/1131174/183254559-a46fd70c-c1b1-46f3-ae83-a78b6236622d.png)](https://www.youtube.com/watch?v=v1Kn70IqIzc)

Note: the script was written and tested on Windows 11. This should work in Windows 10 but I've personally not used or tested it there.

1. Install autohotkey v2: https://www.autohotkey.com/

2. Download the `playnite-overlay.ahk` script and the splash video (if you want that functionality) : https://github.com/alextiley/autohotkey-scripts/blob/master/splash.mp4 (or replace with another splash video).

3. If you want the splash video, install mpv somewhere (https://mpv.io/) and make a note of the install directory. If you don't want the video, you'll need to tweak the script and remove the splash video code (removing `StartPlayniteSplashScreen()` from line 63 should do it).

4. Edit the `playnite-overlay.ahk` file and change the three variables near the top to the correct paths for your system (`SplashVideo`, `MpvExecutable`, `PlayniteInstallDir`).

5. Double click the `playnite-overlay.ahk` to test. This will run autohotkey and add an icon to your notification area.

If it works, you can make this run at startup by adding it to your startup folder. See https://support.microsoft.com/en-us/windows/add-an-app-to-run-automatically-at-startup-in-windows-10-150da165-dcd9-7230-517b-cf3c295d89dd.

You'll also need to disable Xbox Game Bar from opening when pressing the guide button - the script above has handlers for short presses of the guide button and opens the game bar. It will likely break if this is also turned on in the game bar settings.
