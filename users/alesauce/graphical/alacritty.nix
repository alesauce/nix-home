{
  lib,
  hostType,
  ...
}: {
  programs.alacritty = {
    enable = true;
    settings =
      {
        title = "Alacritty";
        dynamic_title = true;
        scrolling = {
          history = 10000;
          multiplier = 3;
        };
        font = {
          normal = {
            family = "Monaspace Argon";
            style = "Regular";
          };
          bold = {
            family = "Monaspace Argon";
            style = "Bold";
          };
          italic = {
            family = "Monaspace Argon";
            style = "Medium Italic";
          };
        };
        size = 17;
      }
      // (lib.optionalAttrs (hostType == "darwin")) {
        window.startup_mode = "Windowed";
      };
  };
}
