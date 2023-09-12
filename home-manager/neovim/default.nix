{ ... }:

{
  imports = [
    ./base-opts.nix
    ./base-plugins.nix
    ./colorscheme.nix
    ./completion.nix
    ./harpoon.nix
    ./lsp.nix
    ./noice.nix
    ./nvim-tree.nix
    ./telescope.nix
    ./treesitter.nix
  ];

  programs.nixvim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    maps = {
      normalVisualOp."<Space>" = {
        action = "<Nop>";
        silent = true;
      };
    };

    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    # TODO: Figure out how the append function works for a table and how I can set a table with specific characters added
    extraConfigLua = ''
      vim.opt.listchars:append "eol:↴"
    '';
  };
}
