{
  config = {
    plugins = {
      nvim-ufo = {
        enable = true;
        setupLspCapabilities = true;
      };
    };

    opts = {
      foldenable = true;
      foldcolumn = "0";
      foldlevel = 99;
      foldlevelstart = 99;
      foldtext = "";
    };

    extraConfigLua = ''
      vim.opt.fillchars:append "fold: "
    '';
  };
}
