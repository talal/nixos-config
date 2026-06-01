{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    # keep-sorted start prefix_order=inputs,./
    ./browser.nix
    ./fonts.nix
    ./ghostty.nix
    ./greetd.nix
    ./mpv.nix
    ./niri.nix
    ./noctalia.nix
    ./vicinae.nix
    # keep-sorted end
  ];

  # keep-sorted start block=yes newline_separated=yes prefix_order=security,environment,services,programs,home-manager
  security.polkit.enable = true;

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
      (callPackage ../../../pkgs/losange {})
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
    power-profiles-daemon.enable = true;
    udisks2.enable = true; # auto-mounting disk
    upower.enable = true; # power management D-Bus
    # keep-sorted end
  };

  programs = {
    dconf.enable = true;
    gnome-disks.enable = true;
  };

  # Allows to run unpatched dynamic binaries, e.g. those downloaded by cargo/rustup.
  # Without this, simple things like 'cargo run' might crash on missing libs.
  programs.nix-ld.enable = true;

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

    programs.foot = {
      enable = true;
      settings = {
        main = {
          font = "TX\\-02:size=14, Symbols Nerd Font:size=14";
          underline-offset = 3;
          pad = "6x0 center";
        };
        mouse.hide-when-typing = "yes";
        colors-dark = {
          alpha = 0.90;
          blur = true;
        };
      };
    };

    programs.thunderbird = {
      enable = true;
      profiles.default = {
        isDefault = true;
        settings = {
          "app.update.auto" = false;
          "mail.shell.checkDefaultClient" = false;
          "mailnews.start_page.enabled" = false;
          "privacy.donottrackheader.enabled" = true;
        };
      };
    };

    programs.zathura = {
      enable = true;
      options = {
        adjust-open = "width";
        font = "monospace normal 12";
        incremental-search = true;
        scroll-full-overlap = 0.01;
        scroll-page-aware = true;
        scroll-step = 100;
        selection-notification = false;

        # Tweak catpuccin theme for better readability.
        recolor = false;
        highlight-active-color = "rgba(245, 194, 231, 0.5)";
        highlight-color = "rgba(183, 189, 248, 0.5)";
        highlight-fg = "#24273a";
      };
      mappings = {
        y = ''exec "sh -c 'wl-paste --primary | wl-copy'"'';
      };
    };
    # keep-sorted end
  };
  # keep-sorted end
}
