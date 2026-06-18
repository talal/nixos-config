{pkgs, ...}: {
  programs.niri = {
    enable = true;
    package = pkgs.unstable.niri;
  };

  environment.sessionVariables = {
    # Ensure deadkeys work.
    GTK_IM_MODULE = "simple";

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

    # Noctalia sometimes dies during suspend which leads to red screen therefore
    # installing hyprlock as a fallback lockscreen.
    # Reference: https://niri-wm.github.io/niri/FAQ.html#how-do-i-recover-from-a-dead-screen-locker-from-a-red-screen
    pkgs.hyprlock
  ];

  hm = {config, ...}: {
    xdg.configFile."niri" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/modules/profiles/desktop/niri/config";
      recursive = true;
    };
  };
}
