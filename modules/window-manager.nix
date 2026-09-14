_: {
  flake.meta.windowManager.keybinds =
    [
      {
        key = "Return";
        action.spawn = "ghostty";
      }
      {
        key = "Q";
        action.closeWindow = {};
      }
      {
        key = "F";
        action.toggleFullscreen = {};
      }

      {
        key = "H";
        action.focus = "left";
      }
      {
        key = "L";
        action.focus = "right";
      }
      {
        key = "K";
        action.focus = "up";
      }
      {
        key = "J";
        action.focus = "down";
      }

      {
        modifiers = ["mod" "shift"];
        key = "H";
        action.move = "left";
      }
      {
        modifiers = ["mod" "shift"];
        key = "L";
        action.move = "right";
      }
      {
        modifiers = ["mod" "shift"];
        key = "K";
        action.move = "up";
      }
      {
        modifiers = ["mod" "shift"];
        key = "J";
        action.move = "down";
      }
    ]
    ++ builtins.concatMap (n: [
      {
        key = toString n;
        action.workspace = n;
      }
      {
        modifiers = ["mod" "shift"];
        key = toString n;
        action.moveToWorkspace = n;
      }
    ]) (builtins.genList (i: i + 1) 5);
}
