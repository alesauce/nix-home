# Package overlays for custom and modified packages
{
  lib,
  inputs,
}: let
  # Import a local overlay file and provide inputs
  importLocalOverlay = file:
    lib.composeExtensions
    (_: _: {__inputs = inputs;})
    (import (./. + "/${file}"));

  # Discover all overlay files in this directory
  localOverlays =
    lib.mapAttrs'
    (
      f: _:
        lib.nameValuePair
        (lib.removeSuffix ".nix" f)
        (importLocalOverlay f)
    )
    (builtins.removeAttrs
      (builtins.readDir ./.)
      ["default.nix"]); # Exclude this file
in
  localOverlays
  // {
    # Compose all overlays into a single default overlay
    default = lib.composeManyExtensions (
      (lib.attrValues localOverlays)
      ++ [
        # Nixvim flake overlay for custom Neovim
        inputs.nixvim-flake.overlays.default
        # Nix User Repository overlay
        inputs.nur.overlays.default
        # Nix fast build tool overlay
        (final: prev: {
          inherit
            (inputs.nix-fast-build.packages.${final.stdenv.hostPlatform.system})
            nix-fast-build
            ;
        })
      ]
    );
  }
