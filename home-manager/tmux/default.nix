{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;

    baseIndex = 1;
    clock24 = true;
    disableConfirmationPrompt = true;
    keyMode = "vi";
    mouse = true;
    newSession = true;
    terminal = "screen-256color";

    extraConfig = (builtins.readFile ./tmux.conf);

    plugins = with pkgs.tmuxPlugins; [
      vim-tmux-navigator
      catppuccin
      yank
    ];
  };
}
