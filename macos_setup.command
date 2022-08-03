#!/usr/bin/env bash

cd "`dirname $0`"
mv ./scripts/ ./run_vsav_training.command /Applications/FightCade2.app/Contents/MacOS/emulator/fbneo
ln -s /Applications/FightCade2.app/Contents/MacOS/emulator/fbneo/run_vsav_training.command ~/Desktop/run_vsav_training.command
