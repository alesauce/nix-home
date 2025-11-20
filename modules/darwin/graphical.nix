# Darwin-specific graphical system module
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.nix-home.system.graphical;
  hyper = "cmd-alt-ctrl-shift";
  meh = "ctrl-shift-alt";
in {
  options.nix-home.system.graphical = import ./graphical-options.nix {inherit lib;};

  config = lib.mkIf cfg.enable {
    # Fonts
    fonts = lib.mkIf cfg.fonts.enable {
      packages =
        (with pkgs; [
          monaspace
          recursive
          nerd-fonts.hack
          noto-fonts
          noto-fonts-cjk-sans
          noto-fonts-cjk-serif
        ])
        ++ cfg.fonts.additionalPackages;
    };

    # Stylix fonts
    stylix.fonts = lib.mkIf cfg.fonts.enable {
      sansSerif = {
        package = pkgs.ibm-plex;
        name = "IBM Plex Sans";
      };
      serif = {
        package = pkgs.ibm-plex;
        name = "IBM Plex Serif";
      };
      monospace = {
        package = pkgs.monaspace;
        name = "Argon Monaspace Font";
      };
      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
    };

    # AeroSpace window manager
    services.aerospace = lib.mkIf cfg.windowManager.aerospace.enable {
      enable = true;
      settings = {
        on-window-detected = [
          {
            "if".app-id = "org.mozilla.firefox";
            run = "move-node-to-workspace 1";
          }
          {
            "if".app-id = "org.mozilla.nightly";
            run = "move-node-to-workspace 1";
          }
          {
            "if" = {
              app-id = "org.mozilla.firefox";
              window-title-regex-substring = "Picture-in-Picture";
            };
            run = "layout floating";
          }
          {
            "if" = {
              app-id = "org.mozilla.nightly";
              window-title-regex-substring = "Picture-in-Picture";
            };
            run = "layout floating";
          }
          {
            "if".app-id = "com.automattic.beeper.desktop";
            run = "move-node-to-workspace 4";
          }
          {
            "if".app-id = "com.microsoft.Outlook";
            run = "move-node-to-workspace 4";
          }
          {
            "if".app-id = "com.tinyspeck.slackmacgap";
            run = "move-node-to-workspace 4";
          }
          {
            "if".app-id = "com.todoist.mac.Todoist";
            run = "move-node-to-workspace 3";
          }
          {
            "if".app-id = "md.obsidian";
            run = "move-node-to-workspace 3";
          }
          {
            "if".app-id = "us.zoom.xos";
            run = "move-node-to-workspace 5";
          }
        ];
        mode = {
          main.binding = {
            alt-y = "layout tiles horizontal vertical";
            alt-t = "layout accordion horizontal vertical";
            "${hyper}-l" = "focus right";
            "${hyper}-k" = "focus up";
            "${hyper}-j" = "focus down";
            "${hyper}-h" = "focus left";
            ctrl-f1 = "workspace 1";
            ctrl-f2 = "workspace 2";
            ctrl-f3 = "workspace 3";
            ctrl-f4 = "workspace 4";
            ctrl-f5 = "workspace 5";
            ctrl-f6 = "workspace 6";
            "${meh}-1" = "move-node-to-workspace 1";
            "${meh}-2" = "move-node-to-workspace 2";
            "${meh}-3" = "move-node-to-workspace 3";
            "${meh}-4" = "move-node-to-workspace 4";
            "${meh}-5" = "move-node-to-workspace 5";
            "${meh}-6" = "move-node-to-workspace 6";
            "${meh}-s" = "mode service";
            "${meh}-m" = "macos-native-minimize";
            alt-tab = "workspace-back-and-forth";
            "${hyper}-f" = "fullscreen";
            "${meh}-l" = "join-with right";
            "${meh}-h" = "join-with left";
            cmd-ctrl-l = "focus-monitor next";
            cmd-ctrl-h = "focus-monitor prev";
            cmd-alt-l = "move-workspace-to-monitor next";
            cmd-alt-h = "move-workspace-to-monitor prev";
            ctrl-shift-1 = "summon-workspace 1";
            ctrl-shift-2 = "summon-workspace 2";
            ctrl-shift-3 = "summon-workspace 3";
            ctrl-shift-4 = "summon-workspace 4";
            ctrl-shift-5 = "summon-workspace 5";
            ctrl-shift-6 = "summon-workspace 6";
          };
          service.binding = {
            r = ["flatten-workspace-tree" "mode main"];
            f = ["layout floating tiling" "mode main"];
            backspace = ["close-all-windows-but-current" "mode main"];
          };
        };
      };
    };

    # Homebrew casks
    homebrew.casks = [
      {
        name = "aldente";
        greedy = true;
      }
      {
        name = "appcleaner";
        greedy = true;
      }
      {
        name = "brave-browser";
        greedy = true;
      }
      {
        name = "block-goose";
        greedy = true;
      }
      {
        name = "firefox@nightly";
        greedy = true;
      }
      {
        name = "ghostty";
        greedy = true;
      }
      {
        name = "keymapp";
        greedy = true;
      }
      {
        name = "obsidian";
        greedy = true;
      }
      {
        name = "raycast";
        greedy = true;
      }
      {
        name = "reader";
        greedy = true;
      }
      {
        name = "spotify";
        greedy = true;
      }
    ];

    # Touch ID for CLI
    security.pam.services.sudo_local.touchIdAuth = true;

    # System preferences
    system.defaults = {
      controlcenter.BatteryShowPercentage = true;
      CustomUserPreferences."com.apple.HIToolbox" = {
        AppleCurrentKeyboardLayoutInputSourceID = "com.apple.keylayout.US";
        AppleEnabledInputSources = [
          {
            InputSourceKind = "Keyboard Layout";
            "KeyboardLayout ID" = 0;
            "KeyboardLayout Name" = "U.S.";
          }
          {
            "Bundle ID" = "com.apple.CharacterPaletteIM";
            InputSourceKind = "Non Keyboard Input Method";
          }
          {
            InputSourceKind = "Keyboard Layout";
            "KeyboardLayout ID" = 12825;
            "KeyboardLayout Name" = "Colemak";
          }
        ];
      };
      dock = {
        autohide = true;
        orientation = "right";
        show-recents = false;
        mru-spaces = false;
        persistent-apps = [
          {app = "/System/Applications/Launchpad.app";}
          {app = "/System/Volumes/Data/Applications/Ghostty.app";}
          {app = "/System/Volumes/Data/Applications/Firefox Nightly.app";}
          {app = "/System/Volumes/Data/Applications/Obsidian.app";}
        ];
      };
      finder = {
        CreateDesktop = false;
        QuitMenuItem = true;
        FXRemoveOldTrashItems = true;
      };
      menuExtraClock.Show24Hour = true;
      NSGlobalDomain = {
        AppleICUForce24HourTime = true;
        AppleInterfaceStyle = "Dark";
        "com.apple.keyboard.fnState" = true;
        "com.apple.swipescrolldirection" = false;
      };
      screencapture.location = "/Users/alesauce/screenshots";
      spaces.spans-displays = false;
    };
    system.keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
    };
  };
}
