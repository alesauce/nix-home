# NixOS module system entry point
{
  config,
  lib,
  pkgs,
  home-manager,
  nix-index-database,
  stylix,
  sops-nix,
  ...
}: {
  imports = [
    home-manager.nixosModules.home-manager
    nix-index-database.nixosModules.nix-index
    stylix.nixosModules.stylix
    sops-nix.nixosModules.sops
    ./options.nix
    ./graphical-options.nix
    ./core.nix
    ./graphical.nix
  ];
}
