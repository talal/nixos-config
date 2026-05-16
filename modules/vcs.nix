{config, ...}: {
  home-manager.users.${config.user} = {config, ...}: {
    programs.delta = {
      enable = true;
      enableGitIntegration = true;
      options = {
        dark = true;
        line-numbers = true;
        navigate = true; # use n and N to move between diff sections
        hyperlinks = true;
        hyperlinks-file-link-format = "zed://file/{path}:{line}";
      };
    };

    programs.git = {
      enable = true;
      settings = {
        user = {
          email = "noreply@talal.ch";
          name = "Muhammad Talal Anwar";
          useConfigOnly = true;
          signingKey = "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBAgOGxqO9vcaLDD3TYJBhMFAq2MEPfiIXXe0xNaeLjmBBYDzMS6D9ar1HqKHJsbjqFaRQbXJXZ6g7lkH5yNppFo=";
        };
        init.defaultBranch = "main";
        fetch.prune = true;
        push.autoSetupRemote = true;
        rebase.autoStash = true;
        merge.conflictStyle = "zdiff3";
        gpg.format = "ssh";
        commit.gpgSign = true;
        tag.gpgSign = true;
        url."git@github-talal:".insteadOf = ["git@github.com:" "https://github.com/"];
        alias = {
          l = "log --graph --abbrev-commit --pretty='%C(bold yellow)%h%C(reset) %C(green)(%cr)%C(reset)%C(bold red)%d%C(reset) %s %C(blue)<%an>%C(reset)'";

          current-branch = "rev-parse --abbrev-ref HEAD";
          find-commit = "!f() { git log --pretty=format:'%C(yellow)%h  %Cgreen%ad  %Creset%s%Cblue  <%cn> %Cred%d' --decorate --date=short -S$1; }; f";
          find-message = "!f() { git log --pretty=format:'%C(yellow)%h  %Cgreen%ad  %Creset%s%Cblue  <%cn> %Cred%d' --decorate --date=short --grep=$1; }; f";
          root = "rev-parse --show-toplevel";
          undo = "reset HEAD~1 --mixed";
          unstage = "reset HEAD --";

          # Reference: https://difftastic.wilfred.me.uk/git.html#regular-usage
          df = "-c diff.external=difft diff";
          dl = "-c diff.external=difft log -p --ext-diff";
          ds = "-c diff.external=difft show --ext-diff";
        };
        # NOTE: leave an empty line at the top of the template for our actual commit message.
        commit.template = builtins.toFile "commit-template.txt" ''

          # CONVENTIONAL COMMITS GUIDE
          # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
          # <type>[scope][!]: <imperative summary: if applied, this commit will...>
          #
          # [Optional body: explain what and why, not how]
          #
          # [Optional footer: breaking changes, refs #123]
          #
          # TYPES:
          #   feat      new feature
          #   fix       bug fix
          #   docs      documentation only changes
          #   refactor  code restructure (no behavior change)
          #   style     code formatting (no logic change)
          #   perf      performance improvement
          #   test      adding or updating tests (no production code)
          #   chore     maintenance tasks, deps, tooling
          #   build     build system, external dependencies (npm, make, cargo, ...)
          #   ci        CI/CD changes (GH actions, Jenkins, ...)
          #   revert    revert a commit
        '';
      };
      includes = [{path = "~/.config/git/scopes.gitconfig";}];
      ignores = [
        "*.bak"
        "*.log*"
        "*.tmp*"
        ".cache/"
        ".DS_Store"
        ".stfolder/"
        "TODO.md"
        # AI
        "AGENTS.md"
        "CLAUDE.md"
        "GEMINI.md"
        "llms.txt"
        # Dev Tools
        ".env*"
        "!.envrc"
        ".direnv"
        ".jj/"
        ".pre-commit-config.yaml"
        ".ruff_cache/"
        # Editors
        ".helix/"
        ".zed/"
        # Devenv
        ".devenv*"
        "devenv.local.nix"
        "devenv.local.yaml"
        # Nix
        ".Trash*"
        "result"
        "result-*"
      ];
    };

    # ══════════ Scopes ══════════
    sops.secrets = {
      "git-scopes" = {
        sopsFile = ../secrets/vcs.yaml;
        format = "yaml";
        key = "git-scopes";
        path = "${config.home.homeDirectory}/.config/git/scopes.gitconfig";
      };
      "git-gha-scope" = {
        sopsFile = ../secrets/vcs.yaml;
        format = "yaml";
        key = "git-gha-scope";
        path = "${config.home.homeDirectory}/.config/git/gha.gitconfig";
      };
      "git-uni-scope" = {
        sopsFile = ../secrets/vcs.yaml;
        format = "yaml";
        key = "git-uni-scope";
        path = "${config.home.homeDirectory}/.config/git/uni.gitconfig";
      };
      "jj-scopes" = {
        sopsFile = ../secrets/vcs.yaml;
        format = "yaml";
        key = "jj-scopes";
        path = "${config.home.homeDirectory}/.config/jj/conf.d/scopes.toml";
      };
    };
  };
}
