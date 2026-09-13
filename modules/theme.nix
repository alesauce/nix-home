{inputs, ...}: let
  themeFamily = "catppuccin";
  themeFlavor = "mocha";
  base16SchemeFile = "${inputs.tinted-schemes}/base16/${themeFamily}-${themeFlavor}.yaml";

  parseBase16 = file: let
    lines = builtins.split "\n" (builtins.readFile file);
    matches =
      builtins.filter (m: m != null)
      (map (
          l:
            if builtins.isString l
            then builtins.match ''^ *base([0-9A-Fa-f][0-9A-Fa-f]): *"#([0-9a-fA-F]{6})".*$'' l
            else null
        )
        lines);
  in
    builtins.listToAttrs (map (m: {
        name = "base" + builtins.elemAt m 0;
        value = builtins.elemAt m 1;
      })
      matches);
in {
  flake = {
    meta.theme = {
      family = themeFamily;
      flavor = themeFlavor;
      palette = parseBase16 base16SchemeFile;
    };

    modules.darwin.base = {
      imports = [inputs.stylix.darwinModules.stylix];
    };

    modules.homeManager.base = {
      imports = [inputs.stylix.homeModules.stylix];
      stylix = {
        enable = true;
        base16Scheme = base16SchemeFile;
      };
    };
  };
}
