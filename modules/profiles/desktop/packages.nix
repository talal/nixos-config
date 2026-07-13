{pkgs, ...}: {
  environment.systemPackages =
    (with pkgs.unstable; [
      # keep-sorted start
      # bitwarden-desktop # using Flatpak atm due to Electron EOL issues
      discord
      ente-desktop
      obsidian
      proton-authenticator
      remnote
      yaak
      # keep-sorted end
    ])
    ++ (with pkgs; [
      # keep-sorted start
      (callPackage ../../../pkgs/thymer.nix {})
      adw-gtk3 # GTK theme
      adwaita-icon-theme
      anki
      apple-cursor
      blanket
      czkawka
      gimp
      gnome-calculator
      gnome-obfuscate
      gnome-text-editor
      hunspell # for firefox, thunderbird, and libreoffice
      hunspellDicts.de_DE
      hunspellDicts.en_GB-ize
      keepassxc
      libreoffice-still
      loupe
      nautilus
      papers
      parabolic
      pdfarranger
      pika-backup
      resources
      wl-screenrec
      xdg-utils
      zeal
      # keep-sorted end
    ]);
}
