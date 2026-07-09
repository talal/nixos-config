{pkgs, ...}: {
  hm = {
    home.packages = [
      (pkgs.writeShellScriptBin "zmx-select" (builtins.readFile ./zmx-select.bash))
    ];

    home.shellAliases = {
      z = "zmx-select";
    };
  };
}
