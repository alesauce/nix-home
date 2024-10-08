{
  self,
  base16-schemes,
  darwin,
  home-manager,
  nix-index-database,
  nixpkgs,
  stylix,
  ...
}: let
  inherit (nixpkgs) lib;

  genConfiguration = hostname: {
    hostPlatform,
    type,
    ...
  }:
    darwin.lib.darwinSystem {
      system = hostPlatform;
      pkgs = self.pkgs.${hostPlatform};
      modules = [
        (../hosts + "/${hostname}")
        {
          nix.registry = {
            p.flake = nixpkgs;
          };
        }
      ];
      specialArgs = {
        hostType = type;
        inherit
          base16-schemes
          home-manager
          nix-index-database
          stylix
          ;
      };
    };
in
  lib.mapAttrs
  genConfiguration
  (lib.filterAttrs (_: host: host.type == "darwin") self.hosts)
