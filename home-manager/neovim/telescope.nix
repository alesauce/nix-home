{ pkgs, ... }:

{
  programs.nixvim = {
    plugins.telescope = {
      enable = true;

      # TODO: finish migrating defaults: https://github.com/alesauce/nix-dotfiles/blob/main/configs/nvim/lua/user/telescope.lua
      defaults = {
        prompt_prefix = " ";
        selection_caret = " ";
        path_display = ["smart"];

        mappings = {
          i = {
            "<C-c>" = "close";
          };

          n = {
            "<esc>" = "close";
          };
        };
      };

      extensions = {
        file_browser = {
          enable = true;
          hijackNetrw = true;
          grouped = true;
          depth = 1;
          autoDepth = true;
        };

        media_files = {
          enable = true;
          filetypes = ["png" "webp" "jpg" "jpeg"];
          find_cmd = "rg";
        };

        # TODO: add frecency extension - https://github.com/nvim-telescope/telescope-frecency.nvim
        # nixvim docs: https://nix-community.github.io/nixvim/#_plugins_telescope_extensions_frecency_enable

        # TODO: add project extension - https://github.com/nvim-telescope/telescope-project.nvim
        # nixvim docs: https://nix-community.github.io/nixvim/#_plugins_telescope_extensions_project_nvim_enable
      };
    };

    # TODO: figure out keyboard mapping issue
    maps = {
      normalVisualOp = {
        "<leader>fb".action = ":Telescope file_browser<CR>";
      };
    };
  };
}
