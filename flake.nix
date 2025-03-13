{
  description = "Alesauce's home configs, modeled via Nix";

  nixConfig = {
    extra-trusted-substituters = [
      "https://nix-config.cachix.org"
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-config.cachix.org-1:Vd6raEuldeIZpttVQfrUbLvXJHzzzkS0pezXCVVjDG4="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixvim-flake = {
      url = "github:alesauce/nixvim-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };

    nix-fast-build = {
      url = "github:Mic92/nix-fast-build";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };

    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    stylix = {
      url = "github:danth/stylix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    forAllSystems = nixpkgs.lib.genAttrs [
      "aarch64-darwin"
      "x86_64-darwin"
      "x86_64-linux"
    ];
  in {
    hosts = import ./nix/hosts.nix;

    pkgs = forAllSystems (localSystem:
      import nixpkgs {
        inherit localSystem;
        overlays = [self.overlays.default];
        config = {
          allowUnfree = true;
          allowAliases = true;
        };
      });

    checks = forAllSystems (import ./nix/checks.nix inputs);
    devShells = forAllSystems (import ./nix/dev-shell.nix inputs);
    overlays = import ./nix/overlay.nix inputs;
    packages = forAllSystems (import ./nix/packages.nix inputs);
    formatter = forAllSystems (system: self.pkgs.${system}.alejandra);

    darwinConfigurations = import ./nix/darwin.nix inputs;
    homeConfigurations = import ./nix/home-manager.nix inputs;
  };
}
