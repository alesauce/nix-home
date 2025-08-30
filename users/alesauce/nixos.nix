{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  users.groups.alesauce.gid = config.users.users.alesauce.uid;

  users.users.alesauce = {
    createHome = true;
    description = "Alexander Sauceda";
    group = "alesauce";
    extraGroups =
      [
        "wheel"
        "dialout"
        "audio"
      ]
      ++ optionals config.programs.sway.enable [
        "input"
        "video"
      ];
    isNormalUser = true;
    shell = pkgs.zsh;
    uid = 8888;
  };

  home-manager.users.alesauce = {lib, ...}: {
    imports = optionals config.programs.sway.enable [
      ./graphical
      ./graphical/sway
    ];
    # c.f. https://github.com/danth/stylix/issues/865
    nixpkgs.overlays = lib.mkForce null;
  };
}
