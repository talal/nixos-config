{
  config,
  lib,
  ...
}: {
  security.tpm2.enable = true;
  users.users.${config.user}.extraGroups = ["tss"];

  services.gnome.gcr-ssh-agent.enable = lib.mkForce false;

  home-manager.users.${config.user} = {
    services.ssh-agent.enable = lib.mkForce false;
    services.ssh-tpm-agent.enable = true;
  };
}
