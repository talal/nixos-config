{
  config,
  lib,
  ...
}: {
  # This variable will become available in global NixOS config as `config.user`.
  user = "talal";

  users.users.talal = {
    isNormalUser = true;
    uid = 1000; # make uid predictable
    home = "/home/talal";
    initialPassword = "CHANGEME";
    extraGroups =
      ["wheel"]
      ++ lib.optional config.networking.networkmanager.enable "networkmanager"
      # Some apps may need to adjust audio priority at runtime.
      ++ lib.optional config.security.rtkit.enable "rtkit";
  };

  home-manager.users.talal = {
    home.username = "talal";
    home.homeDirectory = "/home/talal";
  };
}
