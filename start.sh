#!/bin/bash
echo "--- Custom Script Miner: Starting ---"
/home/octa/comfyui_unified_setup/scripts/start_comfyui.sh &
# This infinite loop is required for HiveOS to keep the miner active.
while true
do
  # --- Your custom logic can be placed here ---
  echo "Script is running its task..."

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
