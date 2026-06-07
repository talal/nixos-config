{config, pkgs, ...}: {
  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };

  users.users.${config.user}.extraGroups = ["wireshark"];
}
