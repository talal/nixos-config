{
  description = "Talal's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # keep-sorted start block=yes newline_separated=yes prefix_order=home-manager
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin = {
      url = "github:catppuccin/nix/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dms = {
      url = "github:AvengeMedia/DankMaterialShell/stable";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    # keep-sorted end
  };

  outputs = {self, ...} @ inputs: let
    system = "x86_64-linux";
    latestPkgs = inputs.nixpkgs-unstable.legacyPackages.${system};
    treefmtEval = inputs.treefmt-nix.lib.evalModule latestPkgs ./treefmt.nix;

    overlays = [
      (final: prev: {
        dgop = inputs.nixpkgs-unstable.legacyPackages.${final.stdenv.hostPlatform.system}.dgop;

        # Make unstable packages available via pkgs.unstable.<package>
        unstable = import inputs.nixpkgs-unstable {
          inherit (final.stdenv.hostPlatform) system;
          inherit (prev) config;
        };
      })
    ];
  in {
    formatter.${system} = treefmtEval.config.build.wrapper;
    checks.${system}.formatting = treefmtEval.config.build.check self;

    nixosConfigurations.thinkpad = inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        # Apply overlays first so that they're available globally.
        {nixpkgs.overlays = overlays;}
        ./hosts/thinkpad-e16-g2
      ];
    };
  };
}
