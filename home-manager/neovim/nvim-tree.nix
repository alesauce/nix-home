{ ... }:

{
  programs.nixvim = {
    plugins.nvim-tree = {
      enable = true;
      disableNetrw = true;
      autoReloadOnWrite = true;
      hijackNetrw = true;
      hijackUnnamedBufferWhenOpening = true;
      sortBy = "case_sensitive";

      filesystemWatchers.enable = true;
    };

    maps = {
      normalVisualOp = {
        "<leader>nt".action = ":NvimTreeFocus<CR>";
      };
    };
  };
}
