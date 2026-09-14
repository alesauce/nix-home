{
  plugins = {
    blink-cmp = {
      enable = true;
      settings = {
        keymap = {
          preset = "enter";
        };
        completion = {
          list = {
            selection = {
              preselect = false;
            };
          };
        };
      };
    };
    cmp-tmux.enable = true;
    blink-compat.enable = true;
    friendly-snippets.enable = true;
  };
}
