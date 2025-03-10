{
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
            app-id = "org.mozilla.firefox";
            window-title-regex-substring = "Picture-in-Picture";
          };
          run = "layout floating";
        }
        {
          "if" = {
            app-id = "com.automattic.beeper.desktop";
          };
          run = "move-node-to-workspace 5";
        }
      ];
      mode = {
        main = {
          binding = {
            alt-y = "layout tiles horizontal vertical";
            alt-t = "layout accordion horizontal vertical";
            cmd-alt-ctrl-shift-l = "focus right";
            cmd-alt-ctrl-shift-k = "focus up";
            cmd-alt-ctrl-shift-j = "focus down";
            cmd-alt-ctrl-shift-h = "focus left";
            ctrl-f1 = "workspace 1";
            ctrl-f2 = "workspace 2";
            ctrl-f3 = "workspace 3";
            ctrl-f4 = "workspace 4";
            ctrl-f5 = "workspace 5";
            ctrl-f6 = "workspace 6";
            ctrl-shift-alt-1 = "move-node-to-workspace 1";
            ctrl-shift-alt-2 = "move-node-to-workspace 2";
            ctrl-shift-alt-3 = "move-node-to-workspace 3";
            ctrl-shift-alt-4 = "move-node-to-workspace 4";
            ctrl-shift-alt-5 = "move-node-to-workspace 5";
            ctrl-shift-alt-6 = "move-node-to-workspace 6";
            ctrl-shift-alt-s = "mode service";
            alt-tab = "workspace-back-and-forth";
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
