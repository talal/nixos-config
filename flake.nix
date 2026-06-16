{
  description = "Talal's NixOS configurations";

  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixos-26.05/nixexprs.tar.xz";
    nixpkgs-unstable.url = "https://channels.nixos.org/nixpkgs-unstable/nixexprs.tar.xz";

    # keep-sorted start block=yes newline_separated=yes prefix_order=home-manager,sops
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # I update this input frequently therefore don't pin nixpkgs to my input.
    # Use upstream's nixpkgs input instead.
    noctalia = {
      url = "github:noctalia-dev/noctalia";
    };

    talal-fonts = {
      url = "github:talal/fonts";
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

    overlays = [
      (final: prev: {
        unstable = import inputs.nixpkgs-unstable {
          inherit (final.stdenv.hostPlatform) system;
          inherit (prev) config;
        };
      })

      inputs.talal-fonts.overlays.default
    ];

    mkHost = import ./lib/mkHost.nix {
      inherit inputs overlays;
    };

    treefmtEval = inputs.treefmt-nix.lib.evalModule latestPkgs ./treefmt.nix;
  in {
    formatter.${system} = treefmtEval.config.build.wrapper;
    checks.${system}.formatting = treefmtEval.config.build.check self;

    nixosConfigurations = {
      thinkpad = mkHost {hostname = "thinkpad";};
    };
  };
}
