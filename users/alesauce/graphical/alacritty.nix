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
        window.startup_mode = "Windowed";
      }
      // (lib.optionalAttrs (hostType == "darwin")) {
        window.option_as_alt = "Both";
      };
  };
}
