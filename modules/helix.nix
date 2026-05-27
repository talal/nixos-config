{pkgs, ...}: let
  themeSrc = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "helix";
    rev = "91e071bf9b9b2b8ae176a5581fcb61c789c55cab";
    hash = "sha256-F05ohJp7c9Pdnjq8+srfhAt1ogHjjBz50k1ftHOHGVg=";
  };
in {
  environment.systemPackages = [pkgs.helix];

  environment.variables = {
    EDITOR = "hx";
    VISUAL = "hx";
  };

  hm = {config, ...}: {
    xdg.configFile = {
      "helix/config.toml".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/config/helix/config.toml";
      "helix/languages.toml".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/config/helix/languages.toml";

      "helix/themes/catppuccin_macchiato_upstream.toml".source = "${themeSrc}/themes/default/catppuccin_macchiato.toml";

      "helix/themes/catppuccin_macchiato_transparent.toml".text = ''
        inherits = "catppuccin_macchiato_upstream"
        "ui.background" = {}
      '';
    };
  };
}
