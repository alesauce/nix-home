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
      {
        plugin = vim-tmux-navigator;
        extraConfig = ''
          bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h'  'select-pane -L'
          bind-key -n 'C-n' if-shell "$is_vim" 'send-keys C-n'  'select-pane -D'
          bind-key -n 'C-e' if-shell "$is_vim" 'send-keys C-e'  'select-pane -U'
          bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l'  'select-pane -R'
        '';
      }
      catppuccin
      yank
    ];
  };
}
