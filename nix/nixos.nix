{
  withSystem,
  inputs,
  ...
}: let
  inherit (inputs.nixpkgs) lib;

  genConfiguration = hostname: {
    hostPlatform,
    type,
    ...
  }:
    withSystem hostPlatform ({pkgs, ...}:
      lib.nixosSystem {
        modules =
          (builtins.attrValues inputs.self.modules.nixos)
          ++ [
            (../hosts + "/${hostname}")
            {
              nix.registry = {
                nixpkgs.flake = inputs.nixpkgs;
                p.flake = inputs.nixpkgs;
              };
              nixpkgs.pkgs = pkgs;
            }
          ];
      });
in
  lib.mapAttrs
  genConfiguration
  (lib.filterAttrs (_: host: host.type == "nixos") inputs.self.hosts)
