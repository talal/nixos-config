{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: {
  home-manager.users.${config.user} = {config, ...}: {
    home.shellAliases = {
      cdr = "cd $(git root)";
      cdtmp = "cd $(mktemp -d)";
      o = "xdg-open";
      zed = "zeditor";
      rm = "trash-put";
    };

    sops.secrets."ssh-config" = {
      sopsFile = ../secrets/ssh-config.yaml;
      format = "yaml";
      key = "config";
      path = "${config.home.homeDirectory}/.ssh/config";
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
        tab-width = inputs.home-manager.lib.hm.gvariant.mkUint32 4;
        use-system-font = false;
      };
    };

    xdg.mimeApps = let
      browser = "dms-open.desktop";
    in {
      enable = true;
      defaultApplicationPackages = with pkgs; [helix loupe mpv nautilus papers];
      defaultApplications = {
        "text/html" = browser;
        "text/markdown" = "org.gnome.TextEditor.desktop";
        "text/plain" = "org.gnome.TextEditor.desktop";
        "x-scheme-handler/ente" = "ente.desktop";
        "x-scheme-handler/http" = browser;
        "x-scheme-handler/https" = browser;
      };
    };

    xdg.terminal-exec = {
      enable = true;
      settings.default = [
        "com.mitchellh.ghostty.desktop"
        "foot.desktop"
      ];
    };

    # keep-sorted start block=yes newline_separated=yes prefix_order=services,programs
    services.syncthing.enable = true;

    programs.atuin = {
      enable = true;
      daemon.enable = true;
      flags = ["--disable-up-arrow"];
      settings = {
        update_check = false;
        enter_accept = false;
      };
    };

    programs.bash = {
      enable = true;
      initExtra = ''
        export PS1="\n\[\e[38;2;166;218;149m\]\u@\h\[\e[38;2;202;211;245m\] in \[\e[38;2;138;173;244m\]\w\n\[\e[90m\] \[\e[0m\]"
      '';
      shellAliases = {
        ".." = "cd ..";
        e = "hx";
        g = "git";
      };
    };

    programs.bat = {
      enable = true;
      config = {
        italic-text = "always";
        style = "plain";
      };
    };

    programs.bottom = {
      enable = true;
      settings.flags = {
        basic = true;
        hide_table_gap = true;
        process_memory_as_value = true;
      };
    };

    programs.btop = {
      enable = true;
      package = pkgs.btop-rocm; # need the rocm variant otherwise GPU doesn't show
      settings.theme_background = false;
    };

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      config = {
        load_dotenv = true;
        strict_env = true;
        warn_timeout = 0;
      };
    };

    programs.eza = {
      enable = true;
      enableBashIntegration = false;
      enableFishIntegration = false;
      icons = "auto";
      extraOptions = [
        "--group-directories-first"
        "--header"
        "--no-permissions"
        "--octal-permissions"
        "--smart-group" # only show group if different name from owner
      ];
    };

    programs.fd = {
      enable = true;
      hidden = true;
      ignores = [".git/" ".jj/" "*.bak"];
    };

    programs.fish = {
      enable = true;
      preferAbbrs = true;
      binds."ctrl-z".command = "fg 2>/dev/null; commandline -f repaint"; # Helix suspend/resume
      interactiveShellInit = ''
        # Disable fish greeting.
        set fish_greeting

        function starship_transient_prompt_func
          echo
          starship module character
        end

        # Use moor as pager.
        set -x MOOR "--quit-if-one-screen --no-linenumbers --wrap --statusbar=bold --terminal-fg"
        set -x PAGER "moor"
        set -x MANPAGER "sh -c 'col -bx | bat --language man --style plain'"
        set -x MANROFFOPT "-c"
      '';
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

    programs.ripgrep = {
      enable = true;
      arguments = [
        "--smart-case" # case insensitive if pattern lowercase, otherwise case sensitive
        "--hidden" # search hidden files and directories
        "--glob=!.git" # exclude .git dir, this is needed because of --hidden
        "--glob=!.jj" # see comment above
        "--hyperlink-format=zed://file/{path}:{line}:{column}"
      ];
    };

    programs.starship = {
      enable = true;
      enableBashIntegration = false;
      enableTransience = true;
      settings = {
        format = lib.concatStrings [
          "$username"
          "$hostname"
          "$shlvl"
          "$directory"
          "\${custom.vcs}"
          "$docker_context"
          "$direnv"
          "$python"
          "$sudo"
          "$cmd_duration"
          "$line_break"
          "$jobs"
          "$battery"
          "$os"
          "$container"
          "$character"
        ];
        character = {
          success_symbol = "[➜](bold green)";
          error_symbol = "[✗](bold red)";
        };
        cmd_duration.min_time = 120000;
        directory = {
          truncation_length = 8;
          style = "bold lavender";
        };
        direnv.disabled = false;
        python.format = "[(venv $virtualenv)](bold peach) ";
        custom.vcs = {
          when = "jj-starship detect";
          shell = ["jj-starship" "--no-symbol" "--no-jj-prefix" "--no-git-prefix"];
          format = "$output ";
        };
      };
    };

    programs.tealdeer = {
      enable = true;
      settings.updates.auto_update = true;
    };

    programs.television = {
      enable = true;
      settings = {
        shell_integration.channel_triggers = {
          dirs = ["cd" "tree" "ls" "ll" "eza"];
          env = ["export" "unset"];
          git-diff = ["git add" "git restore"];
          git-log = ["git log" "git show"];
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

    programs.yazi = {
      enable = true;
      shellWrapperName = "y";
      settings.mgr.show_hidden = true;
      plugins = with pkgs; {
        inherit (yaziPlugins) chmod full-border jump-to-char smart-enter toggle-pane;
        folder-rules = writeTextDir "main.lua" ''
          local function setup()
            ps.sub("cd", function()
              local cwd = cx.active.current.cwd
              if cwd:ends_with("Downloads") then
                ya.emit("sort", { "mtime", reverse = true, dir_first = false })
              else
                ya.emit("sort", { "alphabetical", reverse = false, dir_first = true })
              end
            end)
          end
          return { setup = setup }
        '';
      };
      initLua = ''
        require("full-border"):setup()
        require("folder-rules"):setup()
      '';
    };

    programs.yt-dlp = {
      enable = true;
      package = pkgs.unstable.yt-dlp;
      settings = {
        embed-metadata = true;
        sponsorblock-mark = "all";
        downloader = lib.getExe pkgs.aria2;
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

    programs.zoxide = {
      enable = true;
      options = ["--cmd=f"];
    };
    # keep-sorted end
  };
}
