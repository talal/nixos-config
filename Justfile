flake := justfile_directory()

alias rs := switch

[private]
default:
    @just --list

# sync dotfiles
[group('utils')]
[working-directory('config')]
stow:
    stow --target='{{ home_directory() }}/.ssh' ssh
    stow --target='{{ home_directory() }}/.config' --ignore=ssh .
    # TODO: temporary fix for GTK shenanigans
    echo '@import url("dank-colors.css");' > ~/.config/gtk-4.0/gtk.css

[private]
git-add:
    git -C {{ flake }} add --intent-to-add --all

[group('rebuild')]
[private]
builder goal prefix *args: git-add
    {{ prefix }} nixos-rebuild {{ goal }} \
      --flake {{ flake }} \
      {{ args }}

# test what happens when you switch
[group('rebuild')]
test *args: (builder "test" "" args)

# switch to the new system configuration
[group('rebuild')]
switch *args: (builder "switch" "sudo" args)

# update a set of given inputs
[group('dev')]
update *input:
    nix flake update {{ input }} \
      --option access-tokens "github.com=$(gh auth token)" \
      --refresh \
      --commit-lock-file \
      --commit-lockfile-summary "flake: update {{ if input == "" { "all inputs" } else { input } }}" \
      --flake {{ flake }}

# check the flake for errors
[group('dev')]
check *args: git-add
    nix flake check --option allow-import-from-derivation false {{ args }}

# clean the nix store and optimise it
[group('utils')]
clean:
    sudo nix-collect-garbage --delete-older-than 3d
    sudo nix store optimise

# check system health (AMD P-State, SCX, zram, battery)
[group('utils')]
doctor:
    #!/usr/bin/env bash
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

[group('utils')]
setup-flatpak:
    flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    flatpak remote-add --user --if-not-exists flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo
