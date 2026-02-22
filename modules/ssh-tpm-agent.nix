{lib, ...}: {
  security.tpm2.enable = true;
  users.users.talal.extraGroups = ["tss"];

  services.gnome.gcr-ssh-agent.enable = lib.mkForce false;

  home-manager.users.talal = {
    services.ssh-agent.enable = lib.mkForce false;
    services.ssh-tpm-agent.enable = true;
  };
}
