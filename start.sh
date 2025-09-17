#!/bin/bash
LOG_DIR="/home/octa/UltimatComfy"
LOG_FILE="$LOG_DIR/debugFlight"

# This script is expected to run as root.
# It will create the log directory and then run the actual commands as user 'octa'.

# Create the directory as root, then change ownership to octa
mkdir -p "$LOG_DIR"
chown octa:octa "$LOG_DIR"

echo "--- Custom Script Miner: Starting ---"

# Use su to switch to the 'octa' user and execute the commands
su octa -s /bin/bash <<'EOF'
LOG_FILE="/home/octa/UltimatComfy/debugFlight"
echo "$(date '+%Y-%m-%d %H:%M:%S') - Attempting to start comfyui..." >> "$LOG_FILE"
/home/octa/comfyui_unified_setup/scripts/start_comfyui.sh &
echo "$(date '+%Y-%m-%d %H:%M:%S') - comfyui start command issued." >> "$LOG_FILE"
EOF

# This infinite loop is required for HiveOS to keep the miner active.
while true
do
  # --- Your custom logic can be placed here ---
  # echo "Script is running its task..."

  # --- This JSON block is mandatory for HiveOS stats ---
  # It reports a fake hashrate and uptime.
  STATS_JSON=$(cat <<EOF
{"hs":[1.0], "uptime":$((SECONDS/60)), "ver":"1.0"}
EOF
)
  # Print the JSON stats to the console for the HiveOS agent.
  echo $STATS_JSON

  # Wait for 10 seconds before the next loop.
  sleep 10
done
