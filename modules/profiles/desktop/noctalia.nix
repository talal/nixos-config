{
  lib,
  pkgs,
  pkgs-unstable,
  ...
}: let
  noctaliaPkg = pkgs-unstable.noctalia-shell;
in {
  environment.systemPackages = [noctaliaPkg];

  systemd.user.services.noctalia = {
    description = "Noctalia Shell";
    wantedBy = ["graphical-session.target"];
    partOf = ["graphical-session.target"];
    after = ["graphical-session.target"];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${lib.getExe noctaliaPkg}";
      Restart = "always";
      RestartSec = 5;
      # Prevent systemd from killing child processes (apps launched by Noctalia) on restart.
      KillMode = "process";
    };
  };

  hm = {
    home.packages = [
      (pkgs.writeShellScriptBin "browser-selector" ''
        # Exit immediately if no URLs are passed
        if [ $# -eq 0 ]; then
          exit 0
        fi

        # Loop through all arguments (supports multi-link clicks)
        for url in "$@"; do
          if [ -n "$url" ]; then
            noctalia-shell ipc call plugin:browser-selector open "$url"
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
      enable = true;
      defaultApplications = lib.genAttrs [
        "text/html"
        "x-scheme-handler/http"
        "x-scheme-handler/https"
      ] (_: "browser-selector.desktop");
    };
  };
}
