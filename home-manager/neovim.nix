{ vimPlugins }:

{
  enable = true;
  vimAlias = true;

  plugins = with vimPlugins; [
    nvchad
  ];
}
