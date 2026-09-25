{pkgs, ...}: {
  fonts = {
    fontDir.enable = true;

    fontconfig.defaultFonts = {
      sansSerif = ["Inter" "Noto Naskh Arabic"];
      serif = ["Noto Serif" "Noto Naskh Arabic"];
      monospace = ["IBM Plex Mono" "NoName Fixed" "Symbols Nerd Font"];
      emoji = ["Noto Color Emoji"];
    };

    fontconfig.localConf = ''
      <?xml version='1.0'?>
      <!DOCTYPE fontconfig SYSTEM 'urn:fontconfig:fonts.dtd'>
      <fontconfig>
        <alias binding="same">
          <family>termono</family>
          <prefer>
            <family>TX-02</family>
            <family>NoName Fixed Terminal</family>
            <family>Symbols Nerd Font</family>
          </prefer>
        </alias>
      </fontconfig>
    '';

    packages = with pkgs; [
      # Prose
      # keep-sorted start
      atkinson-hyperlegible-mono
      atkinson-hyperlegible-next
      hanken-grotesk
      ia-writer-duospace
      ia-writer-mono
      ia-writer-quattro
      ibm-plex
      inter
      libertinus
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      source-sans
      # keep-sorted end

      # Code
      # keep-sorted start
      cascadia-code
      iosevka
      iosevka-ss08
      iosevka-ss08.fixed
      iosevka-ss08.term
      jetbrains-mono
      kawkab-mono-font
      nerd-fonts.symbols-only
      noname-fixed
      tx-02
      tx-02.nf
      # keep-sorted end
    ];
  };
}
