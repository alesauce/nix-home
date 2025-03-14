{
  self,
  tinted-schemes,
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
    lib.nixosSystem {
      modules = [
        (../hosts + "/${hostname}")
        {
          nix.registry = {
            nixpkgs.flake = nixpkgs;
            p.flake = nixpkgs;
          };
          nixpkgs.pkgs = self.pkgs.${hostPlatform};
        }
      ];
      specialArgs = {
        hostType = type;
        inherit
          home-manager
          nix-index-database
          stylix
          tinted-schemes
          ;
      };
    };
in
  lib.mapAttrs
  genConfiguration
  (lib.filterAttrs (_: host: host.type == "nixos") self.hosts)
