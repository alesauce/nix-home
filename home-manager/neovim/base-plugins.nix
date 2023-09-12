{ pkgs, ... }:

{
  # TODO: https://nix-community.github.io/nixvim/plugins/treesitter-context.html
  programs.nixvim = {
    # TODO: add formatter.nvim: https://github.com/mhartington/formatter.nvim
    # TODO: add nvim-lint: https://github.com/mfussenegger/nvim-lint
    plugins = {
      # TODO: add toggleterm: https://github.com/akinsho/toggleterm.nvim
      # nixvim docs: https://nix-community.github.io/nixvim/#_plugins_toggleterm_enable
      # toggleterm.enable = true;

      # TODO: configure which-key: https://github.com/folke/which-key.nvim
      # nixvim docs: https://nix-community.github.io/nixvim/#_plugins_which_key_enable
      which-key.enable = true;

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

      todo-comments.enable = true;

      # TODO: configure undotree: https://github.com/mbbill/undotree
      # nixvim docs: https://nix-community.github.io/nixvim/#_plugins_undotree_enable
      undotree.enable = true;
    };

    extraPlugins = with pkgs.vimPlugins; [
      guess-indent-nvim
    ];

    extraConfigLua = ''
      require('guess-indent').setup {}
    '';
  };
}
