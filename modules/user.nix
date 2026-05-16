{
  config,
  lib,
  ...
}: {
  users.users.${config.user} = {
    isNormalUser = true;
    uid = 1000; # make uid predictable
    home = "/home/${config.user}";
    initialPassword = "CHANGEME";
    extraGroups =
      ["wheel"]
      ++ lib.optional config.networking.networkmanager.enable "networkmanager"
      # Some apps may need to adjust audio priority at runtime.
      ++ lib.optional config.security.rtkit.enable "rtkit";
  };

  home-manager.users.${config.user} = {osConfig, ...}: {
    home.username = osConfig.user;
    home.homeDirectory = "/home/${osConfig.user}";
  };
}
