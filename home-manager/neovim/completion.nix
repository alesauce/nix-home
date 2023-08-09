{ pkgs, ... }:

{
  programs.nixvim = {
    plugins = {
      cmp-git.enable = true;
      cmp-path.enable = true;
      cmp-tmux.enable = true;
      cmp-treesitter.enable = true;
      cmp-buffer.enable = true;
      cmp-cmdline.enable = true;
      cmp-nvim-lua.enable = true;
      cmp-nvim-lsp.enable = true;
      cmp-nvim-lsp-signature-help.enable = true;
      luasnip.enable = true;
      cmp_luasnip.enable = true;

      nvim-cmp = {
        enable = true;
        mappingPresets = ["insert" "cmdline"];
        snippet.expand = "luasnip";
        sources = [
          { name = "path"; }
          { name = "nvim_lsp"; }
          { name = "nvim_lsp_signature_help"; }
          { name = "luasnip"; }
          { name = "buffer"; }
          { name = "nvim_lua"; }
        ];
        formatting = {
          fields = [ "kind" "abbr" "menu" ];
          format = ''
            function(entry, vim_item)
              -- Kind icons
              -- vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
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
        mapping = {
          "<CR>" = "cmp.mapping.confirm({select = false})";
          "<C-Tab>" = "cmp.mapping.complete_common_string()";
          "<Tab>" = {
            modes = [ "i" "s" ];
            action = ''
              function(fallback)
                local cmp = require('cmp')
                local luasnip = require('luasnip')
                if cmp.visible() then
                  if not cmp.complete_common_string() then
                    cmp.select_next_item(select_opts)
                  end
                elseif check_backspace() then
                  fallback()
                elseif luasnip.expandable() then
                  luasnip.expand()
                elseif luasnip.expand_or_locally_jumpable() then
                  luasnip.expand_or_jump()
                else
                  cmp.complete()
                end
              end
            '';
          };
          "<S-Tab>" = {
            modes = [ "i" "s" ];
            action = ''
              function(fallback)
                local cmp = require('cmp')
                local luasnip = require('luasnip')
                if cmp.visible() then
                  cmp.select_prev_item(select_opts)
                elseif luasnip.locally_jumpable(-1) then
                  luasnip.jump(-1)
                else
                  fallback()
                end
              end
            '';
          };
        };
      };
    };

    options = {
      completeopt = [ "menu" "menuone" "noselect" ];
    };

    extraPlugins = with pkgs.vimPlugins; [
      friendly-snippets
    ];

    extraConfigLua = ''
      require("luasnip/loaders/from_vscode").lazy_load()

      function check_backspace()
        local col = vim.fn.col(".") - 1
        return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
      end
    '';
  };
}
