{ ... }:

{
  programs.nixvim = {
    # TODO: make mini popups pop up one line lower
    plugins.noice = {
      enable = true;
      cmdline.view = "cmdline";
      cmdline.format = {
        cmdline = { icon = false; conceal = false; };
        search_down = { icon = false; conceal = false; };
        search_up = { icon = false; conceal = false; };
        filter = { icon = false; conceal = false; };
        lua = { icon = false; conceal = false; };
        help = { icon = false; conceal = false; };
      };

      lsp = {
        signature = {
          enabled = true;
          view = "virtualtext";
        };
        progress.enabled = false;
        hover.view = "virtualtext";
        documentation.view = "virtualtext";
        override = {
          "vim.lsp.util.convert_input_to_markdown_lines" = false;
          "vim.lsp.util.stylize_markdown" = false;
          "cmp.entry.get_documentation" = false;
        };
      };
      views.mini.position.row = "100%";
      # replace confirmation shouldn't obscure the text it's asking about
      routes = [{
        view = "cmdline";
        filter.any = [ { event = "msg_show"; kind = "confirm_sub"; } ];
      }];
    };
  };
}
