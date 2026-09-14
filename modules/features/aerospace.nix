{
  config,
  lib,
  ...
}: let
  keyNames = {
    Return = "enter";
  };

  keyName = k: keyNames.${k} or (lib.toLower k);

  modifierNames = {
    mod = "cmd-alt-ctrl-shift";
    meh = "ctrl-shift-alt";
    cmd = "cmd";
    shift = "shift";
    ctrl = "ctrl";
    alt = "alt";
  };

  comboString = kb: builtins.concatStringsSep "-" (map (m: modifierNames.${m}) kb.modifiers ++ [(keyName kb.key)]);

  aerospaceActionHandlers = {
    spawn = cmd: "exec-and-forget ${cmd}";
    closeWindow = _: "close";
    toggleFullscreen = _: "fullscreen";
    focus = dir: "focus ${dir}";
    move = dir: "move ${dir}";
    workspace = n: "workspace ${toString n}";
    moveToWorkspace = n: "move-node-to-workspace ${toString n}";
  };

  aerospaceAction = action: let
    tag = builtins.head (builtins.attrNames action);
  in
    aerospaceActionHandlers.${tag} action.${tag};

  aerospaceKeybindings = builtins.listToAttrs (map (kb: {
      name = comboString kb;
      value = aerospaceAction kb.action;
    })
    config.flake.meta.windowManager.keybinds);
in {
  flake.darwinModules.aerospace = {
    services.aerospace = {
      enable = true;
      settings = {
        on-window-detected = [
          {
            "if" = {app-id = "org.mozilla.firefox";};
            run = "move-node-to-workspace 1";
          }
          {
            "if" = {app-id = "org.mozilla.nightly";};
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
            "if" = {app-id = "com.automattic.beeper.desktop";};
            run = "move-node-to-workspace 4";
          }
          {
            "if" = {app-id = "com.microsoft.Outlook";};
            run = "move-node-to-workspace 4";
          }
          {
            "if" = {app-id = "com.tinyspeck.slackmacgap";};
            run = "move-node-to-workspace 4";
          }
          {
            "if" = {app-id = "com.todoist.mac.Todoist";};
            run = "move-node-to-workspace 3";
          }
          {
            "if" = {app-id = "md.obsidian";};
            run = "move-node-to-workspace 3";
          }
          {
            "if" = {app-id = "us.zoom.xos";};
            run = "move-node-to-workspace 5";
          }
        ];

        mode = {
          main.binding =
            aerospaceKeybindings
            // {
              alt-y = "layout tiles horizontal vertical";
              alt-t = "layout accordion horizontal vertical";
              "${modifierNames.meh}-s" = "mode service";
              "${modifierNames.meh}-m" = "macos-native-minimize";
              alt-tab = "workspace-back-and-forth";
              alt-shift-l = "join-with right";
              alt-shift-h = "join-with left";
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
  };
}
