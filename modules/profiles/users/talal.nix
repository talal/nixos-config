{
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
      ++ lib.optional config.networking.networkmanager.enable "networkmanager";
  };
}
