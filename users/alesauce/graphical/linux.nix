{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./common.nix
  ];

  dconf.enable = lib.mkForce true;

  home = {
    packages = with pkgs; [
      qt5.qtwayland
      qt6.qtwayland
    ];
  };

  qt.enable = true;
}
