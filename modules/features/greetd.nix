{self, ...}: {
  flake.nixosModules.greetd = {
    pkgs,
    lib,
    ...
  }: let
    system = pkgs.stdenv.hostPlatform.system;
    sessionDesktopEntry = name: exec:
      pkgs.writeTextDir "share/wayland-sessions/${name}.desktop" ''
        [Desktop Entry]
        Name=${name}
        Exec=${exec}
        Type=Application
        DesktopNames=${name}
      '';
  in {
    environment.systemPackages = [
      (sessionDesktopEntry "niri" (lib.getExe self.packages.${system}.niri))
      (sessionDesktopEntry "sway" (lib.getExe pkgs.sway))
    ];

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
