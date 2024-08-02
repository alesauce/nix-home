{
  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      auto_sync = false;
      enter_accept = false;
      filter_mode_shell_up_key_binding = "directory";
      history_format = "{time} - {duration} - {command} - {directory}";
      keymap_mode = "vim-normal";
      secrets_filter = true;
    };
  };
}
