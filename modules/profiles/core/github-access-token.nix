{config, ...}: {
  sops = {
    secrets.gh_pat = {};
    templates.access-token-prelude = {
      content = ''
        access-tokens = github.com=${config.sops.placeholder.gh_pat}
      '';

      # File must be accessible to all users because only the build daemon runs as root
      # and not nix evaluator itself.
      mode = "0444";
    };
  };

  nix.extraOptions = "!include ${config.sops.templates.access-token-prelude.path}";
}
