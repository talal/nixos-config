{pkgs, ...}: {
  programs.niri = {
    enable = true;
    package = pkgs.unstable.niri;
  };

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

  environment.systemPackages = [
    pkgs.unstable.xwayland-satellite
  ];

  hm = {config, ...}: {
    xdg.configFile."niri" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/config/niri";
      recursive = true;
    };
  };
}
