{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
    settings.General = {
      Experimental = true; # newer codecs and battery info for devices
      Privacy = "device";
    };
  };
}
