{
  pkgs,
  findModulesList,
  ...
}: {
  imports = findModulesList ./.;

  environment.systemPackages = with pkgs; [
    # keep-sorted start
    bat # cat
    difftastic # diff
    doggo # dig
    duf # df
    dust # du
    exiftool
    fd # find
    fzf
    glow
    hyperfine
    jq
    just # make
    moor # less
    p7zip
    pandoc
    procs # ps
    ripgrep # grep
    scooter # interactive find-and-replace
    sd # sed
    snitch # ss/netstat
    tectonic # for using as pandoc's pdf-engine
    trash-cli # rm
    # keep-sorted end
  ];

  hm = {
    # keep-sorted start block=yes newline_separated=yes
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
        "--smart-case" # case insensitive if pattern lowercase, otherwise case sensitive
      ];
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

    programs.zoxide = {
      enable = true;
      options = ["--cmd=f"];
    };
    # keep-sorted end
  };
}
