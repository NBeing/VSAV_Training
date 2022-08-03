# VSAV Training Mode - Fightcade 2 

## About
A training mode for VSAV. ** You must supply your own ROM! ** 

Shoutouts to: Dammit and Jed for their wizardry, Grouflon (Stole their 3s training mode menu, and settings workflow!) and the VSAV Community. 

BIGGEST SHOUTOUT to KyleW! This definitely would not have happened or continued without you.

 `N-Bee`

## Windows Installation 
Follow the video guide: https://www.youtube.com/watch?v=To7DpTNSRi8

What is described in the video guide: 
  1) Place `run_vsav_training.bat` in your `yourfc2install\emulator\fbneo`
  2) Place the `scripts` folder adjacent to `fcadefbneo.exe` e.g.such that `fightcade\emulator\fbneo\scripts\vsav_training_master_script.lua` is a valid path.
  3) IMPORTANT: The path where you installed fightcade 2 should not have a space in it: e.g. 
  Bad: `C:/fightcade 2/` Good: `C:/fightcade2`. Try to make sure the path is also not too deep.
  4) Double click `run_vsav_training.bat` (windows)
  
##  Linux Installation
  1) Place  `run_vsav_training.sh` (linux) in your `yourfc2install\emulator\fbneo`
  2) Place the `scripts` folder adjacent to `fcadefbneo.exe` e.g.such that `fightcade\emulator\fbneo\scripts\vsav_training_master_script.lua` is a valid path.
  3) Run `./run_vsav_training.sh` in the terminal (linux) 

##  MacOS installation

1) run the `macos_setup.command` file by double clicking it in your finder
2) run the `run_vsav_training.command` file on your desktop by double clicking it

### Debugging Installation Issues

  1) If you encounter `gd.dll` issue, reinstall Fightcade 2. `gd.dll` is part of Fightcade 2 and not my training mode. It seems to break on update occasionally.
  2) If you are having issues with the above, make sure to whitelist `fcadefbneo.exe` on windows defender or other AntiVirus
  3) If you are having weird input issues make sure p2 controls are bound!
  4) If the .bat script does not work it may be because your path has spaces or is too long. I cannot control this, this is part of FC2 FBneo lua. See step 3 for more info above.
  5) Reach out to me on the Vampire Savior Discord's #development channel! I will usually respond on the same day.
 

## Hotkeys
    Press Start open the training menu.
    Press Coin to swap controls to dummy
    Press Volume Down to play back recording. (found in 'map game inputs')
    Press Volume Up to record dummy. (found in 'map game inputs')
    Press Alt + 3 to toggle looping playback.
    Press Alt + 4 to return to character select

## Features
    In this version all features should be documented with description text within the training mode itself.
    Just press start and look through the menus.
