{inputs, ...}: let
  themeFamily = "catppuccin";
  themeFlavor = "mocha";
  base16SchemeFile = "${inputs.tinted-schemes}/base16/${themeFamily}-${themeFlavor}.yaml";
  wallpaper = ./looking_across_lake_moraine.jpg;

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
      inherit wallpaper;
    };

    modules = {
      darwin.base = {
        imports = [inputs.stylix.darwinModules.stylix];
      };

      nixos.base = {
        imports = [inputs.stylix.nixosModules.stylix];
        stylix.fonts.sizes = {
          desktop = 16;
          applications = 14;
          terminal = 12;
          popups = 16;
        };
      };

      homeManager.base = {pkgs, ...}: {
        imports = [inputs.stylix.homeModules.stylix];
        stylix = {
          enable = true;
          polarity = "dark";
          base16Scheme = base16SchemeFile;
          image = wallpaper;
          fonts = {
            sansSerif = {
              package = pkgs.ibm-plex;
              name = "IBM Plex Sans";
            };
            serif = {
              package = pkgs.ibm-plex;
              name = "IBM Plex Serif";
            };
            monospace = {
              package = pkgs.monaspace;
              name = "Argon Monaspace Font";
            };
            emoji = {
              package = pkgs.noto-fonts-color-emoji;
              name = "Noto Color Emoji";
            };
          };
        };
      };
    };
  };
}
