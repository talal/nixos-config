{
  inputs,
  pkgs,
  ...
}: let
  helixThemeSrc = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "helix";
    rev = "91e071bf9b9b2b8ae176a5581fcb61c789c55cab";
    hash = "sha256-F05ohJp7c9Pdnjq8+srfhAt1ogHjjBz50k1ftHOHGVg=";
  };
in {
  environment.variables = {
    FZF_DEFAULT_OPTS_FILE = "${pkgs.writeText "fzf-opts" ''
      --color=bg+:#363A4F,bg:#24273A,spinner:#F4DBD6,hl:#ED8796
      --color=fg:#CAD3F5,header:#ED8796,info:#C6A0F6,pointer:#F4DBD6
      --color=marker:#B7BDF8,fg+:#CAD3F5,prompt:#C6A0F6,hl+:#ED8796
      --color=selected-bg:#494D64
      --color=border:#6E738D,label:#CAD3F5
    ''}";
  };

  hm = {config, ...}: {
    imports = [inputs.catppuccin.homeModules.catppuccin];
    catppuccin = {
      enable = true; # enable globally
      flavor = "macchiato";
      accent = "lavender";

      bottom.enable = false; # IFD
      eza.enable = false; # IFD (can use term colors)
      firefox.enable = false; # IFD
      fzf.enable = false; # IFD
      gemini-cli.enable = false; # don't need (can use term colors)
      ghostty.enable = false; # uses built-in theme
      helix.enable = false; # installed manually (see below)
      mpv.enable = false; # don't need
      starship.enable = false; # IFD (can use term colors)
      zed.enable = false; # uses extension
      thunderbird.profile = "default";
    };

    xdg.configFile = {
      "helix/themes/catppuccin_${config.catppuccin.flavor}_upstream.toml".source = "${helixThemeSrc}/themes/default/catppuccin_${config.catppuccin.flavor}.toml";

      "helix/themes/catppuccin_${config.catppuccin.flavor}_transparent.toml".text = ''
        inherits = "catppuccin_${config.catppuccin.flavor}_upstream"
        "ui.background" = {}
      '';
    };

    programs.zathura.options = {
      # Tweak catpuccin theme for better readability.
      recolor = false;
      highlight-active-color = "rgba(245, 194, 231, 0.5)";
      highlight-color = "rgba(183, 189, 248, 0.5)";
      highlight-fg = "#24273a";
    };
  };
}
