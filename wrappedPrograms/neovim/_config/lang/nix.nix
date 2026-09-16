{
  lib,
  config,
  ...
}: {
  options.languages.nix.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Enable Nix language support in neovim.";
  };

  config = lib.mkIf config.languages.nix.enable {
    autoCmd = [
      {
        event = "FileType";
        pattern = "nix";
        command = "setlocal tabstop=2 shiftwidth=2 softtabstop=2";
      }
    ];

    plugins = {
      nix.enable = true;
      lsp.servers.nixd = {
        enable = true;
        extraOptions = {
          offset_encoding = "utf-8";
        };
      };
      none-ls.sources = {
        formatting.alejandra.enable = true;
        diagnostics = {
          statix.enable = true;
          deadnix.enable = true;
        };
      };
    };
  };
}
