{
  flake.modules.homeManager.base = {
    lib,
    pkgs,
    ...
  }: {
    dconf.enable = lib.mkIf pkgs.stdenv.isLinux (lib.mkForce true);

    home.packages = lib.optionals pkgs.stdenv.isLinux (with pkgs; [
      qt5.qtwayland
      qt6.qtwayland
    ]);

    qt.enable = lib.mkIf pkgs.stdenv.isLinux true;
  };
}
