{pkgs, ...}: {
  # TODO: add the tmux cheat sheet shell scripts
  programs.tmux = {
    enable = true;
    tmuxp.enable = true;
    # FIXME: https://github.com/nix-community/home-manager/issues/5952
    sensibleOnTop = false;
    aggressiveResize = true;
    clock24 = true;
    newSession = false;
    baseIndex = 1;
    plugins = with pkgs.tmuxPlugins; [
      tmux-fzf
      vim-tmux-navigator
      catppuccin
      yank
    ];
    terminal = "tmux-256color";
    historyLimit = 30000;
    disableConfirmationPrompt = true;
    keyMode = "vi";
    mouse = true;
    customPaneNavigationAndResize = true;
    extraConfig = ''
      # update the env when attaching to an existing session
      set -g update-environment -r
      # automatically renumber windows
      set -g renumber-windows on

      bind R source-file ~/.config/tmux/tmux.conf \; display-message "Config reloaded..."

      # Copy mode keybindings
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

      # Open panes in current directory with new bindings
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      bind c new-window -c "#{pane_current_path}"
      unbind '"'
      unbind %

      bind : command-prompt
      set-window-option -g automatic-rename
    '';
  };

  home.shellAliases = {
    ",tk" = "tmux kill-session";
    ",tka" = "tmux kill-server";
    ",tkt" = "tmux kill-session -t";
    ",tls" = "tmux ls";
    ",tn" = "tmux new";
    ",ta" = "tmux attach -t";
  };
}
