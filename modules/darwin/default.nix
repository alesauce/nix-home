# nix-darwin module system entry point
{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./options.nix
    ./graphical-options.nix
    ./core.nix
    ./graphical.nix
  ];
}
