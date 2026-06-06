{
  inputs,
  pkgs,
  findModulesList,
  ...
}: {
  imports = findModulesList ./.;

  # keep-sorted start block=yes newline_separated=yes prefix_order=security,environment,services,programs,home-manager
  security.polkit.enable = true;

  environment.sessionVariables = {
    # Use native Wayland when possible.
    ELECTRON_OZONE_PLATFORM_HINT = "auto"; # this should be enough for most Electron apps
    NIXOS_OZONE_WL = "1"; # apply wayland specific Nixpkgs flags
  };

  environment.systemPackages =
    (with pkgs.unstable; [
      # keep-sorted start
      bitwarden-desktop
      discord
      ente-desktop
      obsidian
      proton-authenticator
      yaak
      zed-editor
      # keep-sorted end
    ])
    ++ (with pkgs; [
      # keep-sorted start
      adw-gtk3 # GTK theme
      adwaita-icon-theme
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

  services = {
    # keep-sorted start
    flatpak.enable = true;
    fwupd.enable = true;
    gnome.sushi.enable = true; # for Nautilus quick preview
    gvfs.enable = true;
    udisks2.enable = true; # auto-mounting disk
    # keep-sorted end
  };

  programs = {
    dconf.enable = true;
    gnome-disks.enable = true;

    # Allows to run unpatched dynamic binaries, e.g. those downloaded by cargo/rustup.
    # Without this, simple things like 'cargo run' might crash on missing libs.
    nix-ld.enable = true;
  };

  hm = {config, ...}: {
    # keep-sorted start block=yes newline_separated=yes prefix_order=home,xdg,dconf
    xdg.configFile = {
      "zed" = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/config/zed";
        recursive = true;
      };
    };

    xdg.mimeApps = {
      enable = true;
      defaultApplicationPackages = with pkgs; [helix loupe mpv nautilus papers];
      defaultApplications = {
        "text/markdown" = "org.gnome.TextEditor.desktop";
        "text/plain" = "org.gnome.TextEditor.desktop";
        "x-scheme-handler/ente" = "ente.desktop";
      };
    };

    xdg.terminal-exec = {
      enable = true;
      settings.default = [
        "com.mitchellh.ghostty.desktop"
        "foot.desktop"
      ];
    };

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        gtk-theme = "adw-gtk3-dark";
        icon-theme = "Adwaita";
      };

      "org/gnome/TextEditor" = {
        custom-font = "monospace 13";
        restore-session = false;
        show-line-numbers = true;
        tab-width = inputs.home-manager.lib.hm.gvariant.mkUint32 4;
        use-system-font = false;
      };
    };
    # keep-sorted end
  };
  # keep-sorted end
}
