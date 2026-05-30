{
  inputs,
  lib,
  pkgs,
  pkgs-unstable,
  ...
}: let
  niriPkg = pkgs-unstable.niri;
in {
  imports = [
    # keep-sorted start prefix_order=inputs,./
    ./browser.nix
    ./fonts.nix
    ./ghostty.nix
    ./mpv.nix
    ./vicinae.nix
    # keep-sorted end
  ];

  # ══════════ Compositor ══════════
  programs.niri = {
    enable = true;
    package = niriPkg;
  };

  # ══════════ Login Manager ══════════
  services.greetd = {
    enable = true;
    useTextGreeter = true;
    settings.default_session = {
      user = "greeter";
      command = lib.concatStringsSep " " [
        "${lib.getExe pkgs.tuigreet}"
        "--time"
        "--remember"
        "--remember-user-session"
        "--asterisks"
        "--sessions"
        "${pkgs.niri}/share/wayland-sessions"
      ];
    };
  };
  security.pam.services = {
    greetd.enableGnomeKeyring = true;
    login.enableGnomeKeyring = true;

    # Disable fingerprint auth for greetd; use password instead.
    # fprintd's PAM hook would otherwise stack `pam_fprintd.so sufficient` ahead of
    # pam_unix and the user sees a fingerprint scan request. If fingerprint is used at
    # login then keyring doesn't get unlocked automatically.
    greetd.fprintAuth = false;
  };

  # keep-sorted start block=yes newline_separated=yes prefix_order=security,environment,services,programs,home-manager
  security.polkit.enable = true;

  environment.sessionVariables = {
    # Ensure deadkeys work.
    GTK_IM_MODULE = "simple";

    # Use native Wayland when possible.
    ELECTRON_OZONE_PLATFORM_HINT = "auto"; # this should be enough for most Electron apps
    NIXOS_OZONE_WL = "1"; # apply wayland specific Nixpkgs flags

    # Niri
    XDG_CURRENT_DESKTOP = "niri";
    XDG_SESSION_TYPE = "wayland";
    QT_QPA_PLATFORM = "wayland";
    QT_QPA_PLATFORMTHEME = "gtk3";
    QT_QPA_PLATFORMTHEME_QT6 = "gtk3";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
  };

  environment.systemPackages =
    (with pkgs-unstable; [
      # keep-sorted start
      bitwarden-desktop
      discord
      ente-desktop
      noctalia-shell
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
      xwayland-satellite # for niri xwayland compatibility
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

  hm = {config, ...}: let
    dotfilesDir = "${config.home.homeDirectory}/.dotfiles";
    mkSymlink = config.lib.file.mkOutOfStoreSymlink;
  in {
    # keep-sorted start block=yes newline_separated=yes prefix_order=home,xdg,dconf
    xdg.configFile = {
      "niri" = {
        source = mkSymlink "${dotfilesDir}/config/niri";
        recursive = true;
      };
      "zed" = {
        source = mkSymlink "${dotfilesDir}/config/zed";
        recursive = true;
      };
    };

    xdg.desktopEntries.browser-selector = {
      exec = "${pkgs.writeShellScriptBin "browser-selector" ''
        # Exit immediately if no URLs are passed
        if [ $# -eq 0 ]; then
          exit 0
        fi

        # Loop through all arguments (supports multi-link clicks)
        for url in "$@"; do
          if [ -n "$url" ]; then
            noctalia-shell ipc call plugin:browser-selector open "$url"
          fi
        done
      ''}/bin/browser-selector %U";
      genericName = "Browser selector";
      name = "browser-selector";
      type = "Application";
      terminal = false;
    };

    xdg.mimeApps = {
      enable = true;
      defaultApplicationPackages = with pkgs; [helix loupe mpv nautilus papers];
      defaultApplications = {
        "text/html" = "browser-selector.desktop";
        "text/markdown" = "org.gnome.TextEditor.desktop";
        "text/plain" = "org.gnome.TextEditor.desktop";
        "x-scheme-handler/ente" = "ente.desktop";
        "x-scheme-handler/http" = "browser-selector.desktop";
        "x-scheme-handler/https" = "browser-selector.desktop";
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
