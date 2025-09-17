#!/bin/bash
echo "--- Custom Script Miner: Stop command received ---"
/home/octa/comfyui_unified_setup/scripts/stop_comfyui.sh
# This command finds the running start.sh process by its name and terminates it.
pkill -f start.sh

echo "--- Stop signal sent. ---"
