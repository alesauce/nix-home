{ vimPlugins }:

{
  enable = true;

  defaultEditor = true;
  vimAlias = true;

  plugins = with vimPlugins; [
    vim-tmux-navigator
  ];
}
