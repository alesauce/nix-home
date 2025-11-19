{
  withSystem,
  inputs,
  ...
}: let
  inherit (inputs) self darwin nixpkgs;
  inherit (nixpkgs) lib;

  genConfiguration = hostname: {
    hostPlatform,
    type,
    ...
  }:
    withSystem hostPlatform ({
      pkgs,
      system,
      ...
    }:
      darwin.lib.darwinSystem {
        inherit pkgs system;
        modules = [
          (../hosts + "/${hostname}")
          {
            nix.registry = {
              nixpkgs.flake = nixpkgs;
              p.flake = nixpkgs;
            };
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
            ;
        };
      });
in
  lib.mapAttrs
  genConfiguration
  (lib.filterAttrs (_: host: host.type == "darwin") self.hosts)
