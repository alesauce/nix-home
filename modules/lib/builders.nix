# Builder functions for creating system configurations
{
  lib,
  inputs,
  withSystem,
}: {
  # Create a Darwin (macOS) system configuration
  mkDarwinConfiguration = hostname: {
    hostPlatform,
    type,
    modules ? [],
    specialArgs ? {},
    ...
  }:
    withSystem hostPlatform ({
      pkgs,
      system,
      ...
    }:
      inputs.darwin.lib.darwinSystem {
        inherit pkgs system;
        modules =
          [
            (inputs.self.outPath + "/hosts/${hostname}")
            {
              nix.registry = {
                nixpkgs.flake = inputs.nixpkgs;
                p.flake = inputs.nixpkgs;
              };
            }
          ]
          ++ modules;
        specialArgs =
          {
            hostType = type;
            inherit
              (inputs)
              home-manager
              nix-index-database
              stylix
              tinted-schemes
              ;
          }
          // specialArgs;
      });

  # Create a NixOS system configuration
  mkNixosConfiguration = hostname: {
    hostPlatform,
    type,
    modules ? [],
    specialArgs ? {},
    ...
  }:
    withSystem hostPlatform ({pkgs, ...}:
      lib.nixosSystem {
        modules =
          [
            (inputs.self.outPath + "/hosts/${hostname}")
            {
              nix.registry = {
                nixpkgs.flake = inputs.nixpkgs;
                p.flake = inputs.nixpkgs;
              };
              nixpkgs.pkgs = pkgs;
            }
          ]
          ++ modules;
        specialArgs =
          {
            hostType = type;
            inherit
              (inputs)
              home-manager
              nix-index-database
              stylix
              tinted-schemes
              sops-nix
              ;
          }
          // specialArgs;
      });

  # Create a home-manager-only configuration
  mkHomeConfiguration = hostname: {
    hostPlatform,
    type,
    homeDirectory,
    modules ? [],
    extraSpecialArgs ? {},
    ...
  }:
    withSystem hostPlatform ({pkgs, ...}: let
      hostModules = {config, ...}: {
        imports = [(inputs.self.outPath + "/hosts/${hostname}")];
        nix.registry = {
          nixpkgs.flake = inputs.nixpkgs;
          p.flake = inputs.nixpkgs;
        };

        home = {
          inherit homeDirectory;
          sessionVariables.NIX_PATH = lib.concatStringsSep ":" [
            "nixpkgs=${config.xdg.dataHome}/nixpkgs"
          ];
        };

        xdg = {
          dataFile.nixpkgs.source = inputs.nixpkgs;
          configFile."nix/nix.conf".text = ''
            flake-registry = ${config.xdg.configHome}/nix/registry.json
          '';
        };
      };
    in
      inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [hostModules] ++ modules;
        extraSpecialArgs =
          {
            hostType = type;
            inherit
              (inputs)
              nix-index-database
              stylix
              tinted-schemes
              ;
          }
          // extraSpecialArgs;
      });
}
