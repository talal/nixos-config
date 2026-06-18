{
  config,
  pkgs,
  ...
}: {
  hardware.sane.enable = true;
  users.users.${config.user}.extraGroups = ["scanner" "lp"];

  environment.systemPackages = [pkgs.simple-scan];
}
