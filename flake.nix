{
  description = "Talal's NixOS configurations";

  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixos-25.11/nixexprs.tar.xz";
    nixpkgs-unstable.url = "https://channels.nixos.org/nixpkgs-unstable/nixexprs.tar.xz";

    # keep-sorted start block=yes newline_separated=yes prefix_order=home-manager,sops-nix
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
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

    # This flake is only built and tested against its pinned nixpkgs-unstable input.
    # Don't set `nixpkgs.follows`.
    llm-agents.url = "github:numtide/llm-agents.nix";

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

    mkHost = {
      hostname,
      user ? "talal",
    }:
      inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          {
            # Apply overlays first so that they're available globally.
            nixpkgs.overlays = overlays;

            # Set config.user. See ./modules/base.nix for more info.
            inherit user;
          }
          ./hosts/${hostname}
        ];
      };
  in {
    formatter.${system} = treefmtEval.config.build.wrapper;
    checks.${system}.formatting = treefmtEval.config.build.check self;
    nixosConfigurations = {
      thinkpad = mkHost {hostname = "thinkpad-e16-g2";};
    };
  };
}
