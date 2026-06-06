#!/usr/bin/env bash
set -euo pipefail

BAT_PATH="/sys/class/power_supply/BAT0"

print_current_thresholds() {
  echo "----------------------------------------"
  CURR_START=$(cat "$BAT_PATH/charge_control_start_threshold")
  CURR_END=$(cat "$BAT_PATH/charge_control_end_threshold")

  echo "Start threshold set to: $CURR_START%"
  echo "  End threshold set to: $CURR_END%"
  echo "----------------------------------------"
}

NAME=$(basename "$0")
if [ -z "${1:-}" ] || [ -z "${2:-}" ]; then
  echo "Error: missing arguments"
  echo "Usage: $NAME <start_threshold> <end_threshold>"
  echo "Example (Daily Use):  $NAME 55 60"
  echo "Example (Travel/Uni): $NAME 0 100"
  print_current_thresholds
  exit 1
fi

# The "Safety Dance" to make the script robust for all cases (going up or down),
# we must temporarily drop the Start threshold to 0 before applying the new values.
echo "Applying settings..."
echo "0" | sudo tee "$BAT_PATH/charge_control_start_threshold" > /dev/null
echo "$2" | sudo tee "$BAT_PATH/charge_control_end_threshold" > /dev/null
echo "$1" | sudo tee "$BAT_PATH/charge_control_start_threshold" > /dev/null

# Verification
print_current_thresholds
