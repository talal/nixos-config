{
  inputs,
  lib,
  pkgs,
  ...
}: let
  niriPkg = pkgs.unstable.niri;

  # Reference: https://danklinux.com/docs/dankmaterialshell/overview#setting-default-web-browser
  # defaultBrowser = "dms-open.desktop";
  defaultBrowser = "brave-browser.desktop";
in {
  imports = [
    # keep-sorted start prefix_order=inputs
    ../modules/base.nix
    ../modules/browser.nix
    ../modules/catppuccin.nix
    ../modules/espanso.nix
    ../modules/fonts.nix
    ../modules/ghostty.nix
    ../modules/git.nix
    ../modules/helix.nix
    ../modules/jj.nix
    ../modules/mpv.nix
    ../modules/nextdns.nix
    ../modules/packages.nix
    ../modules/podman.nix
    ../modules/printing.nix
    ../modules/scheduler.nix
    ../modules/scripts.nix
    ../modules/shell.nix
    ../modules/ssh-tpm-agent.nix
    ../modules/syncthing.nix
    ../modules/vicinae.nix
    ../modules/yubikey.nix
    ../modules/zram-swap.nix
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

  environment.systemPackages = with pkgs; [
    # keep-sorted start prefix_order=unstable
    unstable.bitwarden-desktop
    unstable.discord
    unstable.dms-shell
    unstable.ente-desktop
    unstable.noctalia-shell
    unstable.obsidian
    unstable.proton-authenticator
    unstable.quickshell
    unstable.yaak
    unstable.zed-editor
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
  ];

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

  hm = {config, ...}: let
    dotfilesDir = "${config.home.homeDirectory}/.dotfiles";
    mkSymlink = config.lib.file.mkOutOfStoreSymlink;
  in {
    # keep-sorted start block=yes newline_separated=yes prefix_order=xdg,dconf
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

    xdg.mimeApps = {
      enable = true;
      defaultApplicationPackages = with pkgs; [helix loupe mpv nautilus papers];
      defaultApplications = {
        "text/html" = defaultBrowser;
        "text/markdown" = "org.gnome.TextEditor.desktop";
        "text/plain" = "org.gnome.TextEditor.desktop";
        "x-scheme-handler/ente" = "ente.desktop";
        "x-scheme-handler/http" = defaultBrowser;
        "x-scheme-handler/https" = defaultBrowser;
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
        colors = {
          alpha = 0.90;
          # blur = true; # TODO: enable when foot is updated to latest version
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
      };
      mappings = {
        y = ''exec "sh -c 'wl-paste --primary | wl-copy'"'';
      };
    };
    # keep-sorted end
  };
  # keep-sorted end
}
