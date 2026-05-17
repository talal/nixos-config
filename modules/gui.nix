{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: let
  # Reference: https://danklinux.com/docs/dankmaterialshell/overview#setting-default-web-browser
  defaultBrowser = "dms-open.desktop";
in {
  # keep-sorted start block=yes newline_separated=yes prefix_order=environment,services,programs,home-manager
  environment.systemPackages = with pkgs; [
    # keep-sorted start prefix_order=unstable
    unstable.bitwarden-desktop
    unstable.discord
    unstable.ente-desktop
    unstable.obsidian
    unstable.yaak
    unstable.zed-editor
    blanket
    czkawka
    gimp
    gnome-calculator
    gnome-text-editor
    keepassxc
    libreoffice-still
    loupe
    nautilus
    papers
    parabolic
    pdfarranger
    pika-backup
    proton-authenticator
    resources
    signal-desktop
    zeal
    # keep-sorted end
  ];

  home-manager.users.${config.user} = _: {
    # keep-sorted start block=yes newline_separated=yes prefix_order=xdg,dconf
    # Using home-manager module instead of NixOS because of the convenience that
    # xdg.mimeApps.defaultApplicationPackages offers.
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

    dconf.settings."org/gnome/TextEditor" = {
      custom-font = "monospace 13";
      restore-session = false;
      tab-width = inputs.home-manager.lib.hm.gvariant.mkUint32 4;
      use-system-font = false;
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

    # Using module instead of home.packages so that systemd/dbus services
    # and shell integrations are set up automatically.
    programs.ghostty = {
      enable = true;
      package = pkgs.unstable.ghostty;
    };

    programs.mpv = {
      enable = true;
      config = {
        profile = "gpu-hq";
        gpu-context = "wayland";
        hwdec = "auto";
        vo = "gpu-next";
        ao = "pipewire";

        osc = false;
        hr-seek = true;
        keep-open = true;
        save-position-on-quit = true;
        save-watch-history = true;
        volume = 20;

        slang = "en,eng,de,deu,ger";
        alang = "ja,jp,jpn,de,deu,ger,en,eng"; # Onii-Chan!

        ytdl-format = "bestvideo[height<=?1080]+bestaudio/best";
        screenshot-dir = "~/Pictures/Screenshots/mpv";
      };
      scripts = with pkgs.mpvScripts; [mpris modernz thumbfast sponsorblock];
      scriptOpts = {
        thumbfast = {
          spawn_first = true;
          network = true;
          hwdec = true;
        };
        modernz = {
          window_top_bar = false;
          osc_on_start = true;
          showonpause = false;
          hover_effect = "color";
          hover_effect_color = "#8aadf4";
          seekbarfg_color = "#8aadf4";
          seekbarbg_color = "#1e2030";
        };
        ytdl_hook = {
          ytdl_path = "${lib.getExe pkgs.unstable.yt-dlp}";
        };
      };
      bindings = {
        UP = "add volume 2";
        DOWN = "add volume -2";
        "Alt+LEFT" = "seek -60";
        "Alt+RIGHT" = "seek 60";
        V = "cycle secondary-sub-visibility";
        "Ctrl+j" = "cycle secondary-sid";
        "Ctrl+J" = "cycle secondary-sid down";
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
