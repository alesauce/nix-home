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

    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

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

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
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

    tinted-schemes = {
      url = "github:tinted-theming/schemes";
      flake = false;
    };

    nix-config-modules = {
      url = "github:chadac/nix-config-modules";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nur,
    flake-parts,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;}
    (topLevel @ {withSystem, ...}: {
      imports = [
        inputs.git-hooks.flakeModule
      ];
      systems = ["aarch64-darwin" "x86_64-linux"];

      perSystem = ctx @ {
        config,
        self',
        inputs',
        pkgs,
        system,
        ...
      }: {
        _module.args.pkgs = import inputs.nixpkgs {
          localSystem = system;
          overlays = [self.overlays.default];
          config = {
            allowUnfree = true;
            allowAliases = true;
          };
          pre-commit = {
            check.enable = true;
            settings.hooks = {
              actionlint.enable = true;
              alejandra.enable = true;
              deadnix = {
                enable = true;
                settings = {
                  noLambdaArg = true;
                  noLambdaPatternNames = true;
                  noUnderscore = true;
                };
              };
              nil.enable = true;
              statix.enable = true;
            };
          };
        };

        devShells = import ./nix/dev-shell.nix ctx;
        packages = import ./nix/packages.nix topLevel ctx;
        formatter = pkgs.alejandra;
      };

      flake = {
        hosts = import ./nix/hosts.nix;

        overlays = import ./nix/overlay.nix topLevel;
        darwinConfigurations = import ./nix/darwin.nix topLevel;
        homeConfigurations = import ./nix/home-manager.nix topLevel;
        nixosConfigurations = import ./nix/nixos.nix topLevel;
      };
    });
}
