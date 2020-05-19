Hello,

***You must supply your own VSAV rom!***

I have compiled all of the hard work done by our community to get 
close to a training mode in vampire savior in MAME.

I have done none of the work creating any of these scripts, 
they were made by people far more talented than myself and I am grateful
for their work. 

All I did was spend an afternoon modifying them so 
they would work well together, and extended their configurability.

====================================================
====================================================

Features enabled by default:
1) MacroLua recording/playback
2) Hitbox display (Toggleable)
3) Life regeneration (from Macrolua)
4) Scrolling Input / Everything from VSAVTraining with modular configuration.
5) Frame Data: Per their documentation: YOU MUST BE PLAYING ON NORMAL SPEED FOR THESE TO BE ACCURATE.
6) Cheats are accessible by pressing tab --> cheats.
   Note that infinite time should do nothing, and that life will regenerate.

====================================================
====================================================


====================================================
In order to use the script, first set up your hotkeys:
====================================================
1) Open MAME
2) Press tab
3) Go to Input(general) --> User Interface
4) Scroll down and find the section with Lua Custom Hotkeys
5) Set the hotkeys:
	Lua Custom Hotkey 1 - Playback recording
	Lua Custom Hotkey 2 - Replay recording
	Lua Custom Hotkey 3 - Toggle pause after playback (I find this useless)
	Lua Custom Hotkey 4 - Toggle looped playback
	Lua Custom Hotkey 5 - Toggle hitbox display

6) Hit escape. You should be at the main controls menu.
7) Set your usual controls. You will want to set controls for player two.
I like to use the keyboard, but you could also use another joystick.

====================================================
To Load the script:
====================================================
1) While in Mame use the command ctrl+l to open the Lua Script dialog 
2) Navigate to vsav_training_master_script.lua, click open
3) Click run
4) (optional) To stop the script locate the Lua Script window or press Ctrl+L again
   and click stop.

====================================================
To record the dummy:
====================================================
(optional) Toggle on hitboxes by pressing Lua Custom Hotkey 5
(optional) Make a save state through MAME.
1) Press Lua Custom Hotkey 2
2) Record some actions. If you want to record the dummy, use player 2's controls.
3) Press Lua Custom Hotkey 1 to playback.
4) If you wish to loop then toggle Lua Custom Hotkey 2
5) (optional) toggle off loop if enabled, load 

====================================================
====================================================
Tip: My preference is to set the playback, 
and load states to my unused buttons on my stick (i.e. VSAV uses 6 buttons but my stick has 8)
Loop toggle and load save state go to other buttons on the stick.
Record and save states are mapped to the dummy's pad.
====================================================
====================================================

====================================================
If you would like to save a recorded state:
====================================================
1) Go to the macro folder, go to last_recording.mis and rename it.
To load that playback you must read and understand the next section.


====================================================
====================================================
Configuration
====================================================
====================================================
These default options will serve you well -- you should not have to touch them.

However should you want to change them I have extended MacroLua's configuration file.
For instance: if you are experienced you might find the moves display annoying, or player position tedious.

To look upon them open macro-options in a text editor. 
DO NOT USE A WORD PROCESSOR. Use notepad, or notepad++.
Text editors will ruin the file.

====================================================
====================================================
====================================================
* IF YOU EVER MESS UP THE CONFIGURATION FILE
  LOOK IN THE SCRIPTS FOLDER. THERE IS A CLEAN BACKUP OF macro-options.lua
  COPY PASTE THIS INTO MAME-RR's ROOT DIRECTORY *
====================================================
====================================================
====================================================


====================================================
To use the modular configuration file
====================================================
1) Open macro-options.lua WITH NOTEPAD OR NOTEPAD++ OR A CODE EDITOR.
2) Locate the flag you would like to change.

For instance: As mentioned above you might want to load a particular playback file.
To do so locate the lines:

use_last_recording = true

Set this to false.
use_last_recording = false

Locate the line
playbackfile = "last_recording.mis"

Change it to:
playbackfile = "MyRecording.mis"

N.B. You can toggle use_last_recording back to true and the script should start using the last recording once loaded.
This is for convenience.

3) After you are done save the file. Reload the script. (Ctrl+L in MAME). Your new settings should be applied.

If you are going to be changing these often I recommend just leaving the macro-options.lua file open in another window.

====================================================
Hitbox configuration:
====================================================

hb_config_blank_screen         = false -- setting this to true will show ONLY the hitboxes
hb_config_draw_axis            = false -- This shows a pointer below your character
hb_config_draw_pushboxes       = true  -- Enables pushbox (your characters 'collision' box rather than hurtbox)
hb_config_draw_throwable_boxes = true  -- shows where you can be thrown
hb_config_no_alpha             = false -- removes overlay inside boxes if true