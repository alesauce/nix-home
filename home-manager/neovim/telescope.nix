{ ... }:

{
  programs.nixvim = {
    plugins.telescope = {
      enable = true;

      defaults = {
        prompt_prefix = " ";
        selection_caret = " ";
        path_display = ["smart"];

        mappings = {
          i = {
            "<C-c>" = "close";
            "<C-n>" = "move_selection_next";
            "<C-e>" = "move_selection_previous";
          };

          n = {
            "<esc>" = "close";
            "n" = "move_selection_next";
            "e" = "move_selection_previous";
          };
        };
      };

      extensions = {
        file_browser = {
          enable = true;
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

    maps = {
      normalVisualOp = {
        "<leader>fb".action = ":Telescope file_browser<CR>";
      };
    };
  };
}
