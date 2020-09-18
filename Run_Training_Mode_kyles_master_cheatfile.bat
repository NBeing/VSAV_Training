@echo off
echo STARTING Training Mode for VSAV
echo Make sure you have vsav.zip in the 'roms' folder
mame-rr.exe -cheat -pause_brightness 1 -window -maximize -antialias -filter -cheatpath cheat_kyle -lua "%~dp0scripts\vsav_training_master_script.lua" vsav
pause
