{
  myModules,
  pkgs,
  ...
}: {
  imports = with myModules; [
    # keep-sorted start prefix_order=inputs,./
    ./hardware-configuration.nix
    profiles.audio
    profiles.bluetooth
    profiles.btrfs
    profiles.catppuccin
    profiles.core
    profiles.desktop
    profiles.dev
    profiles.kanata
    profiles.location
    profiles.nextdns
    profiles.printing
    profiles.scanner
    profiles.scheduler
    profiles.shell
    profiles.ssh-tpm-agent
    profiles.syncthing
    profiles.users.talal
    profiles.virtualisation.podman
    profiles.yubikey
    profiles.zram-swap
    # keep-sorted end
  ];

  # ══════════ Boot ══════════
  boot = {
    loader = {
      timeout = 1;
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
      };
      efi.canTouchEfiVariables = true;
    };
    consoleLogLevel = 0; # silence NixOS Stage 1 logs and jump straight into plymouth
    initrd = {
      verbose = false;
      systemd.enable = true;
    };
    plymouth.enable = true;
    # Reference: https://wiki.archlinux.org/title/Silent_boot
    kernelParams = [
      "quiet"
      "splash"
      "plymouth.use-simpledrm"
      "systemd.show_status=false"
      "rd.systemd.show_status=false"
      "udev.log_priority=3"
      "rd.udev.log_priority=3"
    ];
  };

  # ══════════ Performance ══════════
  # This ensures WiFi, Bluetooth, and CPU Microcode get the binary blobs they need.
  hardware.enableRedistributableFirmware = true;

  boot.tmp = {
    cleanOnBoot = true;
    useTmpfs = true;
  };

  # Use dbus-broker for better performance.
  services.dbus.implementation = "broker";

  # ══════════ Video ══════════
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # ══════════ Network ══════════
  networking = {
    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
    };
    useDHCP = false; # NetworkManager already does this
    wireless.iwd = {
      enable = true;
      settings = {
        General = {
          EnableNetworkConfiguration = false; # let NetworkManager handle DHCP/IP
          AddressRandomization = "network";
          AddressRandomizationRange = "full";
        };
      };
    };
  };

  # ══════════ Disk ══════════
  services.fstrim.enable = true;

  # ══════════ Input ══════════
  services.fprintd.enable = true; # fingerprint reader
  services.libinput.enable = true; # touchpad
  services.kanata = {
    enable = true;
    devices = ["/dev/input/by-path/platform-i8042-serio-0-event-kbd"]; # thinkpad keyboard
  };

  # ══════════ Power ══════════
  services.power-profiles-daemon.enable = true;
  services.upower = {
    enable = true; # power management D-Bus
    criticalPowerAction = "Suspend";
    allowRiskyCriticalPowerAction = true;
  };

  services.logind.settings.Login = {
    # We use niri's lid-close event instead.
    HandleLidSwitch = "ignore";
    HandleLidSwitchDocked = "ignore";
    HandleLidSwitchExternalPower = "ignore";

    HandlePowerKey = "suspend";
    HandlePowerKeyLongPress = "poweroff";
  };

  # Only run garbage collection on AC power. This can improve battery life.
  systemd.services.nix-gc.unitConfig.ConditionACPower = true;

  # Improve battery health by only charging when below 55% and stopping at 60%. This
  # results in roughly 3.7–3.9 V per cell which should give the best compromise for
  # long‑term life and minimal degradation.
  systemd.services.battery-charge-threshold = {
    description = "Set battery charge thresholds to maximize health";
    serviceConfig = {
      Type = "oneshot";
      Restart = "on-failure";
      RestartSec = "3s";
    };
    startLimitBurst = 5;
    script = ''
      echo 55 > /sys/class/power_supply/BAT0/charge_control_start_threshold
      echo 60 > /sys/class/power_supply/BAT0/charge_control_end_threshold
    '';
    wantedBy = ["multi-user.target"];
    after = ["multi-user.target"];
  };

  environment.systemPackages = with pkgs; [
    unstable.amd-debug-tools
  ];

  hm = {
    # Need the rocm variant otherwise GPU doesn't show.
    programs.btop.package = pkgs.btop-rocm;
  };

  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05";
}
