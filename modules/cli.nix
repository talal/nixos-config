{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: {
  # keep-sorted start block=yes newline_separated=yes prefix_order=environment,services,programs,home-manager
  environment.systemPackages =
    (with pkgs; [
      # keep-sorted start prefix_order=unstable
      unstable.snitch # TODO: not available in nixos-25.11 therefore using nixpkgs-unstable
      age
      bat
      choose
      difftastic
      doggo
      duf
      dust
      exiftool
      fd
      ffmpeg-full
      fzf
      glow
      helix
      hexyl
      hyperfine
      jq
      just
      moor
      p7zip
      pciutils
      poppler-utils # for yazi
      procs
      ripgrep
      scc
      scooter
      sd
      sops
      trash-cli
      tree
      usbutils
      watchexec
      wl-clipboard
      # keep-sorted end
    ])
    ++ (with pkgs.unstable; [
      # ══════════ Dev ═════════
      # NOTE: only install packages for common files (JSON, TOML, etc.) and scripts.
      # For everything else, use devenv.

      # keep-sorted start
      alejandra # nixfmt is yuck, alejandra is 👌
      bash-language-server
      devenv
      exercism
      just-lsp
      keep-sorted
      marksman # Markdown LSP
      mdformat
      nixd
      prettier # JSON formatting
      shellcheck
      shfmt
      superhtml
      taplo # TOML LSP
      tinymist
      treefmt
      typst # I use Typst alot so installing globally instead of devenv
      typstyle
      uv # for Python scripts
      vscode-css-languageserver
      vscode-json-languageserver
      yaml-language-server
      yamlfmt
      zizmor
      # keep-sorted end
    ])
    ++ (with inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}; [
      gemini-cli
    ]);

  home-manager.users.${config.user} = {config, ...}: {
    # keep-sorted start block=yes newline_separated=yes prefix_order=home,sops
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

    programs.zoxide = {
      enable = true;
      options = ["--cmd=f"];
    };
    # keep-sorted end
  };
  # keep-sorted end
}
