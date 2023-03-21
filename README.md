# VSAV Training Mode - Fightcade 2 

## About
A training mode for VSAV. **You must supply your own ROM!** 

Shoutouts to: Dammit and Jed for their wizardry, Grouflon (Stole their 3s training mode menu, and settings workflow!) and the VSAV Community. 

BIGGEST SHOUTOUT to KyleW! This definitely would not have happened or continued without you.

 `N-Bee`

## Windows Installation 
Follow the video guide: https://www.youtube.com/watch?v=To7DpTNSRi8

What is described in the video guide: 
  1) Place `run_vsav_training.bat` file and the `scripts` folder in your `...\Fightcade\emulator\fbneo`
  3) IMPORTANT: The path where you installed fightcade 2 should not have a space in it: e.g. 
  Bad: `C:/fightcade 2/` Good: `C:/fightcade2`. Try to make sure the path is also not too deep.
  4) Double click `run_vsav_training.bat`
  5) Set up hotkeys in fbneo input  Input --> Map Game Inputs (Can map to controller):
    a) Lua Hotkey 1 - Opens training menu
    b) Lua Hotkey 4 - Return to CSS
    c) Volume Up - Record Dummy 
    d) Volume Down - Playback Dummy

##  Linux Installation
  1) Place  `run_vsav_training.sh` and `scripts` in your `...\Fightcade\emulator\fbneo`
  3) Run `./run_vsav_training.sh` in the terminal

##  MacOS installation

1) Place the `scripts` folder in `/Applications/FightCade2.app/Contents/MacOS/emulator/fbneo/`
2) Create a text document in your `/Applications/FightCade2.app/Contents/MacOS/emulator/fbneo/` titled `run_vsav_training.command`
3) In the `run_vsav_training.command` document you created, copy and paste the contents of the file `run_vsav_training.command`
5) double click on the `run_vsav_training.command`

## Rom Patch installion

1) Place the 'support' folder in your `...\Fightcade\emulator\fbneo`
3) Launch the training mode with the .bat file
4) Press `F6` or click the `Game` dropdown on the top bar then press `Load Game...`
5) Select `Vampire Savior - the lord of vampire (970519 Japan)` and in the bottom right corner select `IPS Manager`
6) Check the box for the patch you want and press `OK`
7) Check the `Apply Patch` button above the `IPS Manager` button you selected
8) Click `Play`
9) Once the game reloads you will be playing on the patched version
10) Close the emulator and relaunch to return to the normal version

Video Guide here https://youtu.be/HwyTAnbSw_I

### Debugging Installation Issues

  1) If you encounter `gd.dll` issue, reinstall Fightcade 2. `gd.dll` is part of Fightcade 2 and not my training mode. It seems to break on update occasionally.
  2) If you are having issues with the above, make sure to whitelist `fcadefbneo.exe` on windows defender or other AntiVirus
  3) If you are having weird input issues make sure p2 controls are bound!
  4) If the .bat script does not work it may be because your path has spaces or is too long. I cannot control this, this is part of FC2 FBneo lua. See step 3 for more info above.
  5) Reach out to me on the Vampire Savior Discord's #development channel! I will usually respond on the same day.
  

## Hotkeys
    Press Lua Hotkey 1 to open the training menu.
    Press Coin to swap controls to dummy
    Press Volume Down to play back recording. (found in 'map game inputs')
    Press Volume Up to record dummy. (found in 'map game inputs')
    Press Alt + 3 to toggle looping playback.
    Press Alt + 4 to return to character select

## Features
    In this version all features should be documented with description text within the training mode itself.
    Just press Lua Hotkey 1 and look through the menus.
