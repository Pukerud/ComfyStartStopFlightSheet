#!/bin/bash
# --- DEBUGGING VERSION ---
echo "--- DEBUG: Script starting up. ---"

# Set variables
LOG_DIR="/home/octa/UltimatComfy"
LOG_FILE="$LOG_DIR/debugFlight"
TARGET_USER="octa"

echo "--- DEBUG: Variables set. ---"
echo "--- DEBUG: Log directory will be: $LOG_DIR"
echo "--- DEBUG: Target user is: $TARGET_USER"

# Check if user exists
echo "--- DEBUG: Checking if user '$TARGET_USER' exists... ---"
if id "$TARGET_USER" &>/dev/null; then
    echo "--- DEBUG: SUCCESS: User '$TARGET_USER' found. ---"
else
    echo "--- DEBUG: FATAL: User '$TARGET_USER' does not exist. Please create the user or change the script. ---"
    # Loop forever to prevent HiveOS from restarting the script too quickly
    while true; do sleep 10; done
fi

# Create directory
echo "--- DEBUG: Attempting to create directory $LOG_DIR... ---"
mkdir -p "$LOG_DIR"
MKDIR_EXIT_CODE=$?
if [ $MKDIR_EXIT_CODE -eq 0 ]; then
    echo "--- DEBUG: SUCCESS: mkdir command completed. ---"
else
    echo "--- DEBUG: FATAL: mkdir command failed with exit code $MK_DIR_EXIT_CODE. ---"
    while true; do sleep 10; done
fi

# Change ownership
echo "--- DEBUG: Attempting to change ownership of $LOG_DIR to $TARGET_USER... ---"
chown "$TARGET_USER:$TARGET_USER" "$LOG_DIR"
CHOWN_EXIT_CODE=$?
if [ $CHOWN_EXIT_CODE -eq 0 ]; then
    echo "--- DEBUG: SUCCESS: chown command completed. ---"
else
    echo "--- DEBUG: FATAL: chown command failed with exit code $CHOWN_EXIT_CODE. This often happens if the user does not exist. ---"
    while true; do sleep 10; done
fi

echo "--- DEBUG: Handing off to 'su' command... ---"
# Use su to switch to the 'octa' user and execute the commands
su "$TARGET_USER" -s /bin/bash <<'EOF'
# This block runs as the target user
echo "--- DEBUG (as user): Inside su block. ---"
LOG_FILE="/home/octa/UltimatComfy/debugFlight"
echo "--- DEBUG (as user): Attempting to write to log file $LOG_FILE... ---"
echo "$(date '+%Y-%m-%d %H:%M:%S') - Attempting to start comfyui..." >> "$LOG_FILE"
WRITE_EXIT_CODE=$?
if [ $WRITE_EXIT_CODE -eq 0 ]; then
    echo "--- DEBUG (as user): SUCCESS: Wrote to log file. ---"
else
    echo "--- DEBUG (as user): FATAL: Failed to write to log file with exit code $WRITE_EXIT_CODE. Check permissions. ---"
fi

/home/octa/comfyui_unified_setup/scripts/start_comfyui.sh &
echo "$(date '+%Y-%m-%d %H:%M:%S') - comfyui start command issued." >> "$LOG_FILE"
echo "--- DEBUG (as user): Hand-off to comfyui script complete. ---"
EOF
SU_EXIT_CODE=$?
if [ $SU_EXIT_CODE -eq 0 ]; then
    echo "--- DEBUG: SUCCESS: su command block completed. ---"
else
    echo "--- DEBUG: FATAL: su command block failed with exit code $SU_EXIT_CODE. ---"
fi


echo "--- DEBUG: Entering main HiveOS stats loop. ---"
# This infinite loop is required for HiveOS to keep the miner active.
while true
do
  STATS_JSON=$(cat <<EOF
{"hs":[1.0], "uptime":$((SECONDS/60)), "ver":"1.0"}
EOF
)
  echo $STATS_JSON
  sleep 10
done
