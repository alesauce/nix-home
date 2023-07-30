{ tmuxPlugins }:

{
  enable = true;

  baseIndex = 1;
  clock24 = true;
  disableConfirmationPrompt = true;
  keyMode = "vi";
  mouse = true;
  newSession = true;
  terminal = "screen-256color";
    
  extraConfig = (builtins.readFile ./configs/tmux/tmux.conf);

  plugins = with tmuxPlugins; [
    vim-tmux-navigator
    catppuccin
    yank
  ];
}
