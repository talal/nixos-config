{
  inputs,
  pkgs,
  ...
}: {
  imports = [inputs.home-manager.nixosModules.home-manager];

  home-manager.users.talal = {
    imports = [inputs.catppuccin.homeModules.catppuccin];

    home.stateVersion = "25.05";

    home.username = "talal";
    home.homeDirectory = "/home/talal";

    home.sessionVariables = {
      # Reference: https://github.com/catppuccin/fzf/blob/main/themes/catppuccin-fzf-macchiato.sh
      FZF_DEFAULT_OPTS = "--color=bg+:#363A4F,bg:#24273A,spinner:#F4DBD6,hl:#ED8796,fg:#CAD3F5,header:#ED8796,info:#C6A0F6,pointer:#F4DBD6,marker:#B7BDF8,fg+:#CAD3F5,prompt:#C6A0F6,hl+:#ED8796,selected-bg:#494D64,border:#6E738D,label:#CAD3F5";
    };

    home.shellAliases = {
      cdr = "cd $(git root)";
      cdtmp = "cd $(mktemp -d)";
      o = "xdg-open";
      zed = "zeditor";

      # better alternatives
      cat = "bat";
      df = "duf";
      diff = "difft";
      du = "dust";
      less = "moor";
      rm = "trash-put";
      top = "btm";
    };

    catppuccin = {
      enable = true; # enable globally
      flavor = "macchiato";
      accent = "blue";
      eza.enable = false; # IFD
      ghostty.enable = false; # managed by stow
      imv.enable = false; # IFD
      bottom.enable = false; # IFD
      mpv.enable = false; # don't like
      starship.enable = false; # IFD
      thunderbird.profile = "default";
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
      defaultApplicationPackages = with pkgs; [helix imv mpv nautilus zathura];
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

    xdg.configFile."flox/flox.toml".text = ''
      disable_metrics = true
      set_prompt = false
    '';

    xdg.configFile."process-compose/settings.yaml".text = ''
      theme: Catppuccin Macchiato
      sort:
        by: NAME
        isReversed: false
      disable_exit_confirmation: false
    '';

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
      interactiveShellInit = ''
        # Disable fish greeting.
        set fish_greeting

        function starship_transient_prompt_func
          echo
          starship module character
        end

        # Don't set 'SHELL' var as that is meant to reflect the actual login shell itself.
        set -x FLOX_SHELL "fish"
      '';
      binds."ctrl-z".command = "fg 2>/dev/null; commandline -f repaint"; # Helix suspend/resume
    };

    programs.foot = {
      enable = true;
      settings = {
        main.pad = "6x0 center";
        main.font = "Maple Mono Normal NF:size=14";
        mouse.hide-when-typing = "yes";
        colors.alpha = 0.95;
      };
    };

    # Using module instead of home.packages so that systemd/dbus services
    # and shell integrations are set up automatically.
    programs.ghostty.enable = true;

    programs.imv = {
      enable = true;
      settings.options = {
        # Catppuccin Macchiato
        background = "24273a";
        overlay_text_color = "cad3f5";
        overlay_background_color = "181926";
      };
    };

    programs.mpv = {
      enable = true;
      scripts = with pkgs.mpvScripts; [mpris modernz thumbfast];
      scriptOpts = {
        thumbfast = {
          spawn_first = true;
          network = true;
          hwdec = true;
        };
        modernz = {
          hover_effect = "color";
          hover_effect_color = "#8aadf4";
          seekbarfg_color = "#8aadf4";
          seekbarbg_color = "#1e2030";
        };
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

    programs.zoxide = {
      enable = true;
      options = ["--cmd=f"];
    };
    # keep-sorted end
  };
}
