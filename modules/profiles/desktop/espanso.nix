{
  inputs,
  pkgs,
  ...
}: {
  services.espanso = {
    enable = true;
    package = pkgs.espanso-wayland;
  };

  hm = {config, ...}: {
    xdg.configFile."espanso/config/default.yml".text = ''
      search_shortcut: 'off'
      show_notifications: false
    '';

    sops.secrets."espanso-matches.yaml" = {
      sopsFile = inputs.self + "/secrets/espanso-matches.yaml";
      format = "yaml";
      key = "";
      path = "${config.home.homeDirectory}/.config/espanso/match/matches.yaml";
    };
  };
}
