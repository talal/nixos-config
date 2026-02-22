{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    # keep-sorted start prefix_order=inputs,./,../../
    ./hardware-configuration.nix
    ../../modules/base.nix
    ../../modules/browser.nix
    ../../modules/desktop.nix
    ../../modules/fonts.nix
    ../../modules/home.nix
    ../../modules/kanata.nix
    ../../modules/packages.nix
    ../../modules/podman.nix
    ../../modules/scheduler.nix
    ../../modules/scripts.nix
    ../../modules/ssh-tpm-agent.nix
    ../../modules/zram-swap.nix
    # keep-sorted end
  ];

  location.provider = "geoclue2";
  time.timeZone = "Europe/Berlin";

  i18n.defaultLocale = "en_GB.UTF-8";

  users.users.talal = {
    isNormalUser = true;
    uid = 1000; # make uid predictable
    description = "Muhammad Talal Anwar";
    initialPassword = "CHANGEME";
    extraGroups =
      ["wheel"]
      ++ lib.optional config.networking.networkmanager.enable "networkmanager"
      # Some apps may need to adjust audio priority at runtime
      ++ lib.optional config.security.rtkit.enable "rtkit";
  };
  nix.settings.trusted-users = ["talal"];

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
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_18; # new LTS

  # This ensures WiFi, Bluetooth, and CPU Microcode get the binary blobs they need.
  hardware.enableRedistributableFirmware = true;

  boot.tmp.useTmpfs = true;
  # Redirect heavy Nix builds to disk to avoid OOM crashes.
  systemd.services.nix-daemon.environment.TMPDIR = "/var/tmp";

  # Use dbus-broker for better performance.
  services.dbus.implementation = "broker";

  # ══════════ Video ══════════
  hardware.graphics.enable = true;

  # ══════════ Audio ══════════
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
  };

  # Allows Pipewire to use realtime scheduler for better performance.
  security.rtkit.enable = true;

  # ══════════ Network ══════════
  networking = {
    hostName = "thinkpad";

    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
    };
    useDHCP = false; # NetworkManager already does this

    wireless.iwd = {
      enable = true;
      settings.General.AddressRandomization = "network";
      settings.General.AddressRandomizationRange = "full";
    };

    # Reference: https://docs.syncthing.net/users/firewall.html#local-firewall
    firewall.allowedTCPPorts = [22000];
    firewall.allowedUDPPorts = [22000 21027];
  };
  systemd.network.wait-online.enable = false;
  systemd.services.NetworkManager-wait-online.enable = false;

  # DNS
  services.resolved.enable = true;
  networking.networkmanager.dns = "systemd-resolved";
  environment.etc."systemd/resolved.conf.d/nextdns.conf".source = ./nextdns.conf;

  # ══════════ Bluetooth ══════════
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };

  # ══════════ Disk ══════════
  services.btrfs.autoScrub.enable = true;
  services.fstrim.enable = true;

  # ══════════ Input ══════════
  services.fprintd.enable = true; # fingerprint reader
  services.libinput.enable = true; # touchpad

  # ══════════ Power ══════════
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true; # power management D-Bus

  # In my current setup, I use laptop as main display and external monitor as secondary so when
  # I close the lid, it means that I want laptop to suspend and external monitors to turn off.
  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    HandleLidSwitchDocked = "suspend";
    HandleLidSwitchExternalPower = "suspend";
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
    wantedBy = ["multi-user.target"];
    after = ["multi-user.target"];
    startLimitBurst = 5;
    serviceConfig = {
      Type = "oneshot";
      Restart = "on-failure";
    };
    script = ''
      echo 55 > /sys/class/power_supply/BAT0/charge_control_start_threshold
      echo 60 > /sys/class/power_supply/BAT0/charge_control_end_threshold
    '';
  };

  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05";
}
