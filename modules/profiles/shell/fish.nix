{
  hm = {
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
          set -l target (readlink -f $argv[1])
          rm -f $argv[1]
          cp $target $argv[1]
          chmod +w $argv[1]
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
        sc = "systemctl --user";
        shred = "shred --verbose --zero --remove --iterations 100";
        ssc = "sudo systemctl";

        # eza
        ls = "eza";
        ll = "eza --long --all";
        tree = ''eza --tree --all --ignore-glob=".git|.jj"'';
        tg = ''eza --tree --all --ignore-glob=".git|.jj" --git-ignore'';
        tl = ''eza --tree --all --ignore-glob=".git|.jj" --level'';
      };
    };
  };
}
