{
  inputs,
  lib,
  pkgs,
  ...
}: {
  # keep-sorted start block=yes newline_separated=yes prefix_order=nixpkgs,nix,home-manager,environment,services,programs,system
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

    # Garnix Cache
    substituters = ["https://cache.garnix.io"]; # cache.nixos.org is added by default
    trusted-public-keys = ["cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="];
  };

  home-manager = {
    extraSpecialArgs.inputs = inputs; # pass inputs to home-manager
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "bak";
  };

  environment.localBinInPath = true;

  environment.systemPackages = with pkgs; [
    # keep-sorted start
    age
    bat
    fd
    git
    helix
    ripgrep
    sops
    tree
    wl-clipboard
    # keep-sorted end
  ];

  environment.variables = {
    EDITOR = "hx";
    VISUAL = "hx";
  };

  # Allows to run unpatched dynamic binaries, e.g. those downloaded by cargo/rustup.
  # Without this, simple things like 'cargo run' might crash on missing libs.
  programs.nix-ld.enable = true;

  system.activationScripts.activation-diff = {
    supportsDryActivation = true;
    text = ''${lib.getExe pkgs.dix} /run/current-system "$systemConfig"'';
  };
  # keep-sorted end
}
