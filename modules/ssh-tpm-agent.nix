{lib, ...}: {
  security.tpm2.enable = true;
  users.users.talal.extraGroups = ["tss"];

  services.gnome.gcr-ssh-agent.enable = lib.mkForce false;

  hm = {
    services.ssh-agent.enable = lib.mkForce false;
    services.ssh-tpm-agent.enable = true;

    systemd.user.services.ssh-tpm-agent-init = {
      Unit = {
        Description = "Load ssh-tpm-agent keys";
        After = ["ssh-tpm-agent.service"];
        Requires = ["ssh-tpm-agent.service"];
      };
      Install.WantedBy = ["default.target"];
      Service = {
        Type = "oneshot";
        ExecStart = "ssh-add -l";
      };
    };
  };
}
