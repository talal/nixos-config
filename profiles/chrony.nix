{
  # Chrony with NTS (Network Time Security) for authenticated time sync.
  services.chrony = {
    enable = true;
    enableNTS = true;
    servers = [
      "time.cloudflare.com"
      "ptbtime1.ptb.de"
      "ptbtime2.ptb.de"
      "ntppool1.time.nl"
      "nts.netnod.se"
    ];
    extraConfig = ''
      # Require at least 3 sources to agree before updating time.
      minsources 3
    '';
  };
}
