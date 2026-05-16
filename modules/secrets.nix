{
  inputs,
  config,
  ...
}: let
  defaultSopsFile = ../secrets/secrets.yaml;
  defaultSopsFormat = "yaml";
in {
  imports = [inputs.sops-nix.nixosModules.sops];

  sops = {
    inherit defaultSopsFile defaultSopsFormat;
    age.keyFile = "/var/lib/sops-nix/key.txt"; # must have no password
  };

  home-manager.users.${config.user} = {config, ...}: {
    imports = [inputs.sops-nix.homeManagerModules.sops];

    sops = {
      inherit defaultSopsFile defaultSopsFormat;
      age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt"; # must have no password
    };
  };
}
