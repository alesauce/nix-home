{
  lib,
  config,
  ...
}: {
  options.languages.kotlin.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable Kotlin language support in neovim.";
  };

  config = lib.mkIf config.languages.kotlin.enable {
    plugins.lsp.servers.kotlin_language_server.enable = true;
  };
}
