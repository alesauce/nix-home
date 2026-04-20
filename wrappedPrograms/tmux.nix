{inputs, ...}: {
  perSystem = {pkgs, ...}: {
    packages.tmux = inputs.wrapper-modules.wrappers.tmux.wrap {
      inherit pkgs;

      sourceSensible = true;
      aggressiveResize = true;
      clock24 = true;
      baseIndex = 1;
      terminal = "tmux-256color";
      historyLimit = 30000;
      disableConfirmationPrompt = true;
      modeKeys = "vi";
      mouse = true;
      # vimVisualKeys covers v + y; C-v rectangle-toggle added in configAfter
      vimVisualKeys = true;

      plugins = with pkgs.tmuxPlugins; [
        {plugin = tmux-fzf;}
        {plugin = vim-tmux-navigator;}
        {plugin = catppuccin;}
        {plugin = yank;}
      ];

      configBefore = ''
        # reset update-environment to defaults before appending
        set -g update-environment -r
        set -g renumber-windows on
      '';

      configAfter = ''
        bind R source-file ~/.config/tmux/tmux.conf \; display-message "Config reloaded..."

        bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle

        bind | split-window -h -c "#{pane_current_path}"
        bind - split-window -v -c "#{pane_current_path}"
        bind c new-window -c "#{pane_current_path}"
        unbind '"'
        unbind %

        bind : command-prompt
        set-window-option -g automatic-rename
      '';
    };
  };
}
