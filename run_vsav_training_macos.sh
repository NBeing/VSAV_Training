#!/usr/bin/env bash
set -euo pipefail

parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd "$parent_path"
../..//../Resources/wine/bin/wine64 ./fcadefbneo.exe vsavj ./savestates/vsavj_fbneo.fs ./scripts/vsav_training_master_script.lua
