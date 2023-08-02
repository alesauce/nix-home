{ pkgs, ... }:

{
  programs.nixvim = {
    # TODO: add formatter.nvim: https://github.com/mhartington/formatter.nvim
    # TODO: add nvim-lint: https://github.com/mfussenegger/nvim-lint
    plugins = {
      # TODO: review docs and configure harpoon: https://github.com/ThePrimeagen/harpoon
      # nixvim docs: https://nix-community.github.io/nixvim/#_plugins_harpoon_enable
      # harpoon.enable = true;

      # TODO: add toggleterm: https://github.com/akinsho/toggleterm.nvim
      # nixvim docs: https://nix-community.github.io/nixvim/#_plugins_toggleterm_enable
      # toggleterm.enable = true;

      # TODO: add todo-comments: https://github.com/folke/todo-comments.nvim
      # nixvim docs: https://nix-community.github.io/nixvim/#_plugins_todo_comments_enable
      # todo-comments.enable = true;

      # TODO: Add which-key: https://github.com/folke/which-key.nvim
      # nixvim docs: https://nix-community.github.io/nixvim/#_plugins_which_key_enable
      # which-key.enable = true;

      # TODO: add undotree: https://github.com/mbbill/undotree
      # nixvim docs: https://nix-community.github.io/nixvim/#_plugins_undotree_enable
      # undotree.enable = true;

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
