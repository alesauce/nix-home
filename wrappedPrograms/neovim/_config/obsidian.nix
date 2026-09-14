{
  plugins.obsidian = {
    enable = false;
    settings = {
      log_level = "info";
      sort_reversed = true;
      templates.subdir = "_templates";
      daily_notes = {
        folder = "logs";
      };
      picker.name = "snacks.pick";
      workspaces = [
        {
          name = "main";
          path = "~/workplace/vaults/second-brain";
        }
      ];
    };
  };

  keymaps = [
    {
      key = "<leader>oq";
      action = ":ObsidianQuickSwitch<CR>";
      options = {
        noremap = true;
        desc = "Obsidian quick switcher";
      };
    }
    {
      key = "<leader>on";
      action = ":ObsidianNew<CR>";
      options = {
        noremap = true;
        desc = "Obsidian create new note";
      };
    }
    {
      key = "<leader>ob";
      action = ":ObsidianBacklinks<CR>";
      options = {
        noremap = true;
        desc = "Backlinks to current note";
      };
    }
    {
      key = "<leader>ot";
      action = ":ObsidianToday<CR>";
      options = {
        noremap = true;
        desc = "Open/create daily note";
      };
    }
    {
      key = "<leader>os";
      action = ":ObsidianSearch";
      options = {
        noremap = true;
        desc = "Search for or create notes in vault";
      };
    }
    {
      key = "<leader>ol";
      action = ":ObsidianLinks<CR>";
      options = {
        noremap = true;
        desc = "Collect all links within current buffer into a picker window";
      };
    }
  ];

  plugins.which-key.settings.spec = [
    {
      __unkeyed = "<leader>o";
      group = "Obsidian";
    }
  ];
}
