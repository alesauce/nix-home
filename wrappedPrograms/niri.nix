{
  inputs,
  config,
  ...
}: let
  modifierNames = {
    mod = "Mod";
    shift = "Shift";
    ctrl = "Ctrl";
    alt = "Alt";
  };

  comboString = kb: builtins.concatStringsSep "+" (map (m: modifierNames.${m}) kb.modifiers ++ [kb.key]);

  # niri's own spatial model is columns (horizontal) containing windows
  # (vertical), not a flat 4-direction grid — left/right always means
  # "column", up/down always means "window", for both focus and move.
  directionVerb = {
    left = "column-left";
    right = "column-right";
    up = "window-up";
    down = "window-down";
  };

  # `action` comes from an attrTag, so it's guaranteed to have exactly one
  # key — dispatch on that key instead of testing each possibility in turn.
  niriActionHandlers = {
    spawn = cmd: {spawn-sh = cmd;};
    closeWindow = _: {close-window = null;};
    toggleFullscreen = _: {fullscreen-window = null;};
    focus = dir: {"focus-${directionVerb.${dir}}" = null;};
    move = dir: {"move-${directionVerb.${dir}}" = null;};
    workspace = n: {focus-workspace = n;};
    moveToWorkspace = n: {move-column-to-workspace = n;};
  };

  niriAction = action: let
    tag = builtins.head (builtins.attrNames action);
  in
    niriActionHandlers.${tag} action.${tag};

  niriBinds = builtins.listToAttrs (map (kb: {
      name = comboString kb;
      value = niriAction kb.action;
    })
    config.flake.meta.windowManager.keybinds);
in {
  perSystem = {
    pkgs,
    lib,
    self',
    ...
  }: {
    packages = lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
      niri = inputs.wrapper-modules.wrappers.niri.wrap {
        inherit pkgs;
        settings = {
          spawn-at-startup = [
            # (lib.getExe self'.packages.myNoctalia)
          ];

          xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;

          input.keyboard.xkb.layout = "us,ua";

          layout.gaps = 5;

          binds = niriBinds;
          # "Mod+S".spawn-sh = "${lib.getExe self'.packages.myNoctalia} ipc call launcher toggle";
        };
      };
    };
  };
}
