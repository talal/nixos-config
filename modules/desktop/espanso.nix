{
  config,
  pkgs,
  ...
}: {
  services.espanso = {
    enable = true;
    package = pkgs.espanso-wayland;
  };

  home-manager.users.${config.user} = {config, ...}: {
    xdg.configFile."espanso/config/default.yml".text = ''
      search_shortcut: 'off'
      show_notifications: false
    '';

    sops.secrets."espanso-matches.yaml" = {
      sopsFile = ../../secrets/espanso-matches.yaml;
      format = "yaml";
      key = "";
      path = "${config.home.homeDirectory}/.config/espanso/match/matches.yaml";
    };
  };
}
