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
        "ctrl-z".command = "fg 2>/dev/null; commandline -f repaint"; # Helix suspend/resume
      };

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

        # git
        g = "git";
        ga = "git add";
        gac = "git add --all; and git commit -v";
        gc = "git commit -v";
        gcd = ''git add --all; and git commit -m "wip: $(date +%Y-%m-%d-%H%M%S)"'';
        gd = "git diff";
        gdf = "git df";
        gf = "git fetch; and git pull";
        gl = "git l";
        gp = "git push";
        gs = "git status --short --branch";
        gscope = "git config get user.email; and git config get user.signingKey";

        # jujutsu
        j = "jj";
        jb = "jj bookmark";
        jc = "jj commit";
        jcd = ''jj commit -m "wip: $(date +%Y-%m-%d-%H%M%S)"'';
        jd = "jj diff";
        jdf = "jj diff --tool difft";
        jf = "jj git fetch";
        jl = "jj log";
        jll = "jj log -r ..";
        jp = "jj git push";
        js = "jj status";
        jtp = "jj tug; and jj git push";
        jscope = "jj config get user.email; and jj config get signing.key";

        "'!!'" = {
          position = "anywhere";
          function = "histreplace";
        };
        "'!$'" = {
          position = "anywhere";
          function = "histreplace";
        };
        dotdot = {
          regex = "^\\.\\.+$";
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
  };
}
