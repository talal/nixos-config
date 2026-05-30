{
  inputs,
  pkgs-unstable,
  ...
}: let
  lib = inputs.nixpkgs.lib;
  findModulesLib = import ./findModules.nix {inherit lib;};
  inherit (findModulesLib) findModules;
  myModules = findModules ../modules;
in
  {hostname}:
    lib.nixosSystem {
      specialArgs = {
        inherit inputs pkgs-unstable myModules;
      };
      modules = [
        {networking.hostName = hostname;}
        ../hosts/${hostname}
      ];
    }
