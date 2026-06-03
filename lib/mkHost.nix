{
  inputs,
  overlays,
  ...
}: {hostname}: let
  inherit (inputs.nixpkgs) lib;
  inherit (import ./findModules.nix lib) findModules findModulesList;
  myModules = findModules ../modules;
in
  lib.nixosSystem {
    specialArgs = {
      inherit inputs findModulesList myModules;
    };
    modules = [
      {
        networking.hostName = hostname;
        nixpkgs.overlays = overlays;
      }
      ../hosts/${hostname}
    ];
  }
