{pkgs, ...}: {
  fonts = {
    fontDir.enable = true;
    fontconfig.defaultFonts = {
      sansSerif = ["Inter" "Noto Naskh Arabic"];
      serif = ["Noto Serif" "Noto Naskh Arabic"];
      monospace = ["IBM Plex Mono" "Symbols Nerd Font"];
      emoji = ["Noto Color Emoji"];
    };
    packages = with pkgs; [
      # keep-sorted start
      atkinson-hyperlegible-next
      departure-mono
      ibm-plex
      inter
      iosevka
      jetbrains-mono
      lato
      libertinus
      lilex
      merriweather
      nerd-fonts.symbols-only
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      # keep-sorted end
    ];
  };
}
