#!/usr/bin/env bash
set -euo pipefail

flatpak run --command=sh com.fightcade.Fightcade -c "/app/fightcade/Fightcade/emulator/../../Resources/wine.sh /app/fightcade/Fightcade/emulator/fbneo/fcadefbneo.exe vsavj savestates/vsavj_fbneo.fs /var/data/scripts/vsav_training_master_script.lua"

