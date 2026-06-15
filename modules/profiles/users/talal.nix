{
  config,
  lib,
  ...
}: {
  sops.secrets.user_password.neededForUsers = true;

  # Set `config.user` which represents the primary user of the system.
  user = "talal";

  users.users.talal = {
    description = "Muhammad Talal Anwar";
    isNormalUser = true;
    uid = 1000; # make uid predictable
    hashedPasswordFile = config.sops.secrets.user_password.path;
    extraGroups =
      ["wheel"]
      ++ lib.optional config.networking.networkmanager.enable "networkmanager";
  };
}
