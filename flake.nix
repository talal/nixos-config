{
  description = "Talal's NixOS configurations";

  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixos-25.11/nixexprs.tar.xz";
    nixpkgs-unstable.url = "https://channels.nixos.org/nixpkgs-unstable/nixexprs.tar.xz";

    # keep-sorted start block=yes newline_separated=yes prefix_order=home-manager
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin = {
      url = "github:catppuccin/nix/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # This flake is only built and tested against its pinned nixpkgs-unstable input.
    # Don't set `nixpkgs.follows`.
    llm-agents.url = "github:numtide/llm-agents.nix";

    sops-nix = {
      url = "github:Mic92/sops-nix";
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

    pkgs-unstable = import inputs.nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };

    mkHost = {hostname}:
      inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs pkgs-unstable;};
        modules = [
          {networking.hostName = hostname;}
          ./hosts/${hostname}
        ];
      };
  in {
    formatter.${system} = treefmtEval.config.build.wrapper;
    checks.${system}.formatting = treefmtEval.config.build.check self;

    nixosConfigurations = {
      thinkpad = mkHost {hostname = "thinkpad";};
    };
  };
}
