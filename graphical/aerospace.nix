let
  hyper = "cmd-alt-ctrl-shift";
  meh = "ctrl-shift-alt";
in {
  services.aerospace = {
    enable = true;
    settings = {
      on-window-detected = [
        {
          "if" = {
            app-id = "org.mozilla.firefox";
          };
          run = "move-node-to-workspace 1";
        }
        {
          "if" = {
            app-id = "org.mozilla.nightly";
          };
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
          "if" = {
            app-id = "com.automattic.beeper.desktop";
          };
          run = "move-node-to-workspace 4";
        }
        {
          "if" = {
            app-id = "com.microsoft.Outlook";
          };
          run = "move-node-to-workspace 4";
        }
        {
          "if" = {
            app-id = "com.tinyspeck.slackmacgap";
          };
          run = "move-node-to-workspace 4";
        }
        {
          "if" = {
            app-id = "com.todoist.mac.Todoist";
          };
          run = "move-node-to-workspace 3";
        }
        {
          "if" = {
            app-id = "md.obsidian";
          };
          run = "move-node-to-workspace 3";
        }
        {
          "if" = {
            app-id = "us.zoom.xos";
          };
          run = "move-node-to-workspace 5";
        }
      ];
      mode = {
        main = {
          binding = {
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
            # multi-monitor setup
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
        };
        service = {
          binding = {
            r = ["flatten-workspace-tree" "mode main"];
            f = ["layout floating tiling" "mode main"];
            backspace = ["close-all-windows-but-current" "mode main"];
          };
        };
      };
    };
  };
}
