# nix-darwin module system entry point
{
  config,
  lib,
  pkgs,
  home-manager,
  nix-index-database,
  stylix,
  ...
}: {
  imports = [
    home-manager.darwinModules.home-manager
    nix-index-database.darwinModules.nix-index
    stylix.darwinModules.stylix
    ./options.nix
    ./graphical-options.nix
    ./core.nix
    ./graphical.nix
  ];
}
