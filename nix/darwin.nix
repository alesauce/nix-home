{
  withSystem,
  inputs,
  ...
}: let
  inherit (inputs) self darwin nixpkgs home-manager nix-index-database stylix tinted-schemes;
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
          self.darwinModules.default
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
            self
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
