{
  flake.modules.nixos.base = {
    programs.sway.enable = true;
    security.polkit.enable = true;
  };
}
