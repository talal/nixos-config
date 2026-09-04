{pkgs, ...}: {
  environment.systemPackages = with pkgs.unstable; [
    (anki.withAddons [
      ankiAddons.anki-connect
      ankiAddons.review-heatmap
    ])
  ];

  environment.sessionVariables = {
    # Reference: https://docs.ankiweb.net/platform/linux/wayland.html
    ANKI_WAYLAND = 1;
  };
}
