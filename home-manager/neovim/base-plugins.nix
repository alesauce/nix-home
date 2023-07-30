{ pkgs, ... }:

{
  programs.nixvim = {
    plugins = {
      nix.enable = true;
      tmux-navigator.enable = true;

      # TODO: review docs and configure harpoon: https://github.com/ThePrimeagen/harpoon
      # nixvim docs: https://nix-community.github.io/nixvim/#_plugins_harpoon_enable
      # harpoon.enable = true;

      indent-blankline = {
        enable = true;
        showEndOfLine = true;
      };

      lightline = {
        enable = true;
        colorscheme = "selenized_black";
      };

      nvim-autopairs = {
        enable = true;
        checkTs = true;
        tsConfig = {
          lua = ["string" "source"];
        };
      };
    };
  };
}
