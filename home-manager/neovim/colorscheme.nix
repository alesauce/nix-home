{ pkgs, ... }:

{
  programs.nixvim = {
    colorschemes.catppuccin = {
      enable = true;
      background.dark = "mocha";
    };

    options = {
      termguicolors = true;
    };
  };
}
