{config, ...}: {
  home-manager.users.${config.user} = {config, ...}: {
    sops.secrets = {
      "jj-scopes" = {
        sopsFile = ../secrets/vcs.yaml;
        format = "yaml";
        key = "jj-scopes";
        path = "${config.home.homeDirectory}/.config/jj/conf.d/scopes.toml";
      };
    };
  };
}
