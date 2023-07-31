{ pkgs, ... }:

{
  programs.nixvim.plugins.telescope = {
    enable = true;

    defaults = {
      prompt_prefix = " ";
      selection_caret = " ";
      path_display = ["smart"];
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
    };
  };
}
