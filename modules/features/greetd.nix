{
  flake.nixosModules.greetd = {
    pkgs,
    lib,
    ...
  }: {
    services.greetd = {
      enable = true;
      useTextGreeter = true;
      settings.default_session.command = lib.concatStringsSep " " [
        (lib.getExe pkgs.tuigreet)
        "--time"
        "--remember"
        "--remember-session"
        "--sessions"
        "/run/current-system/sw/share/wayland-sessions"
      ];
    };
  };
}
