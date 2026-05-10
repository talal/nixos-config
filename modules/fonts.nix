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
      ibm-plex
      inter
      iosevka
      jetbrains-mono
      lato
      libertinus
      maple-mono.NF
      maple-mono.Normal-NF
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
