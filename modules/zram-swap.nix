{
  # Use memory more efficiently at the cost of some compute.
  zramSwap = {
    enable = true;
    memoryPercent = 100;
  };

  boot.kernel.sysctl = {
    "vm.swappiness" = 180; # Aggressively move cold data to ZRAM
    "vm.watermark_boost_factor" = 0; # Prevent unexpected swapping spikes
    "vm.watermark_scale_factor" = 125; # Start swapping earlier to avoid "stutter" when RAM fills
    "vm.page-cluster" = 0; # Read 1 page at a time (saves CPU)
  };

  services.earlyoom.enable = true;
}
