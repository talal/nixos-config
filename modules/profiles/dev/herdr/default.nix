{pkgs, ...}: {
  environment.systemPackages = [
    pkgs.unstable.herdr
  ];

  hm = {config, ...}: {
    xdg.configFile."herdr/config.toml".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/modules/profiles/dev/herdr/config.toml";
  };
}
