{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    # Map `hm` to `home-manager.users.${config.user}` to simplify usage within modules.
    (lib.mkAliasOptionModule ["hm"] ["home-manager" "users" config.user])

    # keep-sorted start prefix_order=inputs,./
    inputs.home-manager.nixosModules.home-manager
    inputs.sops-nix.nixosModules.sops
    ./catppuccin.nix
    ./chrony.nix
    ./git.nix
    ./helix.nix
    ./jj.nix
    ./shell.nix
    # keep-sorted end
  ];

  options = {
    user = lib.mkOption {
      type = lib.types.str;
      description = "Primary user of the system";
    };
  };

  config = {
    # keep-sorted start block=yes newline_separated=yes prefix_order=system,nixpkgs,nix,environment,,services,programs,home-manager
    system.activationScripts.activation-diff = {
      supportsDryActivation = true;
      text = ''${lib.getExe pkgs.dix} /run/current-system "$systemConfig"'';
    };

    system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or "unknown";

    nixpkgs.config = {
      allowUnfree = true;
      allowAliases = false;
    };

    nix = {
      # Disable legacy channels since we use flake.
      channel.enable = false;

      # Map the "nixpkgs" identifier to our locked flake input.
      # This prevents downloading nixpkgs again for shell commands or rebuilds.
      registry.nixpkgs.flake = inputs.nixpkgs;

      # Set legacy nixpkgs path to flake reference.
      # Adds the path to NIX_PATH for legacy tool compatibility.
      nixPath = ["nixpkgs=${inputs.nixpkgs}"];

      # Cleanup
      optimise.automatic = true;
      gc = {
        automatic = true;
        options = "--delete-older-than 7d";
      };
    };

    nix.settings = {
      allowed-users = ["@wheel"]; # can do anything with the nix daemon
      trusted-users = ["@wheel"]; # can manage the nix store

      experimental-features = [
        "nix-command"
        "flakes"
        "auto-allocate-uids"
        "cgroups"
      ];
      auto-allocate-uids = true;
      use-cgroups = true;

      # allow-import-from-derivation = false; # TODO: this breaks devenv
      accept-flake-config = false; # don't accept other people's nix config
      http-connections = 50; # (default: 25)
      keep-going = true; #  continue building derivations even if one fails
      log-lines = 30; # (default: 10)
      warn-dirty = false;

      # for direnv GC roots
      keep-derivations = true;
      keep-outputs = true;

      # cache.nixos.org is included by default.
      substituters = ["https://talal.cachix.org"];
      trusted-public-keys = ["talal.cachix.org-1:BHrhoYM/V2GMjBW7aqgQEt1KcPOebRBtq8wUagUwDiw="];
    };

    environment.localBinInPath = true;

    environment.systemPackages = with pkgs; [
      # keep-sorted start prefix_order=pkgs-unstable
      age
      ffmpeg-full
      pciutils
      poppler-utils
      sops
      tree
      usbutils
      wl-clipboard
      # keep-sorted end
    ];

    console = {
      earlySetup = true; # set virtual console options as early as possible (in initrd)
      font = lib.mkDefault "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
    };

    i18n.defaultLocale = lib.mkDefault "en_GB.UTF-8";

    sops = {
      defaultSopsFile = inputs.self + "/secrets/secrets.yaml";
      defaultSopsFormat = "yaml";
      age.keyFile = "/var/lib/sops-nix/key.txt"; # must have no password
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
