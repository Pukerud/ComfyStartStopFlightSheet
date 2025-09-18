#!/bin/bash

# This script is included by the agent, so we should not exit.

# --- Uptime Calculation ---
# Find the PID of the main running script
PID=$(pgrep -fo h-run.sh)
ELAPSED_SECONDS=0
if [ -n "$PID" ]; then
  # Get elapsed time in seconds
  ELAPSED_SECONDS=$(ps -p "$PID" -o etimes= | tr -d ' ')
fi

# --- Hashrate ---
# We don't have a real hashrate, so we'll report a dummy value.
DUMMY_KHS=1.0

# --- JSON Stats Payload ---
# Construct the JSON string that HiveOS expects.
STATS_JSON=$(cat <<EOF
{
  "hs": [$DUMMY_KHS],
  "hs_units": "khs",
  "uptime": $ELAPSED_SECONDS,
  "ver": "1.0"
}
EOF
)

# --- Set Required Variables ---
# These variables are read by the calling HiveOS agent script.
khs=$DUMMY_KHS
stats="$STATS_JSON"

# For debugging purposes, you can uncomment the following lines
# to see the output when running the script manually.
# echo "khs: $khs"
# echo "stats: $stats"
