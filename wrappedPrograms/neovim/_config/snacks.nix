{
  lib,
  config,
  ...
}: {
  plugins = {
    snacks = {
      enable = true;
      settings = {
        indent.enabled = true;
        quickfile.enabled = true;
        scope.enabled = true;
        scroll.enabled = true;
        # TODO: configure scratch plugin for quick notes/slipbox https://github.com/folke/snacks.nvim/blob/main/docs/scratch.md
        terminal = {
          enabled = true;
        };
        picker = {
          enabled = true;
          matcher = {
            frecency = true;
          };
        };
        explorer = {
          replace_netrw = true;
        };
      };
    };
    which-key.settings.spec = [
      {
        mode = "n";
        __unkeyed-1 = "<leader>t";
        icon = "";
        group = "Terminal";
      }
    ];
  };

  keymaps =
    lib.mkIf (config.plugins.snacks.enable && lib.hasAttr "picker" config.plugins.snacks.settings)
    [
      {
        mode = "n";
        key = "<leader>tt";
        action = "<cmd>lua Snacks.terminal.toggle()<cr>";
        options = {
          desc = "Toggle terminal";
        };
      }
      {
        mode = "n";
        key = "<leader>tg";
        action = "<cmd>lua Snacks.terminal.get()<cr>";
        options = {
          desc = "Get/create terminal";
        };
      }
      {
        mode = "n";
        key = "<leader>to";
        action = "<cmd>lua Snacks.terminal.open()<cr>";
        options = {
          desc = "Open terminal";
        };
      }
      {
        mode = "n";
        key = "<leader>to";
        action = "<cmd>lua Snacks.terminal.list()<cr>";
        options = {
          desc = "List terminals";
        };
      }
      {
        mode = "n";
        key = "<leader>fc";
        action = "<cmd>lua Snacks.picker.commands()<cr>";
        options = {
          desc = "Find commands";
        };
      }
      {
        mode = "n";
        key = "<leader>fd";
        action = "<cmd>lua Snacks.picker.diagnostics_buffer()<cr>";
        options = {
          desc = "Find buffer diagnostics";
        };
      }
      {
        mode = "n";
        key = "<leader>fD";
        action = "<cmd>lua Snacks.picker.diagnostics()<cr>";
        options = {
          desc = "Find workspace diagnostics";
        };
      }
      {
        mode = "n";
        key = "<leader>fe";
        action = "<cmd>lua Snacks.explorer()<cr>";
        options = {
          desc = "File Explorer";
        };
      }
      {
        mode = "n";
        key = "<leader>fh";
        action = "<cmd>lua Snacks.picker.help()<cr>";
        options = {
          desc = "Find help tags";
        };
      }
      {
        mode = "n";
        key = "<leader>fk";
        action = "<cmd>lua Snacks.picker.keymaps()<cr>";
        options = {
          desc = "Find keymaps";
        };
      }
      {
        mode = "n";
        key = "<leader>fs";
        action = "<cmd>lua Snacks.picker.lsp_symbols()<cr>";
        options = {
          desc = "Find lsp document symbols";
        };
      }
      {
        mode = "n";
        key = "<leader>fS";
        action = ''<cmd>lua Snacks.picker.spelling({layout = { preset = "select" }})<CR>'';
        options = {
          desc = "Find spelling suggestions";
        };
      }
      {
        mode = "n";
        key = "<leader>fu";
        action = "<cmd>lua Snacks.picker.undo()<cr>";
        options = {
          desc = "Undo History";
        };
      }
      {
        mode = "n";
        key = "<leader>f<CR>";
        action = "<cmd>lua Snacks.picker.resume()<cr>";
        options = {
          desc = "Resume find";
        };
      }
      {
        mode = "n";
        key = "<leader>fw";
        action = "<cmd>lua Snacks.picker.grep()<cr>";
        options = {
          desc = "Live grep";
        };
      }
      {
        mode = "n";
        key = "<leader>fC";
        action = "<cmd>lua Snacks.picker.git_commits()<cr>";
        options = {
          desc = "Find git commits";
        };
      }
      {
        mode = "n";
        key = "<leader>fA";
        action = "<cmd>lua Snacks.picker.lsp_code_actions()<cr>";
        options = {
          desc = "Code Action";
        };
      }
      {
        mode = "n";
        key = "<leader>ft";
        action = "<cmd>lua Snacks.picker.todo_comments()<cr>";
        options = {
          desc = "Todo comments";
        };
      }
    ];
}
