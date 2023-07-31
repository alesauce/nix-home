{ pkgs, ... }:

{
  imports = [
    ./base-opts.nix
    ./base-plugins.nix
    ./colorscheme.nix
    ./telescope.nix
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

    # TODO: move this over to completions module
    # Completions
    # completeopt = "menuone,noselect";

    # TODO: move these over to completions module
    # Completions (cmp)
    # nvim-cmp.enable = true;
    # cmp-buffer.enable = true;
    # cmp-cmdline.enable = true;
    # cmp_luasnip.enable = true;
    # cmp-path.enable = true;
    # cmp-nvim-lsp.enable = true;
    # cmp-nvim-lua.enable = true;
    # luasnip.enable = true;

    # TODO: create treesitter module
    # treesitter.enable = true;
}
