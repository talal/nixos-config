{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General = {
      Experimental = true; # newer codecs and battery info for devices
      Privacy = "device";
    };
  };
}
