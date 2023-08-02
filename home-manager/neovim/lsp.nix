{ pkgs, ... }:

{
  programs.nixvim = {
    plugins.lsp = {
      enable = true;

      keymaps = {
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
}
