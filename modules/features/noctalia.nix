{
  inputs,
  config,
  ...
}: {
  flake = {
    homeManagerModules.noctalia = {
      imports = [inputs.noctalia.homeModules.default];
      programs.noctalia = {
        enable = true;
        settings = {
          wallpaper = {
            enabled = true;
            fill_mode = "repeat";
            default.path = "${config.flake.meta.theme.wallpaper}";
          };
        };
      };
    };
  };
}
