{
  config = {
    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    keymaps = [
      {
        key = "<Space>";
        action = "<Nop>";
        options = {
          silent = true;
          desc = "Mapping space to Nop for global leader use";
        };
      }
    ];

    luaLoader.enable = true;

    opts = {
      showmode = false;
      swapfile = false;
      backup = false;
      undofile = true;
      termguicolors = true;
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
      smartindent = false;
    };

    extraConfigLua = ''
      vim.opt.listchars:append "eol:↴"
    '';

    viAlias = true;
    vimAlias = true;

    performance = {
      byteCompileLua.enable = true;
    };
  };
}
