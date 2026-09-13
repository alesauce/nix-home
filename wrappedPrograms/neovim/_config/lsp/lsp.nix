{
  config = {
    extraConfigLuaPre = ''
      function _M.bemol()
          local bemol_dir = vim.fs.find({ ".bemol" }, { upward = true, type = "directory" })[1]
          local ws_folders_lsp = {}
          if bemol_dir then
              local file = io.open(bemol_dir .. "/ws_root_folders", "r")
              if file then
                  for line in file:lines() do
                      table.insert(ws_folders_lsp, line)
                  end
                  file:close()
              end

              for _, line in ipairs(ws_folders_lsp) do
                  vim.lsp.buf.add_workspace_folder(line)
              end
          end
      end
    '';

    plugins = {
      lsp = {
        enable = true;
        servers = {
          gopls.enable = true;
          jsonls.enable = true;
          lua_ls.enable = true;
          pyright.enable = true;
          yamlls.enable = true;
        };
        keymaps = {
          silent = true;
          diagnostic = {
            "<leader>f" = "open_float";
            "[d" = "goto_prev";
            "]d" = "goto_next";
            "<leader>q" = "setloclist";
          };
          lspBuf = {
            "gD" = "declaration";
            "gd" = "definition";
            "K" = "hover";
            "gi" = "implementation";
            "<C-k>" = "signature_help";
            "<leader>rn" = "rename";
            "gr" = "references";
          };
        };
        onAttach = ''
          _M.bemol()
        '';
      };
      lspkind = {
        enable = true;
        cmp.enable = false;
      };
    };
  };
}
