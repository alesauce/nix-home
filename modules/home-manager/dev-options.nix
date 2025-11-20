{
  config,
  lib,
  ...
}: let
  mkToolOption = name: defaultEnable:
    lib.mkOption {
      type = lib.types.bool;
      default = defaultEnable;
      description = "Enable ${name} configuration";
    };
in {
  options.nix-home.user.dev = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable development tools configuration";
    };

    tools = {
      direnv.enable = mkToolOption "direnv" true;
      gh.enable = mkToolOption "GitHub CLI" true;
      ghDash.enable = mkToolOption "gh-dash" true;
      jujutsu.enable = mkToolOption "jujutsu" false;
    };

    packages = {
      dev = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [];
        description = "Additional development packages to install (added to defaults)";
      };
    };

    extraOutputsToInstall = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = ["doc" "devdoc"];
      description = "Extra package outputs to install (e.g., documentation)";
    };
  };
}
