{ vimPlugins }:

{
  enable = true;

  defaultEditor = true;
  vimAlias = true;

  plugins = with vimPlugins; [
    nvchad
    vim-tmux-navigator
  ];
}
