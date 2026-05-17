{
  config,
  pkgs,
  ...
}: {
  home-manager.users.${config.user} = {config, ...}: {
    home.packages = with pkgs.unstable; [
      jujutsu
      jj-starship
      watchman # for jj fsmonitor
    ];

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
