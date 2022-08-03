#!/usr/bin/env bash
set -euo pipefail

/Applications/FightCade2.app/Contents/Resources/wine/bin/wine64 /Applications/FightCade2.app/Contents/MacOS/emulator/fbneo/fcadefbneo.exe vsavj ./savestates/vsavj_fbneo.fs ./scripts/vsav_training_master_script.lua
