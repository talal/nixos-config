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
      # keep-sorted start prefix_order=nerd-fonts
      nerd-fonts.symbols-only
      cascadia-code
      ibm-plex
      inter
      iosevka
      jetbrains-mono
      libertinus
      lilex # better version of IBM Plex Mono
      maple-mono.NF
      maple-mono.Normal-NF
      noto-fonts
      noto-fonts-color-emoji
      # keep-sorted end
    ];
  };
}
