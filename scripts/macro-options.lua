--This file is intended to be run by macro.lua
--See macro-readme.html for help and instructions.

--You may adjust these parameters.

-------------------------------------------------
--VSAV training script options

-- for development purposes. It will make your logs noisy.
log_debug = true

-- Shows lifebar value and character positions
display_hud = false
-- Shows characters movelist
display_movelist = false
-- Display scrolling input
scrolling_input = true

-------------------------------------------------
--VSAV hitbox script options

-- Default for showing hitboxes can be toggled
display_hitbox_default = true

-- Configure what is displayed by the hitbox
-- Whether to use the below config or not, if false it will use the default which is pretty much everything enabled except blank screen and throw boxes
use_hb_config                  = false
-- Fine grained hitbox data  
hb_config_blank_screen         = false  -- setting this to true will show ONLY the hitboxes
hb_config_draw_axis            = false -- This shows a pointer below your character
hb_config_draw_pushboxes       = false -- Enables pushbox (your characters 'collision' box rather than hurtbox)
hb_config_draw_throwable_boxes = true -- shows where you can be thrown
hb_config_no_alpha             = false -- removes overlay inside boxes if true
------------------------------------------------------------
-- Enable frame data
mo_enable_frame_data = true
--------------------------------------------------------------------------------
mo_show_facing = true
-- File handling settings

-- name of the macro to be played
-- if you set this flag then you will automatically save the last recording as last_recording.mis
-- if you would like to save that recording then after recording go into the macro folder and copy that file and rename it
use_last_recording = true
-- you can load a saved recording by renaming this playbackfile to the macro file that you created (e.g. by renaming last_recording.mis in the instruction above)
playbackfile = "last_recording.mis"

-- where the macro scripts are saved to and loaded from
path = ".\\macro\\"

--------------------------------------------------------------------------------
-- Hotkey settings (These only apply if the emulator doesn't have Lua hotkeys.)

-- press to start playing the macro, or to cancel a playing macro
playkey = "semicolon"

-- press to start and stop recording a macro
recordkey = "numpad/"

-- press to turn on or off whether it should pause after a macro completes
togglepausekey = "quote"

-- press to turn loop mode on or off, or to switch between increasing, decreasing or no wait incrementation
toggleloopkey = "numpad+"

--------------------------------------------------------------------------------
-- Recording file output settings

-- minimum wait frames to be collapsed into Ws when recording
longwait = 4

-- minimum continuous keypress frames to be collapsed into holds when recording
longpress = 10

-- minimum characters in a line to be broken up when recording
longline = 60

--------------------------------------------------------------------------------
-- look out for and ignore frameMAME audio commands when parsing
-- (This only applies to FBA-rr and MAME-rr.)
framemame = true
