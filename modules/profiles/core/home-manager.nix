{
  inputs,
  lib,
  config,
  ...
}: {
  imports = [
    # Map `hm` to `home-manager.users.${config.user}` to simplify usage within modules.
    (lib.mkAliasOptionModule ["hm"] ["home-manager" "users" config.user])

    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    extraSpecialArgs.inputs = inputs; # pass inputs to home-manager
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "bak";

    users.${config.user} = {
      home.preferXdgDirectories = true;

      # Check before updating: https://nix-community.github.io/home-manager/release-notes.xhtml
      home.stateVersion = "26.05";
    };
  };
}
