# Autohotkey scripts

## Launching Playnite via L3 button long presses

[![Video demo](https://user-images.githubusercontent.com/1131174/183254559-a46fd70c-c1b1-46f3-ae83-a78b6236622d.png)](https://www.youtube.com/watch?v=v1Kn70IqIzc)

Note: the video above shows interaction via the guide button - this has now been changed to prevent interfering with the Xbox Game Bar and emulator overlays.

1. Install autohotkey v2: https://www.autohotkey.com/

2. Download this repository.

3. For the splash video, install mpv somewhere (https://mpv.io/) and make a note of the install directory. If you don't want the video, you'll need to tweak the script and remove the splash video code (removing the majority of `StartPlayniteFullScreen` except the run command).

4. Edit the `playnite_system_startup.ahk` file and change the variables near the top for your system (`SplashVideo`, `MpvExecutable`, `PlayniteInstallDir`).

5. Double click the `playnite_system_startup.ahk` to test. This will run autohotkey and add an icon to your notification area.

6. If it works, you can make this run at startup by creating a scheduled task in Windows, or by simply adding it to your startup folder. For the latter, see https://support.microsoft.com/en-us/windows/add-an-app-to-run-automatically-at-startup-in-windows-10-150da165-dcd9-7230-517b-cf3c295d89dd.

7. (Optional - recommended) This last step improves the user experience during gaming - if you hold the L3 button during a game (either by gaming or deliberately to show the full screen mode), the experience isn't that great - Playnite doesn't really do much in full screen mode while a game is active, and if anything can cause unexpected behaviour (such as breaking focus of emulated games). To tell the autohotkey script if a game is running or not, you'll need to configure a pre and post script in Playnite. Add the following to Playnite > Settings > Scripts > Execute before starting a game:

```
Start-Process -FilePath "<your-autohotkey-install-path>\AutoHotkey.exe" -ArgumentList "<autohotkey-script-path>\playnite_pre_game.ahk"
```

Then add the next snippet to Playnite > Settings > Scripts > Execute before exiting a game:

```
Start-Process -FilePath "<your-autohotkey-install-path>\AutoHotkey.exe" -ArgumentList "<autohotkey-script-path>\playnite_post_game.ahk"
```

## Ending a game session with LB, RB, Back and Start

At any time during gameplay, press LB + RB + Back + Start to close the currently active window.

### Disclaimer

This script was written and tested on Windows 11. This should work in Windows 10 but I've personally not used or tested it there.
