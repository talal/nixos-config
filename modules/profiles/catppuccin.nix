{inputs, ...}: {
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
      # foot       # uses Alabaster
      # fzf        # uses Alabaster
      # ghostty    # uses Alabaster
      # helix      # uses Alabaster
      # mpv        # don't need
      # starship   # IFD (can use term colors)
      # television # uses Alabaster
      # yazi       # uses Alabaster
      # zed        # uses Alabaster

      # keep-sorted start block=yes
      atuin.enable = true;
      bat.enable = true;
      thunderbird = {
        enable = true;
        profile = "default";
      };
      zathura.enable = true;
      # keep-sorted end
    };

    programs.zathura.options = {
      # Tweak catpuccin theme for better readability.
      recolor = false;
      highlight-active-color = "rgba(106, 159, 181, 0.65)";
      highlight-color = "rgba(244, 191, 117, 0.55)";
      highlight-fg = "#24273a";
    };
  };
}
