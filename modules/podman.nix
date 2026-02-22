{pkgs, ...}: {
  virtualisation = {
    oci-containers.backend = "podman";
    containers.storage.settings.storage.driver = "btrfs";
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true; # so containers can communicate with each other
      autoPrune.enable = true;
    };
  };

  # This is needed because podman does not have a daemon (unlike Docker) and therefore
  # does not restart manual containers (e.g. podman run) after system reboot.
  systemd.user.services.podman-restart.wantedBy = ["default.target"];

  home-manager.users.talal.home.packages = [pkgs.podman-compose];
}
