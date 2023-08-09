{ ... }:

{
  imports = [
    ./base-opts.nix
    ./base-plugins.nix
    ./colorscheme.nix
    ./completion.nix
    ./lsp.nix
    ./noice.nix
    ./telescope.nix
    ./treesitter.nix
  ];

  programs.nixvim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    maps = {
      normalVisualOp."<Space>" = {
        action = "<Nop>";
        silent = true;
      };
      # Remapping keys to accommodate Tarmak1
      normalVisualOp = {
        "n" = "j";
        "e" = "k";
      };
    };

    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    # TODO: Figure out how the append function works for a table and how I can set a table with specific characters added
    extraConfigLua = ''
      vim.opt.listchars:append "eol:↴"
    '';
  };
}
