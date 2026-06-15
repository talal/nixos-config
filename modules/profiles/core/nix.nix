{inputs, ...}: {
  nix = {
    # Disable legacy channels since we use flake.
    channel.enable = false;

    # Map the "nixpkgs" identifier to our locked flake inputs.
    # This prevents downloading nixpkgs again for shell commands or rebuilds.
    registry = {
      nixpkgs.flake = inputs.nixpkgs;
      nixpkgs-unstable.flake = inputs.nixpkgs-unstable;
    };

    # Set legacy nixpkgs path to flake reference.
    # Adds the path to NIX_PATH for legacy tool compatibility.
    nixPath = ["nixpkgs=${inputs.nixpkgs}"];

    # Cleanup
    optimise.automatic = true;
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };

    settings = {
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

      accept-flake-config = false; # don't accept other people's nix config
      allow-import-from-derivation = false;
      http-connections = 50; # (default: 25)
      keep-going = true; #  continue building derivations even if one fails
      log-lines = 30; # (default: 10)
      use-xdg-base-directories = true;
      warn-dirty = false;

      # for direnv GC roots
      keep-derivations = true;
      keep-outputs = true;

      # cache.nixos.org is included by default.
      substituters = ["https://talal.cachix.org"];
      trusted-public-keys = ["talal.cachix.org-1:BHrhoYM/V2GMjBW7aqgQEt1KcPOebRBtq8wUagUwDiw="];
    };
  };
}
