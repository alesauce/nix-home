{ pkgs }:

{
  home-manager.enable = true;
  neovim = import ./neovim.nix {
    inherit (pkgs) vimPlugins;
  };
}
