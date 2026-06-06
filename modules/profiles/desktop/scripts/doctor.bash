echo -e "\n🩺 \033[1mSystem Health Check\033[0m"

echo -e "\n🔹 \033[1mAMD P-State\033[0m"
if grep -q "active" /sys/devices/system/cpu/amd_pstate/status 2>/dev/null; then
  echo "✅ Status: Active"
else
  echo "❌ Status: Inactive (Check BIOS 'CPPC' or Kernel args)"
fi
echo -n "   Driver: " && cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_driver 2>/dev/null || echo "Unknown"
echo -n "   EPP Hint: " && cat /sys/devices/system/cpu/cpu0/cpufreq/energy_performance_preference 2>/dev/null || echo "N/A"

echo -e "\n🔹 \033[1mSCX Scheduler (bpfland)\033[0m"
if systemctl is-active --quiet scx; then
  echo "✅ Service: Active"
else
  echo "❌ Service: Inactive/Failed"
fi
echo -n "   Current Scheduler: " && cat /sys/kernel/sched_ext/root/ops 2>/dev/null || echo "None (Default Kernel Scheduler)"

echo -e "\n🔹 \033[1mZRAM (Compressed Swap)\033[0m"
if zramctl | grep -q "zram"; then
  echo "✅ Device: Active"
  zramctl
else
  echo "❌ Device: Not found"
fi

echo -e "\n🔹 \033[1mBattery Status (BAT0)\033[0m"
BAT_PATH="/sys/class/power_supply/BAT0"
if [ -d "$BAT_PATH" ]; then
  # Read raw values
  START=$(cat "$BAT_PATH/charge_control_start_threshold")
  END=$(cat "$BAT_PATH/charge_control_end_threshold")
  VOLT_NOW=$(cat "$BAT_PATH/voltage_now")
  E_FULL=$(cat "$BAT_PATH/energy_full")
  E_DESIGN=$(cat "$BAT_PATH/energy_full_design")
  CYCLES=$(cat "$BAT_PATH/cycle_count")

  # Math with awk
  VOLT_CELL=$(awk -v v="$VOLT_NOW" 'BEGIN {printf "%.2f", v / 1000000 / 3}')
  HEALTH=$(awk -v cur="$E_FULL" -v des="$E_DESIGN" 'BEGIN {printf "%.1f", (cur / des) * 100}')

  echo "✅ Device: Found"
  echo "   Thresholds: Start=${START}% / Stop=${END}%"
  echo "   Voltage:    ${VOLT_CELL}V per cell (3-cell avg)"
  echo "   Health:     ${HEALTH}% of design capacity"
  echo "   Cycles:     ${CYCLES}"
else
  echo "❌ Device: Not found (Is /sys/class/power_supply/BAT0 correct?)"
fi
echo ""
