{
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [inputs.dms.nixosModules.dank-material-shell];

  security.polkit.enable = true;

  services.udev.extraRules = ''
    # Allows vicinae to create a virtual keyboard: required for paste support (the current user needs to be in the 'input' group)
    KERNEL=="uinput", GROUP="input", MODE="0660", RUN+="${pkgs.acl}/bin/setfacl -m g:input:rw /dev/$name"
  '';

  # Compositor
  programs.niri = {
    enable = true;
    package = pkgs.unstable.niri;
  };

  # Shell
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

  # Login Manager
  security.wrappers.vicinae-input-server = {
    source = "${vicinaePkg}/libexec/vicinae/vicinae-input-server";
    capabilities = "cap_dac_override+ep";
    owner = "root";
    group = "root";
  };
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
    udisks2.enable = true; # auto-mounting disk
    # keep-sorted end
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
    vicinaePkg
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
