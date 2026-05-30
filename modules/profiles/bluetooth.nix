{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
    settings.General = {
      Experimental = true; # newer codes and battery info for devices
      Privacy = "device";
    };
  };
}
