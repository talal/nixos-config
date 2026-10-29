{
  inputs,
  lib,
  pkgs,
  findModulesList,
  ...
}: {
  imports = findModulesList ./.;

  options = {
    user = lib.mkOption {
      type = lib.types.str;
      description = "Primary user of the system";
    };
  };

  config = {
    # keep-sorted start block=yes newline_separated=yes prefix_order=system,environment,,services,programs
    system.activationScripts.activation-diff = {
      supportsDryActivation = true;
      text = ''${lib.getExe pkgs.unstable.dix} diff /run/current-system "$systemConfig"'';
    };

    system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or "unknown";

    systemd = {
      network.wait-online.enable = false;
      services.NetworkManager-wait-online.enable = false;
    };

    environment.localBinInPath = true;

    console = {
      earlySetup = true; # set virtual console options as early as possible (in initrd)
      font = lib.mkDefault "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
      keyMap = lib.mkDefault "us";
    };

    i18n.defaultLocale = lib.mkDefault "en_GB.UTF-8";

    networking.firewall = {
      enable = true;
      allowPing = true;
    };

    networking.nftables.enable = lib.mkDefault true;

    time.timeZone = lib.mkDefault "Europe/Berlin";
    # keep-sorted end
  };
}
