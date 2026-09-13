{inputs, ...}: {
  flake.modules.darwin.base = {
    imports = [inputs.stylix.darwinModules.stylix];
  };

  flake.modules.homeManager.base = {
    imports = [inputs.stylix.homeModules.stylix];
    stylix = {
      enable = true;
      base16Scheme = "${inputs.tinted-schemes}/base16/catppuccin-mocha.yaml";
    };
  };
}
