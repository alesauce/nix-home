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
# TODO: `main`'s real graphical/fonts.nix hasn't been ported yet —
# fonts.packages (monaspace, recursive, nerd-fonts.hack, noto-fonts family),
# the NixOS-only fontconfig emoji-fallback aliases, and stylix.fonts
# (sansSerif/serif = ibm-plex, monospace = monaspace, emoji =
# noto-fonts-color-emoji). Also stylix.image (the real wallpaper,
# looking_across_lake_moraine.jpg) isn't wired up — blocked on sanderson
# importing stylix's nixosModule, which is already a known pending item.
# mt_fuji_across_lake.jpg is a genuinely dead asset on main (verified via
# `rg`, zero references) — don't bother porting it.

