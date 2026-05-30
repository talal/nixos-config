{
  services.btrfs.autoScrub.enable = true;

  virtualisation.containers.storage.settings.storage.driver = "btrfs";
}
