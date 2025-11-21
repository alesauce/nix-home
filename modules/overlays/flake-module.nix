# Overlays export module
{
  lib,
  inputs,
  ...
}: let
  # Import all overlays
  overlayLib = import ./default.nix {inherit lib inputs;};
in {
  # Export overlays to flake outputs
  flake.overlays = overlayLib;
}
