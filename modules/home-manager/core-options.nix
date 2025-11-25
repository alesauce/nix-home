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
  options.nix-home.user = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable nix-home user configuration";
    };

    core = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable core user configuration";
      };

      username = lib.mkOption {
        type = lib.types.str;
        default = "alesauce";
        description = "Username for home-manager configuration";
      };

      homeDirectory = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Home directory path (leave empty to auto-detect)";
      };

      stateVersion = lib.mkOption {
        type = lib.types.str;
        default = "23.11";
        description = "home-manager state version";
      };

      tools = {
        git = {
          enable = mkToolOption "git" true;
          userName = lib.mkOption {
            type = lib.types.str;
            default = "Alexander Sauceda";
            description = "Git user name";
          };
          userEmail = lib.mkOption {
            type = lib.types.str;
            default = "alexander@alexandersauceda.dev";
            description = "Git user email";
          };
          extraConfig = lib.mkOption {
            type = lib.types.attrs;
            default = {};
            description = "Additional git configuration";
          };
        };

        neovim = {
          enable = mkToolOption "neovim" true;
          package = lib.mkOption {
            type = lib.types.nullOr lib.types.package;
            default = null;
            description = "Neovim package to use (null = use nixvim-flake)";
          };
        };

        tmux.enable = mkToolOption "tmux" true;
        zsh.enable = mkToolOption "zsh" true;
        starship.enable = mkToolOption "starship" true;
        atuin.enable = mkToolOption "atuin" true;
        btop.enable = mkToolOption "btop" true;
        htop.enable = mkToolOption "htop" true;
        bat.enable = mkToolOption "bat" true;
        zoxide.enable = mkToolOption "zoxide" true;
      };

      packages = {
        core = lib.mkOption {
          type = lib.types.listOf lib.types.package;
          default = [];
          description = "Additional core packages to install (added to defaults)";
        };
      };

      shellAliases = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = {};
        description = "Additional shell aliases (merged with defaults)";
      };

      stylix = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Enable stylix theming";
        };

        base16Scheme = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          default = null;
          description = "Path to base16 color scheme (null = use default)";
        };

        image = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          default = null;
          description = "Path to wallpaper image for theming";
        };
      };
    };
  };
}
