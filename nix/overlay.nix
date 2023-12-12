{
  self,
  nixpkgs,
  nixvim-flake,
  pkgs,
  ...
} @ inputs: let
  inherit (nixpkgs) lib;

  importLocalOverlay = file:
    lib.composeExtensions
    (_: _: {__inputs = inputs;})
    (import (./overlays + "/${file}"));

  localOverlays =
    lib.mapAttrs'
    (
      f: _:
        lib.nameValuePair
        (lib.removeSuffix ".nix" f)
        (importLocalOverlay f)
    )
    (builtins.readDir ./overlays);
in
  localOverlays
  // {
    default = lib.composeManyExtensions ([
        (final: prev: {
          inherit (self.packages.${final.stdenv.hostPlatform.system}) nix-fast-build;
        })
      ]
      ++ (lib.attrValues localOverlays));
  }
