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
        modifiers = ["meh"];
        key = "H";
        action.move = "left";
      }
      {
        modifiers = ["meh"];
        key = "L";
        action.move = "right";
      }
      {
        modifiers = ["meh"];
        key = "K";
        action.move = "up";
      }
      {
        modifiers = ["meh"];
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
        modifiers = ["meh"];
        key = toString n;
        action.moveToWorkspace = n;
      }
    ]) (builtins.genList (i: i + 1) 5);
}
