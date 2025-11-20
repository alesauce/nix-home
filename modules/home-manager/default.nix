# Combined home-manager module that imports all user modules
{
  config,
  lib,
  ...
}: {
  imports = [
    ./core.nix
    ./dev.nix
    ./graphical.nix
  ];
}
