{
  inputs,
  overlays,
  ...
}:
/**
Create a NixOS system configuration for a specific host.

# Arguments

- [hostname] The hostname for the system configuration.

# Type

```
mkHost :: AttrSet -> AttrSet -> AttrSet
```
*/
{hostname}: let
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
