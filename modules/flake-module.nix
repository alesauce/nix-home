# Main flake-parts module export
# This is the entry point when importing nix-home as a flake-parts module
{
  self,
  lib,
  inputs,
  ...
}: {
  # Import sub-modules for flake-parts
  imports = [
    ./lib
    ./overlays/flake-module.nix
  ];

  # Export standard Nix module system outputs
  # These can be imported by work flakes or any other consumer
  flake = {
    # NixOS module system exports
    nixosModules = {
      # Main module that imports everything
      default = import ./nixos;

      # Individual modules for selective imports
      core = import ./nixos/core.nix;
      graphical = import ./nixos/graphical.nix;
    };

    # nix-darwin module system exports
    darwinModules = {
      # Main module that imports everything
      default = import ./darwin;

      # Individual modules for selective imports
      core = import ./darwin/core.nix;
      graphical = import ./darwin/graphical.nix;
    };

    # home-manager module system exports
    homeManagerModules = {
      # Main module that imports everything
      default = import ./home-manager;

      # Individual modules for selective imports
      core = import ./home-manager/core.nix;
      dev = import ./home-manager/dev.nix;
      graphical = import ./home-manager/graphical.nix;
    };
  };
}
