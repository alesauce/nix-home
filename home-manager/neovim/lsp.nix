{ ... }:

{
  programs.nixvim = {
    plugins = {
      cmp-nvim-lsp.enable = true;
      cmp-nvim-lsp-signature-help.enable = true;

      lsp = {
        enable = true;

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

        capabilities = ''
          client_capabilities = vim.lsp.protocol.make_client_capabilities()
          capabilities = require('cmp_nvim_lsp').default_capabilities(client_capabilities)
        '';

        onAttach = ''
          vim.cmd [[ command! Format execute 'lua vim.lsp.buf.formatting()' ]]
          if client.server_capabilities.documentHighlight then
            vim.api.nvim_exec(
              [[
              augroup lsp_document_highlight
                autocmd! * <buffer>
                autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
                autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
              augroup END
            ]],
              false
            )
          end
        '';

        servers = {
          bashls.enable = true;
          gopls.enable = true;
          jsonls.enable = true;
          lua-ls.enable = true;
          nil_ls.enable = true;
          pyright.enable = true;
          rust-analyzer.enable = true;
          tsserver.enable = true;
          yamlls.enable = true;
        };
      };
    };
  };
}
