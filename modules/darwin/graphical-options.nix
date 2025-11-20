{
  config,
  lib,
  ...
}: {
  options.nix-home.system.graphical = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable graphical system configuration";
    };

    fonts = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable custom font configuration";
      };

      additionalPackages = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [];
        description = "Additional font packages to install";
      };
    };

    windowManager = {
      aerospace = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Enable AeroSpace window manager (macOS only)";
        };
      };

      sway = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Enable Sway window manager (Linux only)";
        };
      };
    };

    wallpaper = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Path to wallpaper image";
      example = lib.literalExpression "./wallpapers/my-wallpaper.jpg";
    };
  };
}
