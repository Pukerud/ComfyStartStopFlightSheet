#!/bin/bash
LOG_DIR="/home/octa/UltimatComfy"
LOG_FILE="$LOG_DIR/debugFlight"

# This script is expected to run as root.

echo "--- Custom Script Miner: Stop command received ---"

# Use su to switch to the 'octa' user and execute the commands
su octa -s /bin/bash <<'EOF'
LOG_FILE="/home/octa/UltimatComfy/debugFlight"
echo "$(date '+%Y-%m-%d %H:%M:%S') - Attempting to stop comfyui..." >> "$LOG_FILE"
/home/octa/comfyui_unified_setup/scripts/stop_comfyui.sh
echo "$(date '+%Y-%m-%d %H:%M:%S') - comfyui stop command issued." >> "$LOG_FILE"
EOF

# This command finds the running start.sh process by its name and terminates it.
pkill -f start.sh

echo "--- Stop signal sent. ---"
