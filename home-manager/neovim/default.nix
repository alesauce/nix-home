{ pkgs, ... }:

{
  imports = [
    ./base-opts.nix
    ./base-plugins.nix
    ./colorscheme.nix
    ./lsp.nix
    ./telescope.nix
    ./treesitter.nix
    ./completion.nix
  ];

  programs.nixvim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    globals.mapleader = "<Space>";
    # TODO: Figure out how the append function works for a table and how I can set a table with specific characters added
    extraConfigLua = ''
      vim.opt.listchars:append "eol:↴"
    '';
  };
}
