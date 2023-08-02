{ pkgs, ... }:

{
  programs.nixvim = {
    plugins = {
      # TODO: review docs and configure harpoon: https://github.com/ThePrimeagen/harpoon
      # nixvim docs: https://nix-community.github.io/nixvim/#_plugins_harpoon_enable
      # harpoon.enable = true;

      # TODO: add toggleterm: https://github.com/akinsho/toggleterm.nvim
      # nixvim docs: https://nix-community.github.io/nixvim/#_plugins_toggleterm_enable
      # toggleterm.enable = true;

      nix.enable = true;
      tmux-navigator.enable = true;

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
