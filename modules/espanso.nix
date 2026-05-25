{
  config,
  pkgs,
  ...
}: {
  services.espanso = {
    enable = true;
    package = pkgs.espanso-wayland;
  };

  hjem.users.${config.user} = {
    xdg.config.files."espanso/config/default.yml".text = ''
      search_shortcut: 'off'
      show_notifications: false
    '';
  };

  home-manager.users.${config.user} = {config, ...}: {
    sops.secrets."espanso-matches.yaml" = {
      sopsFile = ../secrets/espanso-matches.yaml;
      format = "yaml";
      key = "";
      path = "${config.home.homeDirectory}/.config/espanso/match/matches.yaml";
    };
  };
}
