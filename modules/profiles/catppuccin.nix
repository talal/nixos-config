{
  inputs,
  pkgs,
  ...
}: {
  environment.variables = {
    FZF_DEFAULT_OPTS_FILE = "${pkgs.writeText "fzf-opts" ''
      --color=bg+:#363A4F,bg:#24273A,spinner:#F4DBD6,hl:#ED8796
      --color=fg:#CAD3F5,header:#ED8796,info:#C6A0F6,pointer:#F4DBD6
      --color=marker:#B7BDF8,fg+:#CAD3F5,prompt:#C6A0F6,hl+:#ED8796
      --color=selected-bg:#494D64
      --color=border:#6E738D,label:#CAD3F5
    ''}";
  };

  hm = {
    imports = [inputs.catppuccin.homeModules.catppuccin];
    catppuccin = {
      flavor = "macchiato";
      accent = "lavender";

      # Modules for following programs are available but explicitly disabled:
      # bottom     # IFD
      # eza        # IFD (can use term colors)
      # firefox    # IFD
      # fish       # uses Alabaster
      # fzf        # IFD
      # ghostty    # uses Alabaster
      # helix      # installed manually (see below)
      # mpv        # don't need
      # starship   # IFD (can use term colors)
      # television # don't need
      # zed        # uses Alabaster

      # keep-sorted start block=yes
      atuin.enable = true;
      bat.enable = true;
      foot.enable = true;
      thunderbird = {
        enable = true;
        profile = "default";
      };
      yazi.enable = true;
      zathura.enable = true;
      # keep-sorted end
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
