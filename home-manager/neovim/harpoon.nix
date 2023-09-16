{ ... }:

{
  programs.nixvim = {
    # TODO: review docs and configure harpoon: https://github.com/ThePrimeagen/harpoon
    # nixvim docs: https://nix-community.github.io/nixvim/#_plugins_harpoon_enable
    plugins.harpoon = {
      enable = true;

      keymaps = {
        addFile = "<leader>ha";
        navFile = {
          "1" = "<C-l>";
          "2" = "<C-u>";
          "3" = "<C-y>";
          "4" = "<C-;>";
        };
        # TODO: create tmuxp project sessions with standard tmux identifier for notes pane:
        # https://nix-community.github.io/nixvim/plugins/harpoon/keymaps.html#pluginsharpoonkeymapstmuxgototerminal
      };
    };
  };
}
