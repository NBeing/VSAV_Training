# VSAV Training Mode

A training mode for VSAV. ** You must supply your own ROM! ** 

Shoutouts to: Dammit and Jed for their wizardry, Grouflon (Stole their 3s training mode menu, and settings workflow!) and the VSAV Community. 

BIGGEST SHOUTOUT to KyleW! This definitely would not have happened or continued without you.

I am truly building on the shoulders of giants.

I myself have added all of the VSAV specific features, along with many others.
This is a beta release. Many things do not work fully. I think many of the features are still useful in their incomplete state.
I have been using this training mode personally to great effect.

IF SOMETHING GOES WRONG JUST RESTART THE SCRIPT!
N.B. This version no longer relies on setting cheats. Many of them do not work, it is there to turn off the BG music. Apologies for any confusion.

- N-Bee

## Features enabled by default:
1) MacroLua recording/playback
2) Hitbox display (Toggleable)
3) Life regeneration (from Macrolua)
4) Scrolling Input / Everything from VSAVTraining with modular configuration.
5) Frame Data: Per their documentation: YOU MUST BE PLAYING ON NORMAL SPEED FOR THESE TO BE STABLE.
   Turbo 2 will give accurate results but frameskip makes the values fluctuate.

## In order to use the script, first set up your hotkeys:
1. Open MAME
2. Press tab
3. Go to Input(general) --> User Interface
4. Scroll down and find the section with Lua Custom Hotkeys
5. Set the hotkeys:
	Lua hotkey 1 opens up the training menu
	Lua hotkey 2 to swap controls to dummy
	Lua hotkey 3 to play back recording
	Lua hotkey 4 to record dummy.
	Lua hotkey 5 to toggle looping playback.

6. Hit escape. You should be at the main controls menu.

## RE: Controller Swap
This will allow you to control the dummy. **ONLY USE IT TO RECORD. IT WIL NOT WORK WITH OTHER OPTIONS**

## To Load the script:

Option 1: Double click "Run_Training_Mode.bat". This will open made and automagically load the script.

Option 2:
1) While in Mame use the command ctrl+l to open the Lua Script dialog 
2) Navigate to vsav_training_master_script.lua, click open
3) Click run
4) (optional) To stop the script locate the Lua Script window or press Ctrl+L again
   and click stop.

## To record the dummy:

(optional) Toggle on hitboxes by pressing Lua Custom Hotkey 5
(optional) Make a save state through MAME.
1. Press Lua Custom Hotkey 2
2. Record some actions. If you want to record the dummy, use player 2's controls.
3. Press Lua Custom Hotkey 1 to playback.
4. If you wish to loop then toggle Lua Custom Hotkey 2
5. (optional) toggle off loop if enabled, load 

**Tip** My preference is to set the playback, 
and load states to my unused buttons on my stick (i.e. VSAV uses 6 buttons but my stick has 8)
Loop toggle and load save state go to other buttons on the stick.
Record and save states are mapped to the dummy's pad.

## If you would like to save a recorded state:

1) Go to the macro folder, go to last_recording.mis and rename it.
To load that playback you must read and understand the next section.

## Training Mode Options

Hit Lua hotkey 1 to open the training menu. These settings are saved between launches!

### Pose

This makes player 2 hold a specific direction (e.g. down back, up forward etc)

### Guard
1. Block : The dummy will tap back upon attack, proxy guard will continue.
This is for the dummy when they are JUMPING or in NEUTRAL. Use "Down back" for blocking opponents.

**THIS FEATURE IS EXPERIMENTAL IT DOES NOT WORK WITH EVERY MOVE**
Generally moves with far travel do not work. Projectiles generally are blockable.
Use autoguard in these situations. 

Here is a short listof moves that do not work:

Wolf:
  Beast Cannon

Fish:
  Poison Gas
  HCF+P Super (The waves)
  Bubble (No block attempt, doesnt matter)

Morrigan: 
  Raging Demon

Bishamon
  Hold Back + F
  There are certain distances where projectiles will cause back dash 

Felicia
  Rolling Bucker
  DP + K

2. Auto Guard - This is VSAV's built in autoguard. From Kain: It *will* block unblockable setups (e.g. Bulleta's ) 

### Guard Action Type

All of these options need to have sister settings configured. These would be:

Guard Action Delay - Number of frames to delay performing the action (e.g. Push block after 3rd frame)
Keep in mind none of the actions are "pre buffered" before beginning to block. For instance GC's take 3 frames to input.

Guard action frequency: Simulate randomness 

1. Guard Cancel - Set "Guard Cancel Button" to P,K, PP or KK, along with Guard Action Frequency and Guard Action Delay
2. Push Block - Set which buttons the dummy will Push Block with.
3. Counter Attack - The dummy will press a button when recovering from block stun.
4. Reversal - *VERY EXPERIMENTAL* - The dummy will push a button when returning from wakeup 

### Wakeup

1. Towards
2. Away
3. Random (All) - Randmo chance for Towards, Away or None
4. Random (Left / Right Only)

## Configuration

These default options will serve you well -- you should not have to touch them.

However should you want to change them I have extended MacroLua's configuration file.
For instance: if you are experienced you might find the moves display annoying, or player position tedious.

To look upon them open macro-options in a text editor. 
DO NOT USE A WORD PROCESSOR. Use notepad, or notepad++.
Text editors will ruin the file.

# To use the modular configuration file

1. Open macro-options.lua WITH NOTEPAD OR NOTEPAD++ OR A CODE EDITOR.
2. Locate the flag you would like to change.

For instance: As mentioned above you might want to load a particular playback file.
To do so locate the lines:

use_last_recording = true

Set this to false.
use_last_recording = false

Locate the line
playbackfile = "last_recording.mis"

Change it to:
playbackfile = "MyRecording.mis"
`
N.B. You can toggle use_last_recording back to true and the script should start using the last recording once loaded.
This is for convenience.

3.  After you are done save the file. Reload the script. (Ctrl+L in MAME). Your new settings should be applied.

If you are going to be changing these often I recommend just leaving the macro-options.lua file open in another window.

## Hitbox configuration:

  hb_config_blank_screen         = false -- setting this to true will show ONLY the hitboxes

  hb_config_draw_axis            = false -- This shows a pointer below your character

  hb_config_draw_pushboxes       = true  -- Enables pushbox (your characters 'collision' box rather than hurtbox)

  hb_config_draw_throwable_boxes = true  -- shows where you can be thrown

  hb_config_no_alpha             = false -- removes overlay inside boxes if true
