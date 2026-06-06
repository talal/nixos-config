{
  inputs,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs.unstable; [
    jujutsu
    jj-starship
    watchman # for jj fsmonitor
  ];

  hm = {config, ...}: {
    programs.fish.shellAbbrs = {
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
    };

    xdg.configFile."jj/config.toml".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/config/jj/config.toml";

    xdg.configFile."jj/conf.d/commit-template.toml".text = ''
      [templates]
      draft_commit_description = ''''
      concat(
        coalesce(description, default_commit_description, "\n"),
        surround(
          "\nJJ: This commit contains the following changes:\n", "",
          indent("JJ:     ", diff.stat(72)),
        ),
        indent("JJ: ", conventional_commits_guide),
      )
      ''''

      [template-aliases]
      conventional_commits_guide = ''''
      "
      CONVENTIONAL COMMITS GUIDE
      ━━━━━━━━━━━━━━━━━━━━━━━━━━
      <type>[scope][!]: <imperative summary: if applied, this commit will...>

      [Optional body: explain what and why, not how]

      [Optional footer: breaking changes, refs #123]

      TYPES:
        feat      new feature
        fix       bug fix
        docs      documentation only changes
        refactor  code restructure (no behavior change)
        style     code formatting (no logic change)
        perf      performance improvement
        test      adding or updating tests (no production code)
        chore     maintenance tasks, deps, tooling
        build     build system, external dependencies (npm, make, cargo, ...)
        ci        CI/CD changes (GH actions, Jenkins, ...)
        revert    revert a commit
      "
      ''''
    '';

    sops.secrets = {
      "jj-scopes" = {
        sopsFile = inputs.self + "/secrets/vcs.yaml";
        format = "yaml";
        key = "jj-scopes";
        path = "${config.home.homeDirectory}/.config/jj/conf.d/scopes.toml";
      };
    };
  };
}
