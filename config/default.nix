{config, ...}: {
  home-manager.users.${config.user} = {config, ...}: let
    dotfilesPath = "${config.home.homeDirectory}/.dotfiles/config";
    mkSymlink = config.lib.file.mkOutOfStoreSymlink;

    links = {
      "ghostty" = {recursive = true;};
      "helix" = {recursive = true;};
      "jj/config.toml" = {};
      "niri" = {recursive = true;};
      "zed" = {recursive = true;};
    };
  in {
    xdg.configFile =
      builtins.mapAttrs (
        name: value: {
          source = mkSymlink "${dotfilesPath}/${value.path or name}";
          recursive = value.recursive or false;
        }
      )
      links;
  };
}
