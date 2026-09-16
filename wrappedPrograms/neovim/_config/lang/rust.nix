{
  pkgs,
  lib,
  config,
  ...
}: {
  options.languages.rust.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable Rust language support in neovim.";
  };

  config = lib.mkIf config.languages.rust.enable {
    extraPackages = with pkgs; [
      clippy
    ];

    plugins = {
      rustaceanvim = {
        enable = true;
        settings = {
          tools = {
            enable_clippy = true;
          };
        };
      };
    };
  };
}
