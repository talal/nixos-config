{
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [inputs.dms.nixosModules.dank-material-shell];

  security.polkit.enable = true;

  # Compositor
  programs.niri.enable = true;

  # Shell
  programs.dank-material-shell = {
    enable = true;
    systemd = {
      enable = true;
      restartIfChanged = true;
    };
  };

  # Login Manager
  services.greetd = let
    cmd = lib.getExe' pkgs.niri "niri-session";
  in {
    enable = true;
    useTextGreeter = true;
    settings = {
      default_session = {
        command = "${lib.getExe pkgs.tuigreet} --remember --time --asterisks --cmd ${cmd}";
        user = "greeter";
      };
      initial_session = {
        command = cmd;
        user = "talal";
      };
    };
  };

  # keep-sorted start block=yes newline_separated=yes prefix_order=services,programs,environment
  services = {
    # keep-sorted start
    flatpak.enable = true;
    fwupd.enable = true;
    gnome.sushi.enable = true; # for Nautilus quick preview
    gvfs.enable = true;
    pcscd.enable = true; # for YubiKeys
    udisks2.enable = true; # auto-mounting disk
    # keep-sorted end
  };

  services.espanso = {
    enable = true;
    package = pkgs.espanso-wayland;
  };

  programs = {
    dconf.enable = true;
    gnome-disks.enable = true;
  };

  environment.localBinInPath = true;

  environment.sessionVariables = {
    # Ensure deadkeys work.
    GTK_IM_MODULE = "simple";

    # Use native Wayland when possible.
    ELECTRON_OZONE_PLATFORM_HINT = "auto"; # this should be enough for most Electron apps
    NIXOS_OZONE_WL = "1"; # apply wayland specific Nixpkgs flags
  };

  environment.systemPackages = with pkgs; [
    # keep-sorted start prefix_order=unstable
    unstable.vicinae # TODO: switch to home-manager module after NixOS 26.05
    adw-gtk3 # GTK theme
    adwaita-icon-theme
    apple-cursor
    bibata-cursors
    xdg-utils
    xwayland-satellite # for niri xwayland compatibility
    # keep-sorted end
  ];
  # keep-sorted end
}
