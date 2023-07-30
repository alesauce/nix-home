{ pkgs, ... }:

{
  enable = true;

  options = {
    showmode = true;
    swapfile = false;
    backup = false;
    undofile = true;

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

    # TODO: Figure out how the append function works for a table and how I can set a table with specific characters added
  extraConfigLua = ''
    vim.opt.listchars:append "eol:↴"
  '';
}
