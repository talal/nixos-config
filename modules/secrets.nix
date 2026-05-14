{
  inputs,
  config,
  ...
}: let
  homeDir = config.users.users.talal.home;
  defaultSopsFile = ../secrets/secrets.yaml;
  defaultSopsFormat = "yaml";
in {
  imports = [inputs.sops-nix.nixosModules.sops];

  sops = {
    inherit defaultSopsFile defaultSopsFormat;
    age.keyFile = "/var/lib/sops-nix/key.txt"; # must have no password

    secrets.nextdns_id = {};
    templates."nextdns.conf" = {
      path = "/etc/systemd/resolved.conf.d/nextdns.conf";
      mode = "0444";
      restartUnits = ["systemd-resolved.service"];
      content = ''
        [Resolve]
        DNS=45.90.28.0#thinkpad-${config.sops.placeholder.nextdns_id}.dns.nextdns.io
        DNS=2a07:a8c0::#thinkpad-${config.sops.placeholder.nextdns_id}.dns.nextdns.io
        DNS=45.90.30.0#thinkpad-${config.sops.placeholder.nextdns_id}.dns.nextdns.io
        DNS=2a07:a8c1::#thinkpad-${config.sops.placeholder.nextdns_id}.dns.nextdns.io
        DNSOverTLS=yes
        DNSSEC=yes
      '';
    };
  };

  home-manager.users.talal = {...}: {
    imports = [inputs.sops-nix.homeManagerModules.sops];

    sops = {
      inherit defaultSopsFile defaultSopsFormat;
      age.keyFile = "${homeDir}/.config/sops/age/keys.txt"; # must have no password

      secrets = {
        "ssh-config" = {
          sopsFile = ../secrets/ssh-config.yaml;
          format = "yaml";
          key = "config";
          path = "${homeDir}/.ssh/config";
        };
      };
    };
  };
}
