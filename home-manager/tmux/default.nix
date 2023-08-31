{ pkgs, ... }:

{
  # TODO: a lot of work to verify this is going to work
  #imports = [ ./cheat-script.nix ];
  programs.tmux = {
    enable = true;
    # Tmux Python session manager:
    # https://github.com/tmux-python/tmuxp
    tmuxp.enable = true;

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

  xdg.configFile = {
    # TODO: figure out more elegant way to handle multiple config files
    "tmux-cht-command" = {
      source = ./tmux/tmux-cht-command;
      target = "tmux/tmux-cht-command";
    };
    "tmux-cht-languages" = {
      source = ./tmux/tmux-cht-languages;
      target = "tmux/tmux-cht-languages";
    };
  };
}
