{lib, ...}: {
  security.tpm2.enable = true;
  users.users.talal.extraGroups = ["tss"];

  services.gnome.gcr-ssh-agent.enable = lib.mkForce false;

  hm = {
    services.ssh-agent.enable = lib.mkForce false;
    services.ssh-tpm-agent.enable = true;
  };
}
