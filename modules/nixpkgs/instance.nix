{
  lib,
  config,
  inputs,
  withSystem,
  ...
}: {
  options.nixpkgs = {
    config = {
      allowUnfreePredicate = lib.mkOption {
        type = lib.types.functionTo lib.types.bool;
        default = _: false;
      };
      allowUnfreePackages = lib.mkOption {
        type = lib.types.listOf lib.types.singleLineStr;
        default = [];
      };
    };
    overlays = lib.mkOption {
      type = lib.types.listOf lib.types.unspecified;
      default = [];
    };
  };

  config = {
    perSystem = {system, ...}: {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        inherit (config.nixpkgs) config overlays;
      };
    };

    flake.modules.nixos.base = nixosArgs: {
      # hostPlatform is declared by the host's hardware module; base only
      # needs it to select the matching perSystem pkgs instance.
      nixpkgs.pkgs = withSystem nixosArgs.config.nixpkgs.hostPlatform.system (psArgs: psArgs.pkgs);
    };

    flake.modules.darwin.base = {
      nixpkgs = rec {
        hostPlatform = "aarch64-darwin";
        pkgs = withSystem hostPlatform (psArgs: psArgs.pkgs);
      };
    };
  };
}
