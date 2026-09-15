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
            default.path = "${config.flake.meta.theme.wallpaper}";
          };
        };
      };
    };
  };
}
