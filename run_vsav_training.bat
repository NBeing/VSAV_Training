@echo off
echo STARTING Training Mode for VSAV
echo Make sure you have vsavj.zip in the 'roms' folder
start fcadefbneo.exe  vsavj savestates\vsavj_fbneo.fs %cd%\scripts\vsav_training_master_script.lua
exit