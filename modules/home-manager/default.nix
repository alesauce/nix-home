# Combined home-manager module that imports all user modules
{
  config,
  lib,
  nix-index-database,
  stylix,
  ...
}: {
  imports = [
    nix-index-database.homeModules.nix-index
    stylix.homeManagerModules.stylix
    ./core-options.nix
    ./dev-options.nix
    ./graphical-options.nix
    ./core.nix
    ./dev.nix
    ./graphical.nix
  ];
}
