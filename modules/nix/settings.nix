{
  lib,
  config,
  inputs,
  ...
}: {
  options.nix = {
    gc.automatic = lib.mkOption {type = lib.types.bool;};
    settings = {
      experimental-features = lib.mkOption {
        type = lib.types.listOf lib.types.singleLineStr;
        default = [];
      };
    };
    daemonSettings = {
      accept-flake-config = lib.mkOption {type = lib.types.bool;};
      allowed-users = lib.mkOption {
        type = lib.types.listOf lib.types.singleLineStr;
        default = [];
      };
      cores = lib.mkOption {type = lib.types.int;};
      flake-registry = lib.mkOption {type = lib.types.singleLineStr;};
      max-jobs = lib.mkOption {
        type = lib.types.either lib.types.int lib.types.singleLineStr;
      };
      substituters = lib.mkOption {
        type = lib.types.listOf lib.types.singleLineStr;
        default = [];
      };
      trusted-public-keys = lib.mkOption {
        type = lib.types.listOf lib.types.singleLineStr;
        default = [];
      };
      trusted-users = lib.mkOption {
        type = lib.types.listOf lib.types.singleLineStr;
        default = [];
      };
    };
  };

  config = {
    nix = {
      gc.automatic = true;
      settings = {
        experimental-features = [
          "auto-allocate-uids"
          "nix-command"
          "flakes"
        ];
      };

      daemonSettings = {
        accept-flake-config = true;
        allowed-users = ["@wheel"];
        cores = 0;
        flake-registry = "/etc/nix/registry.json";
        max-jobs = "auto";
        # TODO: Configure my cachix
        substituters = [
          "https://cache.nixos.org"
          "https://nix-community.cachix.org"
        ];
        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        ];
        trusted-users = ["root"];
      };
    };

    flake.modules = {
      nixos.base = {pkgs, ...}: {
        nix = lib.mkMerge [
          {
            package = pkgs.nixVersions.latest;
            inherit (config.nix) gc;
            settings = config.nix.settings // config.nix.daemonSettings;
          }
          {
            settings = {
              sandbox = true;
              auto-optimise-store = true;
            };
            nixPath = ["nixpkgs=/run/current-system/nixpkgs"];
            optimise = {
              automatic = true;
            };
          }
        ];
      };

      darwin.base = {pkgs, ...}: {
        nix = lib.mkMerge [
          {
            package = pkgs.nixVersions.latest;
            inherit (config.nix) gc;
            settings = config.nix.settings // config.nix.daemonSettings;
          }
          {
            # TODO: set up config.meta with username here
            settings.trusted-users = config.nix.daemonSettings.trusted-users ++ ["alesauce"];
            daemonIOLowPriority = false;
            nixPath = ["nixpkgs=/run/current-system/sw/nixpkgs"];
          }
        ];
      };

      homeManager.base = {
        nix = {
          inherit (config.nix) settings;
          registry = {
            nixpkgs.flake = inputs.nixpkgs;
            p.flake = inputs.nixpkgs;
          };
        };
      };
    };
  };
}
