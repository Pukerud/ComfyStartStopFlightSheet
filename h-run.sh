#!/bin/bash

# Get log file path from manifest
# The h-manifest.conf is sourced by the calling script, so its variables are available here.
LOG_FILE="$CUSTOM_LOG_BASENAME.log"
LOG_DIR=$(dirname "$LOG_FILE")
TARGET_USER="octa"

# Ensure log directory exists and is owned by the target user
mkdir -p "$LOG_DIR"
chown "$TARGET_USER:$TARGET_USER" "$LOG_DIR"

# --- Shutdown/Cleanup Function ---
# This function will be called by the trap command when the script receives a signal
cleanup() {
  echo "--- h-run.sh: Caught exit signal, running cleanup... ---"
  su "$TARGET_USER" -s /bin/bash -c "echo \"\$(date '+%Y-%m-%d %H:%M:%S') - h-run.sh received stop signal. Stopping comfyui...\" >> \"$LOG_FILE\""
  su "$TARGET_USER" -s /bin/bash -c "/home/octa/comfyui_unified_setup/scripts/stop_comfyui.sh"
  su "$TARGET_USER" -s /bin/bash -c "echo \"\$(date '+%Y-%m-%d %H:%M:%S') - comfyui stop command issued.\" >> \"$LOG_FILE\""
}

# --- Trap Exit Signals ---
# This ensures the cleanup function is called when HiveOS stops the miner
trap 'cleanup' SIGTERM SIGHUP SIGINT SIGQUIT EXIT

# --- Main Execution ---
echo "--- h-run.sh: Starting miner process... ---"
su "$TARGET_USER" -s /bin/bash -c "echo \"\$(date '+%Y-%m-%d %H:%M:%S') - h-run.sh starting comfyui...\" >> \"$LOG_FILE\""
su "$TARGET_USER" -s /bin/bash -c "/home/octa/comfyui_unified_setup/scripts/start_comfyui.sh &"

# --- Keep Script Alive ---
# This loop is required to keep the script running so HiveOS doesn't think it crashed.
# The actual miner process is running in the background.
while true
do
  sleep 5
done
