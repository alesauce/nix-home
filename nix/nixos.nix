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
        modules = [
          (../hosts + "/${hostname}")
          {
            nix.registry = {
              nixpkgs.flake = inputs.nixpkgs;
              p.flake = inputs.nixpkgs;
            };
            nixpkgs.pkgs = pkgs;
          }
        ];
        specialArgs = {
          hostType = type;
          inherit
            (inputs)
            home-manager
            nix-index-database
            stylix
            tinted-schemes
            sops-nix
            ;
        };
      });
in
  lib.mapAttrs
  genConfiguration
  (lib.filterAttrs (_: host: host.type == "nixos") inputs.self.hosts)
