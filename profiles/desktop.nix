{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: let
  niriPkg = pkgs.unstable.niri;
  vicinaePkg = inputs.vicinae.packages.${pkgs.stdenv.hostPlatform.system}.default;
in {
  imports = [
    # keep-sorted start prefix_order=inputs
    inputs.dms.nixosModules.dank-material-shell
    ../config
    ../modules/base.nix
    ../modules/browser.nix
    ../modules/catppuccin.nix
    ../modules/cli.nix
    ../modules/espanso.nix
    ../modules/fonts.nix
    ../modules/git.nix
    ../modules/gui.nix
    ../modules/jj.nix
    ../modules/kanata.nix
    ../modules/nextdns.nix
    ../modules/podman.nix
    ../modules/printing.nix
    ../modules/scheduler.nix
    ../modules/scripts.nix
    ../modules/ssh-tpm-agent.nix
    ../modules/syncthing.nix
    ../modules/yubikey.nix
    ../modules/zram-swap.nix
    # keep-sorted end
  ];

  # ══════════ Compositor ══════════
  programs.niri = {
    enable = true;
    package = niriPkg;
  };

  # ══════════ Shell ══════════
  programs.dank-material-shell = {
    enable = true;
    systemd = {
      enable = true;
      restartIfChanged = true;
    };
    enableAudioWavelength = false;
    enableCalendarEvents = false;
    enableClipboardPaste = false;
  };

  # ══════════ Launcher ══════════
  users.users.${config.user}.extraGroups = ["input"];
  services.udev.extraRules = ''
    # Allows vicinae to create a virtual keyboard: required for paste support (the current user needs to be in the 'input' group)
    KERNEL=="uinput", GROUP="input", MODE="0660", RUN+="${pkgs.acl}/bin/setfacl -m g:input:rw /dev/$name"
  '';
  security.wrappers.vicinae-input-server = {
    source = "${vicinaePkg}/libexec/vicinae/vicinae-input-server";
    capabilities = "cap_dac_override+ep";
    owner = "root";
    group = "root";
  };

  # ══════════ Login Manager ══════════
  services.greetd = {
    enable = true;
    useTextGreeter = true;
    settings.default_session = {
      command = ''${lib.getExe pkgs.tuigreet} --remember --time --asterisks --cmd ${lib.getExe' niriPkg "niri-session"}'';
      user = "greeter";
    };
  };
  security.pam.services = {
    greetd.enableGnomeKeyring = true;
    login.enableGnomeKeyring = true;

    # Disable fingerprint auth for greetd; use password instead.
    # fprintd's PAM hook would otherwise stack `pam_fprintd.so sufficient` ahead of
    # pam_unix and the user sees a fingerprint scan request. If fingerprint is used at
    # login then keyring doesn't get unlocked automatically.
    greetd.fprintAuth = false;
  };

  # keep-sorted start block=yes newline_separated=yes prefix_order=security,environment,services,programs,home-manager
  security.polkit.enable = true;

  environment.sessionVariables = {
    # Ensure deadkeys work.
    GTK_IM_MODULE = "simple";

    # Use native Wayland when possible.
    ELECTRON_OZONE_PLATFORM_HINT = "auto"; # this should be enough for most Electron apps
    NIXOS_OZONE_WL = "1"; # apply wayland specific Nixpkgs flags

    # Niri
    XDG_CURRENT_DESKTOP = "niri";
    XDG_SESSION_TYPE = "wayland";
    QT_QPA_PLATFORM = "wayland";
    QT_QPA_PLATFORMTHEME = "gtk3";
    QT_QPA_PLATFORMTHEME_QT6 = "gtk3";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
  };

  environment.systemPackages = with pkgs; [
    adw-gtk3 # GTK theme
    adwaita-icon-theme
    apple-cursor
    vicinaePkg
    xwayland-satellite # for niri xwayland compatibility
  ];

  services = {
    # keep-sorted start
    flatpak.enable = true;
    fwupd.enable = true;
    gnome.sushi.enable = true; # for Nautilus quick preview
    gvfs.enable = true;
    power-profiles-daemon.enable = true;
    udisks2.enable = true; # auto-mounting disk
    upower.enable = true; # power management D-Bus
    # keep-sorted end
  };

  programs = {
    dconf.enable = true;
    gnome-disks.enable = true;
  };

  home-manager.users.${config.user} = {
    dconf.settings."org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "adw-gtk3-dark";
      icon-theme = "Adwaita";
    };
  };
  # keep-sorted end
}
