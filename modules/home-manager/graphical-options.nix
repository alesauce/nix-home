{
  config,
  lib,
  ...
}: {
  options.nix-home.user.graphical = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable graphical user configuration";
    };

    firefox = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable Firefox configuration";
      };
    };

    sway = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable Sway/i3 window manager configuration";
      };
    };

    dconf.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable dconf configuration";
    };
  };
}
