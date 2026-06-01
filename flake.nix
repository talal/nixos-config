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

    catppuccin = {
      url = "github:catppuccin/nix/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Don't set `nixpkgs.follows` as this flake is only built and tested against its
    # own pinned nixpkgs-unstable input.
    llm-agents.url = "github:numtide/llm-agents.nix";

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    # keep-sorted end
  };

  outputs = {self, ...} @ inputs: let
    system = "x86_64-linux";

    overlays = [
      (final: prev: {
        unstable = import inputs.nixpkgs-unstable {
          inherit (final.stdenv.hostPlatform) system;
          inherit (prev) config;
        };
      })
    ];

    mkHost = import ./lib/mkHost.nix {
      inherit inputs overlays;
    };

    treefmtEval = inputs.treefmt-nix.lib.evalModule inputs.nixpkgs-unstable.legacyPackages.${system} ./treefmt.nix;
  in {
    formatter.${system} = treefmtEval.config.build.wrapper;
    checks.${system}.formatting = treefmtEval.config.build.check self;

    nixosConfigurations = {
      thinkpad = mkHost {hostname = "thinkpad";};
    };
  };
}
