{
  hm = {
    programs.fish = {
      enable = true;
      preferAbbrs = true;

      interactiveShellInit = ''
        # Disable fish greeting.
        set fish_greeting

        fish_config theme choose alabaster-dark

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

      binds = {
        "alt-w".command = "fish_commandline_append \" | wl-copy\"";
        "ctrl-z".command = "fg 2>/dev/null; commandline -f repaint"; # suspend/resume
        "alt-comma".command = "history-token-search-forward"; # alt-. is history-token-search-backward
      };

      functions = {
        multicd = ''
          echo cd (string repeat -n (math (string length -- $argv[1]) - 1) ../)
        '';

        nedit = ''
          if test -L $argv[1]
            set -l target (readlink -f $argv[1])
            rm $argv[1]
            cp $target $argv[1]
            chmod +w $argv[1]
          end
          $EDITOR $argv[1]
        '';
      };

      shellAbbrs = {
        dotdot = {
          regex = ''^\.\.+$'';
          function = "multicd";
        };

        cp = "cp -r";
        diff = "difft";
        mkdir = "mkdir -p";
        o = "open";
        sc = "systemctl --user";
        shred = "shred --verbose --zero --remove --iterations 100";
        ssc = "sudo systemctl";
        t = "tuxedo";

        # eza
        ls = "eza";
        ll = "eza --long --all";
        tree = ''eza --tree --all --ignore-glob=".git|.jj"'';
        tl = ''eza --tree --all --ignore-glob=".git|.jj" --level'';
        tg = ''tree -a -I ".git|.jj" --gitignore'';
      };
    };

    xdg.configFile."fish/themes/alabaster-dark.theme".text = ''
      # name: 'Alabaster Dark'
      # https://github.com/tonsky/sublime-scheme-alabaster (original scheme)

      # preferred_background: 0e1415
      fish_color_normal cecece
      fish_color_command 71ade7
      fish_color_param cecece
      fish_color_keyword cecece
      fish_color_quote 95cb82
      fish_color_redirection 708b8d
      fish_color_end 708b8d
      fish_color_comment dfdf8e
      fish_color_error cc3333
      fish_color_gray 708b8d
      fish_color_selection --background=3d5457
      fish_color_search_match --background=3d5457
      fish_color_option cecece
      fish_color_operator 708b8d
      fish_color_escape cc8bc9
      fish_color_autosuggestion 708b8d
      fish_color_cancel cc3333
      fish_color_cwd cd974b
      fish_color_user 95cb82
      fish_color_host 71ade7
      fish_color_host_remote ec8013
      fish_color_status cc3333
      fish_pager_color_progress 708b8d
      fish_pager_color_prefix cd974b
      fish_pager_color_completion cecece
      fish_pager_color_description 708b8d
    '';
  };
}
