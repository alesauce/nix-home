{
  self,
  home-manager,
  nix-index-database,
  nixpkgs,
  stylix,
  tinted-schemes,
  ...
}: let
  inherit (nixpkgs) lib;

  genModules = hostName: {homeDirectory, ...}: {
    config,
    pkgs,
    ...
  }: {
    imports = [(../hosts + "/${hostName}")];
    nix.registry = {
      nixpkgs.flake = nixpkgs;
      p.flake = nixpkgs;
    };

    home = {
      inherit homeDirectory;
      sessionVariables.NIX_PATH = lib.concatStringsSep ":" [
        "nixpkgs=${config.xdg.dataHome}/nixpkgs"
      ];
    };

    xdg = {
      dataFile.nixpkgs.source = nixpkgs;
      configFile."nix/nix.conf".text = ''
        flake-registry = ${config.xdg.configHome}/nix/registry.json
      '';
    };
  };

  genConfiguration = hostName: {
    hostPlatform,
    type,
    ...
  } @ attrs:
    home-manager.lib.homeManagerConfiguration {
      pkgs = self.pkgs.${hostPlatform};
      modules = [(genModules hostName attrs)];
      extraSpecialArgs = {
        hostType = type;
        inherit
          nix-index-database
          stylix
          tinted-schemes
          ;
      };
    };
in
  lib.mapAttrs
  genConfiguration
  (lib.filterAttrs (_: host: host.type == "home-manager") self.hosts)
