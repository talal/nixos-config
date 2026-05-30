{config, ...}: {
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
  };

  # Allows Pipewire to use realtime scheduler for better performance.
  security.rtkit.enable = true;

  # Some apps may need to adjust audio priority at runtime
  users.users.${config.user}.extraGroups = ["rtkit"];
}
