{
  inputs,
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = [
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  # NOTE: We do not manage noctalia via systemd.user.services here.
  # Quickshell-based apps can have memory leaks causing systemd to trap them in a crash-loop.
  # This results in massive log dumps filling up the RAM disk (/run/user/...) and leaving orphaned processes.
  # Instead, noctalia is launched directly via niri's `spawn-at-startup`.

  hm = {
    xdg.configFile."noctalia/config.toml".source = ./config.toml;

    home.packages = [
      (pkgs.writeShellScriptBin "browser-selector" ''
        # Exit immediately if no URLs are passed
        if [ $# -eq 0 ]; then
          exit 0
        fi

        # Loop through all arguments (supports multi-link clicks)
        for url in "$@"; do
          if [ -n "$url" ]; then
            noctalia msg plugin talal/browser-selector:service all open "$url"
          fi
        done
      '')
    ];

    xdg.desktopEntries.browser-selector = {
      exec = "browser-selector %U";
      genericName = "Browser selector";
      name = "browser-selector";
      type = "Application";
      terminal = false;
    };

    xdg.mimeApps = {
      defaultApplications = lib.genAttrs [
        "text/html"
        "x-scheme-handler/http"
        "x-scheme-handler/https"
      ] (_: "browser-selector.desktop");
    };
  };
}
