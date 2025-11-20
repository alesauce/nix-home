# Library functions export module
{
  lib,
  inputs,
  withSystem,
  ...
}: let
  # Import builder functions
  builders = import ./builders.nix {inherit lib inputs withSystem;};

  # Import host helpers
  hosts = import ./hosts.nix {inherit lib;};
in {
  # Export library functions to flake outputs
  flake.lib =
    builders
    // hosts
    // {
      # Re-export for convenience
      inherit builders hosts;
    };
}
