{
  self,
  inputs,
  ...
}: {
  # TODO: unify window-manager settings across systems. niri is Linux-only,
  # but keybinds / startup apps / layout config should live in a shared
  # abstraction so darwin (e.g. yabai/aerospace) and Linux hosts can be
  # configured from the same source of truth.
  flake.nixosModules.niri = {
    pkgs,
    lib,
    ...
  }: {
    programs.niri = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.myNiri;
    };
  };

  perSystem = {
    pkgs,
    lib,
    self',
    ...
  }: {
    packages = lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
      myNiri = inputs.wrapper-modules.wrappers.niri.wrap {
        inherit pkgs; # THIS PART IS VERY IMPORTAINT, I FORGOT IT IN THE VIDEO!!!
        settings = {
          spawn-at-startup = [
            # (lib.getExe self'.packages.myNoctalia)
          ];

          xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;

          input.keyboard.xkb.layout = "us,ua";

          layout.gaps = 5;

          binds = {
            "Mod+Return".spawn-sh = lib.getExe pkgs.kitty;
            "Mod+Q".close-window = null;
            # "Mod+S".spawn-sh = "${lib.getExe self'.packages.myNoctalia} ipc call launcher toggle";
          };
        };
      };
    };
  };
}
