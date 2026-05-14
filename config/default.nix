{
  home-manager.users.talal = {config, ...}: let
    dotfilesPath = "${config.home.homeDirectory}/.dotfiles/config";
    mkSymlink = config.lib.file.mkOutOfStoreSymlink;

    links = {
      "fish/conf.d/abbreviations.fish" = {};
      "ghostty" = {recursive = true;};
      "helix" = {recursive = true;};
      "jj/conf.d/commit-template.toml" = {};
      "jj/config.toml" = {};
      "niri" = {recursive = true;};
      "vicinae" = {recursive = true;};
      "yazi/keymap.toml" = {};
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
