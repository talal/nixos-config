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
      cachix
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
      pi
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
        ai.enable = false;
      };
    };

    programs.bash = {
      enable = true;
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
      # store direnv in cache and not per project
      # Reference: https://github.com/direnv/direnv/wiki/Customizing-cache-location#hashed-directories
      stdlib = ''
        : ''${XDG_CACHE_HOME:=$HOME/.cache}
        declare -A direnv_layout_dirs

        direnv_layout_dir() {
          echo "''${direnv_layout_dirs[$PWD]:=$(
            echo -n "$XDG_CACHE_HOME"/direnv/layouts/
            echo -n "$PWD" | sha1sum | cut -d ' ' -f 1
          )}"
        }
      '';
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

    programs.ripgrep = {
      enable = true;
      arguments = [
        "--glob=!.git" # exclude .git dir, this is needed because of --hidden
        "--glob=!.jj" # see comment above
        "--hidden" # search hidden files and directories
        "--hyperlink-format=file://{path}:{line}:{column}"
        "--max-columns-preview"
        "--max-columns=120"
        "--smart-case" # case insensitive if pattern lowercase, otherwise case sensitive
      ];
    };

    programs.starship = {
      enable = true;
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
          "$fill" # fill needed to push $shell to the right side of prompt line
          "$shell"
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
        custom.vcs = {
          when = "jj-starship detect";
          shell = ["jj-starship" "--no-symbol" "--no-jj-prefix" "--no-git-prefix"];
          format = "$output ";
        };
        python.format = "[(venv $virtualenv)](bold peach) ";
        fill.symbol = " ";
        shell = {
          disabled = false;
          format = " [$indicator](bold white)";
          bash_indicator = "bash";
          fish_indicator = "";
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

      keymap.mgr = {
        prepend_keymap = [
          {
            on = "f";
            run = "plugin jump-to-char";
            desc = "Jump to char";
          }
          {
            on = "l";
            run = "plugin smart-enter";
            desc = "Enter the child directory, or open the file";
          }
          {
            on = ["c" "m"];
            run = "plugin chmod";
            desc = "chmod on selected files";
          }
          {
            on = "<C-1>";
            run = "plugin toggle-pane max-parent";
            desc = "Maximize or restore the parent pane";
          }
          {
            on = "<C-2>";
            run = "plugin toggle-pane max-current";
            desc = "Maximize or restore the current pane";
          }
          {
            on = "<C-3>";
            run = "plugin toggle-pane max-preview";
            desc = "Maximize or restore the preview pane";
          }
        ];

        append_keymap = [
          {
            on = ["g" "."];
            run = "cd ~/.dotfiles";
            desc = "Go ~/.dotfiles";
          }
          {
            on = ["g" "r"];
            run = ''shell -- ya emit cd "$(git root)"'';
            desc = "cd back to the root of the current Git repository";
          }
        ];
      };
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
