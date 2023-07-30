{ pkgs, ... }:

{
  programs.nixvim = {
    options = {
      showmode = false;
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
    };
  };
}
