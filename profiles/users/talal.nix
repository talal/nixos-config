{
  inputs,
  config,
  lib,
  ...
}: {
  sops.secrets.user_password.neededForUsers = true;

  # Set `config.user` which represents the primary user of the system.
  user = "talal";

  users.users.talal = {
    uid = 1000; # make uid predictable
    isNormalUser = true;
    description = "Muhammad Talal Anwar";
    hashedPasswordFile = config.sops.secrets.user_password.path;
    extraGroups =
      ["wheel"]
      ++ lib.optional config.networking.networkmanager.enable "networkmanager"
      # Some apps may need to adjust audio priority at runtime
      ++ lib.optional config.security.rtkit.enable "rtkit";
  };

  home-manager.users.talal = {
    imports = [inputs.sops-nix.homeManagerModules.sops];
    sops = {
      defaultSopsFile = inputs.self + "/secrets/secrets.yaml";
      defaultSopsFormat = "yaml";
      # The sops CLI has its own lookup rules and defaults to ~/.config/sops/age/keys.txt
      # therefore plural instead of singular 'key.txt' as filename.
      age.keyFile = "/home/talal/.config/sops/age/keys.txt"; # must have no password
    };
  };
}
