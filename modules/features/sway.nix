{config, ...}: let
  # "mod"/"meh" are hyper/meh tiers (a single physical hardware key sends
  # all these modifiers at once), not individually-composable — see
  # modules/meta.nix.
  modifierNames = {
    mod = "Mod4+Shift+Control+Mod1";
    meh = "Shift+Control+Mod1";
    cmd = "Mod4";
    shift = "Shift";
    ctrl = "Control";
    alt = "Mod1";
  };

  comboString = kb: builtins.concatStringsSep "+" (map (m: modifierNames.${m}) kb.modifiers ++ [kb.key]);

  # `action` comes from an attrTag, so it's guaranteed to have exactly one
  # key — dispatch on that key instead of testing each possibility in turn.
  swayActionHandlers = {
    spawn = cmd: "exec ${cmd}";
    closeWindow = _: "kill";
    toggleFullscreen = _: "fullscreen toggle";
    focus = dir: "focus ${dir}";
    move = dir: "move ${dir}";
    workspace = n: "workspace number ${toString n}";
    moveToWorkspace = n: "move container to workspace number ${toString n}";
  };

  swayAction = action: let
    tag = builtins.head (builtins.attrNames action);
  in
    swayActionHandlers.${tag} action.${tag};

  swayKeybindings = builtins.listToAttrs (map (kb: {
      name = comboString kb;
      value = swayAction kb.action;
    })
    config.flake.meta.windowManager.keybinds);
in {
  flake.nixosModules.sway = {
    programs.sway.enable = true;
  };

  flake.homeManagerModules.sway = {
    wayland.windowManager.sway = {
      enable = true;
      config = {
        modifier = "Mod4";
        keybindings = swayKeybindings;
      };
    };
  };
}
