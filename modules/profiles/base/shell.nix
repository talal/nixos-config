{
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    # keep-sorted start
    bat #  cat
    difftastic # diff
    doggo # dig
    duf # df
    dust # du
    exiftool
    fd #  find
    fzf
    glow
    hyperfine
    jq
    just # make
    moor # less
    p7zip
    pandoc
    procs # ps
    ripgrep #  grep
    scooter # interactive find-and-replace
    sd # sed
    snitch # ss/netstat
    tectonic # for using as pandoc's pdf-engine
    trash-cli # rm
    # keep-sorted end
  ];

  hm = {
    # keep-sorted start block=yes newline_separated=yes prefix_order=home,sops
    home.shellAliases = {
      cdr = "cd $(git root)";
      cdtmp = "cd $(mktemp -d)";
      o = "xdg-open";
      zed = "zeditor";
      rm = "trash-put";
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

    programs.fish = {
      enable = true;
      preferAbbrs = true;

      binds."ctrl-z".command = "fg 2>/dev/null; commandline -f repaint"; # ctrl-z for suspend/resume

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

        # Define here instead of programs.fish.shellAbbrs so that $EDITOR expands as expected.
        abbr -a e "$EDITOR"
      '';

      shellAbbrs = {
        cat = "bat";
        cp = "cp -r";
        diff = "difft";
        mkdir = "mkdir -p";
        sc = "systemctl --user";
        shred = "shred --verbose --zero --remove --iterations 100";
        ssc = "sudo systemctl";

        # eza
        ls = "eza";
        ll = "eza --long --all";
        tree = ''eza --tree --all --ignore-glob=".git|.jj"'';
        tl = ''eza --tree --all --ignore-glob=".git|.jj" --level'';

        "'!!'" = {
          position = "anywhere";
          function = "histreplace";
        };
        "'!$'" = {
          position = "anywhere";
          function = "histreplace";
        };
        dotdot = {
          regex = "^\\\\.\\\\.+$";
          function = "multicd";
        };
      };

      functions = {
        histreplace = ''
          switch $argv[1]
              case '!!'
                  echo -- $history[1]
                  return 0
              case '!$'
                  echo -- $history[1] | read -lat tokens
                  echo -- $tokens[-1]
                  return 0
          end
          return 1
        '';
        multicd = ''
          echo cd (string repeat -n (math (string length -- $argv[1]) - 1) ../)
        '';
      };
    };

    programs.ripgrep = {
      enable = true;
      arguments = [
        "--glob=!.git" # exclude .git dir, this is needed because of --hidden
        "--glob=!.jj" # see comment above
        "--hidden" # search hidden files and directories
        "--hyperlink-format=file://{path}:{line}:{column}"
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
          "$nix_shell"
          "$direnv"
          "$python"
          "$docker_context"
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
        custom.vcs = {
          when = "jj-starship detect";
          shell = ["jj-starship" "--no-symbol" "--no-jj-prefix" "--no-git-prefix"];
          format = "$output ";
        };
        nix_shell.format = "[($name/)$state]($style) ";
        direnv.disabled = false;
        python.format = "[(py $virtualenv)](bold peach) ";
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
}
