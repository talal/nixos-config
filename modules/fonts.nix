{pkgs, ...}: {
  fonts = {
    fontDir.enable = true;
    fontconfig.defaultFonts = {
      sansSerif = ["Inter" "Noto Naskh Arabic"];
      serif = ["Noto Serif" "Noto Naskh Arabic"];
      monospace = ["JetBrains Mono NL" "Symbols Nerd Font"];
      emoji = ["Noto Color Emoji"];
    };
    packages = with pkgs; [
      # keep-sorted start
      eb-garamond
      ibm-plex
      inter
      iosevka
      jetbrains-mono
      lato
      libertinus
      lilex # IBM Plex Mono with ligatures
      maple-mono.NF
      maple-mono.Normal-NF
      nerd-fonts.symbols-only
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      # keep-sorted end
    ];
  };
}
