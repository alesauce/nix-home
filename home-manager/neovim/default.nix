{ pkgs, ... }:

{
  enable = true;
  viAlias = true;
  vimAlias = true;

  colorschemes.catppuccin = {
    enable = true;
    background.dark = "mocha";
  };

  globals.mapleader = "<Space>";

  options = {
    showmode = true;
    swapfile = false;
    backup = false;
    undofile = true;

    # Completions
    completeopt = "menuone,noselect";

    # Cursor and line formatting
    cursorline = true;
    cursorlineopt = "number";
    number = true;
    relativenumber = true;
    wrap = true;
    linebreak = true;

    # Line indentation
    list = true;
    tabstop = 4;
    expandtab = true;
    shiftwidth = 4;
    smartindent = true;

    # Color scheme
    termguicolors = true;
  };

  plugins = {
    lightline.enable = true;
    nvim-autopairs.enable = true;

    # Completions (cmp)
    # nvim-cmp.enable = true;
    # cmp-buffer.enable = true;
    # cmp-cmdline.enable = true;
    # cmp_luasnip.enable = true;
    # cmp-path.enable = true;
    # cmp-nvim-lsp.enable = true;
    # cmp-nvim-lua.enable = true;
    # luasnip.enable = true;
    nix.enable = true;
    harpoon.enable = true;
    telescope.enable = true;
    telescope.extensions.file_browser.enable = true;
    telescope.extensions.media_files.enable = true;
    tmux-navigator.enable = true;
    # treesitter.enable = true;
    indent-blankline.enable = true;
  };

    # TODO: Figure out how the append function works for a table and how I can set a table with specific characters added
  extraConfigLua = ''
    vim.opt.listchars:append "eol:↴"
  '';
}
