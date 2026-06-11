{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    disabledPlugins = ["sap"];
    settings.General = {
      Experimental = true; # newer codecs and battery info for devices
      FastConnectable = true; # instant wake-up from sleep (at the cost of some battery life)
      JustWorksRepairing = "confirm"; # securely handle power blinks
      Privacy = "device"; # stops public Bluetooth tracking
    };
  };
}
