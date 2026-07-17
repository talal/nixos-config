{pkgs, ...}: {
  environment.systemPackages = [pkgs.unstable.anki-bin];

  environment.sessionVariables = {
    # Reference: https://docs.ankiweb.net/platform/linux/wayland.html
    ANKI_WAYLAND = 1;
  };
}
