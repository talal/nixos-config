{
  services.printing.enable = true;

  # Security vulnerability
  # Reference: https://discourse.nixos.org/t/newly-announced-vulnerabilities-in-cups/52771
  systemd.services.cups-browsed.enable = false;
}
