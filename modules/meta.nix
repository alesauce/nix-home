{lib, ...}: {
  options.flake.meta = lib.mkOption {
    description = "Cross-cutting flake-level identity and config data, contributed to by multiple modules (owner.nix, theme.nix, etc.) and read by wrapped programs and hosts alike.";
    type = lib.types.submodule {
      options = {
        owner = lib.mkOption {
          description = "Identity of the flake's primary owner/user.";
          type = lib.types.submodule {
            options = {
              email = lib.mkOption {
                type = lib.types.str;
                description = "Owner's email address.";
              };
              name = lib.mkOption {
                type = lib.types.str;
                description = "Owner's display name.";
              };
              username = lib.mkOption {
                type = lib.types.str;
                description = "Owner's system/GitHub username.";
              };
            };
          };
        };

        theme = lib.mkOption {
          description = "The flake-wide color theme. Applied directly by stylix, and derived by wrapped programs stylix can't reach.";
          type = lib.types.submodule {
            options = {
              family = lib.mkOption {
                type = lib.types.str;
                description = ''Base16 theme family (e.g. "catppuccin"), matching a tinted-schemes base16/<family>-<flavor>.yaml file.'';
              };
              flavor = lib.mkOption {
                type = lib.types.str;
                description = ''Theme flavor/variant within the family (e.g. "mocha").'';
              };
              palette = lib.mkOption {
                type = lib.types.attrsOf (lib.types.strMatching "[0-9a-fA-F]{6}");
                description = "The 16 base16 colors (base00..base0F), as lowercase hex strings without a leading '#', parsed from the family/flavor's yaml file.";
              };
              wallpaper = lib.mkOption {
                type = lib.types.path;
                description = "The wallpaper image, applied directly by stylix's own targets (e.g. sway) and spawned manually by tools stylix has no target for (e.g. niri).";
              };
            };
          };
        };

        windowManager = lib.mkOption {
          description = "Cross-platform window-manager configuration. Written once here, translated into each compositor/WM's own native config by that tool's own module (e.g. modules/features/niri.nix).";
          type = lib.types.submodule {
            options = {
              keybinds = lib.mkOption {
                description = "Keybindings, in tool-agnostic form.";
                type = lib.types.listOf (lib.types.submodule {
                  options = {
                    modifiers = lib.mkOption {
                      type = lib.types.listOf (lib.types.enum ["mod" "meh" "cmd" "shift" "ctrl" "alt"]);
                      default = ["mod"];
                      description = ''
                        Modifier keys held with `key`. "mod" and "meh" are
                        each a single logical tier (translated per-tool to
                        that tool's own combo, e.g. aerospace's hyper/meh
                        chords) rather than individually-composable keys.
                      '';
                    };
                    key = lib.mkOption {
                      type = lib.types.str;
                      description = ''The non-modifier key, e.g. "Return", "h", "1".'';
                    };
                    action = lib.mkOption {
                      description = "What this keybinding does.";
                      type = lib.types.attrTag {
                        spawn = lib.mkOption {
                          type = lib.types.str;
                          description = "Shell command to spawn.";
                        };
                        closeWindow = lib.mkOption {
                          type = lib.types.submodule {};
                          description = "Close the focused window.";
                        };
                        toggleFullscreen = lib.mkOption {
                          type = lib.types.submodule {};
                          description = "Toggle fullscreen on the focused window.";
                        };
                        focus = lib.mkOption {
                          type = lib.types.enum ["left" "right" "up" "down"];
                          description = "Move focus in a direction.";
                        };
                        move = lib.mkOption {
                          type = lib.types.enum ["left" "right" "up" "down"];
                          description = "Move the focused window/column in a direction.";
                        };
                        workspace = lib.mkOption {
                          type = lib.types.ints.positive;
                          description = "Switch to workspace N.";
                        };
                        moveToWorkspace = lib.mkOption {
                          type = lib.types.ints.positive;
                          description = "Send the focused window/column to workspace N.";
                        };
                      };
                    };
                  };
                });
                default = [];
              };
            };
          };
        };
      };
    };
  };
}
