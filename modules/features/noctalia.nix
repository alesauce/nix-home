{inputs, ...}: {
  flake.homeManagerModules.noctalia = {
    imports = [inputs.noctalia.homeModules.default];
    programs.noctalia.enable = true;
  };
}
