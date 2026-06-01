{
  inputs,
  overlays,
  ...
}: let
  lib = inputs.nixpkgs.lib;
  findModulesLib = import ./findModules.nix {inherit lib;};
  inherit (findModulesLib) findModules;
  myModules = findModules ../modules;
in
  {hostname}:
    lib.nixosSystem {
      specialArgs = {inherit inputs myModules;};
      modules = [
        {
          networking.hostName = hostname;
          nixpkgs.overlays = overlays;
        }
        ../hosts/${hostname}
      ];
    }
