{
  inputs,
  config,
  ...
}: let
  # "mod"/"meh" are hyper/meh tiers (a single physical hardware key sends
  # all these modifiers at once), not individually-composable — see
  # modules/meta.nix.
  modifierNames = {
    mod = "Mod+Shift+Ctrl+Alt";
    meh = "Shift+Ctrl+Alt";
    cmd = "Mod";
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
    spawn = cmd: {spawn = cmd;};
    closeWindow = _: {close-window = {};};
    toggleFullscreen = _: {fullscreen-window = {};};
    focus = dir: {"focus-${directionVerb.${dir}}" = {};};
    move = dir: {"move-${directionVerb.${dir}}" = {};};
    workspace = n: {focus-workspace = n;};
    moveToWorkspace = n: {move-column-to-workspace = n;};
  };

  niriAction = action: let
    tag = builtins.head (builtins.attrNames action);
  in
    niriActionHandlers.${tag} action.${tag};

  niriBinds = builtins.listToAttrs (map (kb: {
      name = comboString kb;
      value.action = niriAction kb.action;
    })
    config.flake.meta.windowManager.keybinds);
in {
  flake.nixosModules.niri = {pkgs, ...}: {
    imports = [inputs.niri.nixosModules.niri];
    programs.niri = {
      enable = true;
      package = pkgs.niri;
    };
  };

  flake.homeManagerModules.niri = {
    pkgs,
    lib,
    ...
  }: {
    programs.niri.settings = {
      spawn-at-startup = [
        {argv = [(lib.getExe inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default)];}
      ];

      input.keyboard.xkb.layout = "us";

      layout.gaps = 5;

      binds =
        niriBinds
        // {
          "Mod+Space".action.spawn-sh = "${lib.getExe inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default} msg panel-toggle launcher";
        };
    };
  };
}
