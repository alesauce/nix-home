{pkgs, ...}: {
  config = {
    extraPlugins = with pkgs.vimPlugins; [
      harpoon2
    ];

    extraConfigLua = builtins.readFile ./harpoon.lua;

    plugins.which-key.settings.spec = [
      {
        __unkeyed = "<leader>h";
        group = "Harpoon Navigation";
      }
    ];
  };
}
