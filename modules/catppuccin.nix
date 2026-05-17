{
  inputs,
  config,
  ...
}: {
  home-manager.users.${config.user} = {
    imports = [inputs.catppuccin.homeModules.catppuccin];

    catppuccin = {
      enable = true; # enable globally
      flavor = "macchiato";
      accent = "blue";
      eza.enable = false; # IFD
      ghostty.enable = false; # use built-in theme
      bottom.enable = false; # IFD
      mpv.enable = false; # don't like
      thunderbird.profile = "default";
    };

    home.sessionVariables = {
      # Reference: https://github.com/catppuccin/fzf/blob/main/themes/catppuccin-fzf-macchiato.sh
      FZF_DEFAULT_OPTS = "--color=bg+:#363A4F,bg:#24273A,spinner:#F4DBD6,hl:#ED8796,fg:#CAD3F5,header:#ED8796,info:#C6A0F6,pointer:#F4DBD6,marker:#B7BDF8,fg+:#CAD3F5,prompt:#C6A0F6,hl+:#ED8796,selected-bg:#494D64,border:#6E738D,label:#CAD3F5";
    };

    # Tweak catpuccin theme for better readability.
    programs.zathura.options = {
      recolor = false;
      highlight-active-color = "rgba(245, 194, 231, 0.5)";
      highlight-color = "rgba(183, 189, 248, 0.5)";
      highlight-fg = "#24273a";
    };
  };
}
