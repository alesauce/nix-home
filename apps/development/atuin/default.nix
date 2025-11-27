{
  nix-config.apps.atuin = {
    tags = ["development"];

    home = {
      pkgs,
      config,
      lib,
      ...
    }: {
      programs.atuin = {
        enable = true;
        settings = {
          auto_sync = false;
          enter_accept = false;
          filter_mode_shell_up_key_binding = "directory";
          history_format = "{time} - {duration} - {command} - {directory}";
          keymap_mode = "vim-normal";
          secrets_filter = true;
        };
      };

      # Zsh-vi-mode overwrites the Ctrl-R keybinding for atuin, this loads atuin after zvm.
      # https://github.com/atuinsh/atuin/issues/1826
      # Only add this if zsh is enabled
      programs.zsh.initContent = lib.mkIf config.programs.zsh.enable ''
        if [[ $options[zle] = on ]]; then
          zvm_after_init_commands+=(eval "$(${lib.getExe pkgs.atuin} init zsh)")
        fi
      '';
    };
  };
}
