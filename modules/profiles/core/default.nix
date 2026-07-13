{
  inputs,
  config,
  lib,
  pkgs,
  findModulesList,
  ...
}: {
  imports =
    [
      # Map `hm` to `home-manager.users.${config.user}` to simplify usage within modules.
      (lib.mkAliasOptionModule ["hm"] ["home-manager" "users" config.user])

      inputs.home-manager.nixosModules.home-manager
    ]
    ++ (findModulesList ./.);

  options = {
    user = lib.mkOption {
      type = lib.types.str;
      description = "Primary user of the system";
    };
  };

  config = {
    # keep-sorted start block=yes newline_separated=yes prefix_order=system,environment,,services,programs,home-manager,sops
    system.activationScripts.activation-diff = {
      supportsDryActivation = true;
      text = ''${lib.getExe pkgs.dix} /run/current-system "$systemConfig"'';
    };

    system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or "unknown";

    systemd = {
      network.wait-online.enable = false;
      services.NetworkManager-wait-online.enable = false;
    };

    environment.localBinInPath = true;

    boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

    console = {
      earlySetup = true; # set virtual console options as early as possible (in initrd)
      font = lib.mkDefault "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
      keyMap = lib.mkDefault "us";
    };

    i18n.defaultLocale = lib.mkDefault "en_GB.UTF-8";

    time.timeZone = lib.mkDefault "Europe/Berlin";

    networking.nftables.enable = lib.mkDefault true;
    networking.firewall = {
      enable = true;
      allowPing = true;
    };

    home-manager = {
      extraSpecialArgs.inputs = inputs; # pass inputs to home-manager
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "bak";

      # Check before updating: https://nix-community.github.io/home-manager/release-notes.xhtml
      users.${config.user}.home.stateVersion = "26.05";
    };
    # keep-sorted end
  };
}
