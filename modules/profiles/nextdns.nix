{config, ...}: {
  services.resolved.enable = true;

  networking.networkmanager.dns = "systemd-resolved";

  sops.secrets.nextdns_id = {};
  sops.templates."nextdns.conf" = {
    path = "/etc/systemd/resolved.conf.d/nextdns.conf";
    mode = "0444";
    restartUnits = ["systemd-resolved.service"];
    content = ''
      [Resolve]
      DNS=45.90.28.0#${config.networking.hostName}-${config.sops.placeholder.nextdns_id}.dns.nextdns.io
      DNS=2a07:a8c0::#${config.networking.hostName}-${config.sops.placeholder.nextdns_id}.dns.nextdns.io
      DNS=45.90.30.0#${config.networking.hostName}-${config.sops.placeholder.nextdns_id}.dns.nextdns.io
      DNS=2a07:a8c1::#${config.networking.hostName}-${config.sops.placeholder.nextdns_id}.dns.nextdns.io
      DNSOverTLS=yes
    '';
  };
}
