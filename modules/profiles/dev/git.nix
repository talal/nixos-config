{
  inputs,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    git
    git-cliff
    git-filter-repo
  ];

  hm = {config, ...}: {
    programs.fish.shellAbbrs = {
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
    };

    programs.delta = {
      enable = false;
      enableGitIntegration = true;
      options = {
        dark = true;
        line-numbers = true;
        navigate = true; # use n and N to move between diff sections
        hyperlinks = true;
        hyperlinks-file-link-format = "file://{path}:{line}";
      };
    };

    programs.gh.enable = true;

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
        # merge.conflictStyle = "zdiff3";
        gpg.format = "ssh";
        commit.gpgSign = true;
        tag.gpgSign = true;
        core.pager = "hunk pager";

        url."git@github-talal:".insteadOf = ["git@github.com:"];

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

      includes = [
        {path = "~/.config/git/scopes.gitconfig";}
      ];

      ignores = [
        "*.bak"
        "*.log*"
        "*.tmp*"
        ".cache/"
        ".DS_Store"
        ".stfolder/"
        "TODO.md"

        # AI
        ".agents/"
        ".antigravitycli/"
        ".claude/"
        ".gemini/"
        ".pi/"
        "AGENTS.md"
        "CLAUDE.md"
        "GEMINI.md"
        "llms.txt"

        # Dev Tools
        ".env*"
        ".direnv/"
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
    sops.secrets = let
      sopsFile = inputs.self + "/secrets/vcs.yaml";
    in {
      "git-scopes" = {
        inherit sopsFile;
        format = "yaml";
        key = "git-scopes";
        path = "${config.home.homeDirectory}/.config/git/scopes.gitconfig";
      };
      "git-gha-scope" = {
        inherit sopsFile;
        format = "yaml";
        key = "git-gha-scope";
        path = "${config.home.homeDirectory}/.config/git/gha.gitconfig";
      };
      "git-uni-scope" = {
        inherit sopsFile;
        format = "yaml";
        key = "git-uni-scope";
        path = "${config.home.homeDirectory}/.config/git/uni.gitconfig";
      };
    };
  };
}
