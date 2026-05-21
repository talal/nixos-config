{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.sops-nix.nixosModules.sops
  ];

  options = {
    user = lib.mkOption {
      type = lib.types.str;
      default = "talal";
      description = "The primary user account name.";
    };
  };

  config = {
    # keep-sorted start block=yes newline_separated=yes prefix_order=system,nixpkgs,nix,users,environment,services,programs,home-manager
    system.activationScripts.activation-diff = {
      supportsDryActivation = true;
      text = ''${lib.getExe pkgs.dix} /run/current-system "$systemConfig"'';
    };

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
      trusted-users = ["@wheel"];
      experimental-features = [
        "nix-command"
        "flakes"
        "ca-derivations"
        "auto-allocate-uids"
        "cgroups"
      ];
      # allow-import-from-derivation = false; # TODO: this breaks devenv
      auto-allocate-uids = true;
      download-buffer-size = 268435456; # 256 MiB (default is 64 MiB)
      use-cgroups = true;
      warn-dirty = false;

      # cache.nixos.org is included by default.
      substituters = [
        "https://cache.garnix.io"
        "https://talal.cachix.org"
      ];
      trusted-public-keys = [
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        "talal.cachix.org-1:BHrhoYM/V2GMjBW7aqgQEt1KcPOebRBtq8wUagUwDiw="
      ];
    };

    users.users.talal = {
      uid = 1000; # make uid predictable
      description = "Muhammad Talal Anwar";
      isNormalUser = true;
      hashedPasswordFile = config.sops.secrets.user_password.path;
      extraGroups =
        ["wheel"]
        ++ lib.optional config.networking.networkmanager.enable "networkmanager"
        # Some apps may need to adjust audio priority at runtime
        ++ lib.optional config.security.rtkit.enable "rtkit";
    };

    environment.localBinInPath = true;

    environment.variables = {
      EDITOR = "hx";
      VISUAL = "hx";
    };

    # Allows to run unpatched dynamic binaries, e.g. those downloaded by cargo/rustup.
    # Without this, simple things like 'cargo run' might crash on missing libs.
    programs.nix-ld.enable = true;

    home-manager = {
      extraSpecialArgs.inputs = inputs; # pass inputs to home-manager
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "bak";

      users.${config.user} = {
        imports = [inputs.sops-nix.homeManagerModules.sops];

        # Check before updating: https://nix-community.github.io/home-manager/release-notes.xhtml
        home.stateVersion = "25.05";

        home.username = config.user;
        home.homeDirectory = "/home/${config.user}";

        sops = {
          defaultSopsFile = ../secrets/secrets.yaml;
          defaultSopsFormat = "yaml";
          age.keyFile = "/home/${config.user}/.config/sops/age/keys.txt"; # must have no password
        };
      };
    };

    sops = {
      defaultSopsFile = ../secrets/secrets.yaml;
      defaultSopsFormat = "yaml";
      age.keyFile = "/var/lib/sops-nix/key.txt"; # must have no password

      secrets.user_password.neededForUsers = true;
    };
    # keep-sorted end
  };
}
