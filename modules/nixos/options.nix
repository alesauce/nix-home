{lib}: {
  enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable core system configuration";
  };

  hostType = lib.mkOption {
    type = lib.types.enum ["darwin" "nixos"];
    description = "Host platform type (darwin or nixos)";
  };

  nix = {
    settings = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Additional Nix daemon settings to merge with defaults";
    };

    extraConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = "Extra Nix configuration to append to nix.conf";
    };
  };

  documentation = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable system documentation (man pages, info, etc.)";
    };
  };

  aspell = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable aspell spell checker with dictionaries";
    };
  };

  stylix = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable stylix theming system";
    };

    base16Scheme = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Path to base16 color scheme (null = catppuccin-mocha)";
    };

    wallpaper = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Path to wallpaper image for theming";
    };
  };
}
