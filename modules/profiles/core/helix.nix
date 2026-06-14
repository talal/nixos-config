{pkgs, ...}: {
  environment.systemPackages = [pkgs.helix];

  environment.variables = {
    EDITOR = "hx";
    VISUAL = "hx";
  };

  hm = {config, ...}: {
    xdg.configFile = {
      "helix/config.toml".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/config/helix/config.toml";
      "helix/languages.toml".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/config/helix/languages.toml";
    };
  };
}
