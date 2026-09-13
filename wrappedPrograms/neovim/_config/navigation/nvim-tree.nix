{
  plugins.nvim-tree = {
    enable = true;
    settings = {
      disable_netrw = true;
      hijack_netrw = true;
      auto_reload_on_write = true;
      hijack_unnamed_buffer_when_opening = true;
      sort_by = "case_sensitive";
      filesystem_watchers.enable = true;
    };
  };
  keymaps = [
    {
      key = "<leader>nt";
      action = ":NvimTreeFocus<CR>";
    }
  ];
}
