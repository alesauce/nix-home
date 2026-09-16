{
  lib,
  config,
  ...
}: {
  options.languages.bash.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Enable Bash language support in neovim.";
  };

  config = lib.mkIf config.languages.bash.enable {
    plugins.lsp.servers.bashls.enable = true;
  };
}
