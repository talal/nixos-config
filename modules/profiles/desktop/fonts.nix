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
      # Prose
      # keep-sorted start
      atkinson-hyperlegible-mono
      atkinson-hyperlegible-next
      hanken-grotesk
      ibm-plex
      inter
      lato
      libertinus
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      # keep-sorted end

      # Code
      # keep-sorted start
      cascadia-code
      departure-mono
      iosevka
      iosevka-ss08
      iosevka-ss08.fixed
      iosevka-ss08.term
      jetbrains-mono
      nerd-fonts.symbols-only
      pragmata-pro
      tx-02
      tx-02.nf
      # keep-sorted end
    ];
  };
}
