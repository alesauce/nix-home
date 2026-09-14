{theme, ...}: {
  colorschemes.${theme.family} = {
    enable = true;
    settings = {
      background = {
        dark = theme.flavor;
      };
      flavour = theme.flavor;
      integrations = {
        nvimtree = true;
        treesitter = true;
      };
    };
  };
}
