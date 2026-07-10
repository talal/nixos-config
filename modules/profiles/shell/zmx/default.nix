{pkgs, ...}: {
  hm = {
    home.packages = [
      pkgs.unstable.zmx

      (pkgs.writeShellScriptBin "zmx-select" (builtins.readFile ./zmx-select.bash))
    ];

    home.shellAliases = {
      z = "zmx-select";
    };
  };
}
