let
  common = {
    defaultWorkspace = "workspace 1";
  };
in {
  wayland.windowManager.sway.config = common;
}
