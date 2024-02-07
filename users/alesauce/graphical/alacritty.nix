{
  lib,
  hostType,
  ...
}: {
  programs.alacritty = {
    enable = true;
    settings =
      {
        scrolling = {
          history = 10000;
          multiplier = 3;
        };
      }
      // (lib.optionalAttrs (hostType == "darwin")) {
        window.startup_mode = "Windowed";
      };
  };
}
