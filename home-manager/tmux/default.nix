{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;

    aggressiveResize = true;
    baseIndex = 1;
    clock24 = true;
    disableConfirmationPrompt = true;
    keyMode = "vi";
    mouse = true;
    newSession = true;
    terminal = "screen-256color";
    customPaneNavigationAndResize = true;

    extraConfig = (builtins.readFile ./tmux.conf);

    plugins = with pkgs.tmuxPlugins; [
      tmux-fzf
      vim-tmux-navigator
      catppuccin
      yank
    ];
  };
}
