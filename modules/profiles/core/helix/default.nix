{pkgs, ...}: {
  environment.systemPackages = [pkgs.helix];

  environment.variables = {
    EDITOR = "hx";
    VISUAL = "hx";
  };

  hm = {config, ...}: {
    xdg.configFile."helix" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/modules/profiles/core/helix/config";
      recursive = true;
    };
  };
}
