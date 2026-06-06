{pkgs, ...}: {
  hm = {
    home.packages = with pkgs; [
      # keep-sorted start block=yes newline_separated=yes
      (writeShellScriptBin "doctor" (builtins.readFile ./doctor.sh))

      (writeShellScriptBin "flatpak-update" ''
        flatpak update -y
        flatpak uninstall -y --unused
      '')

      (writeShellScriptBin "jsonsort" ''
        set -euo pipefail
        tmpfile=$(mktemp --suffix=.json)
        jq -S . "$1" >"$tmpfile"
        mv "$tmpfile" "$1"
      '')

      (writeShellScriptBin "set-battery-thresholds" (builtins.readFile ./set-battery-thresholds.sh))
      # keep-sorted end
    ];
  };
}
