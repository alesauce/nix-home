{ pkgs, ... }:

{
  programs.nixvim = {
    plugins.luasnip = {
      enable = true;
    };

    plugins.nvim-cmp = {
      enable = true;
      snippet.expand = "luasnip";

      experimental = {
        "ghost_text" = true;
        "native_menu" = false;
      };

      sources = [
        { name = "nvim_lsp"; }
        { name = "nvim_lua"; }
        { name = "luasnip"; }
        { name = "path"; }
        { name = "buffer"; }
      ];

      formatting = {
        format = ''
          local kind_icons = {
            Text = "",
            Method = "m",
            Function = "",
            Constructor = "",
            Field = "",
            Variable = "",
            Class = "",
            Interface = "",
            Module = "",
            Property = "",
            Unit = "",
            Value = "",
            Enum = "",
            Keyword = "",
            Snippet = "",
            Color = "",
            File = "",
            Reference = "",
            Folder = "",
            EnumMember = "",
            Constant = "",
            Struct = "",
            Event = "",
            Operator = "",
            TypeParameter = "",
          }
          function(entry, vim_item)
            -- Kind icons
            -- vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
            vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
            vim_item.menu = ({
              nvim_lsp = "[LSP]",
              nvim_lua = "[NVIM_LUA]", 
              luasnip = "[Snippet]",
              buffer = "[Buffer]",
              path = "[Path]",
            })[entry.source.name]
            return vim_item
          end
        '';
      };

      window.documentation.border = "rounded";
    };
  };
}
