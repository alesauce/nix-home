let
  tags = ["wayland"];
  systems = ["x86_64-linux" "aarch64-linux"];
in
{
  nix-config = {
    apps = {
      qt = {
        inherit tags systems;

        home = {pkgs, ...}: {
          qt.enable = true;

          home.packages = with pkgs; [
            qt5.qtwayland
            qt6.qtwayland
          ];
        };
      };
      mako = {
        inherit tags systems;

        home = {pkgs, ...}: {
          services.mako = {
            enable = true;
            settings = {
              icons = true;
            };
          };

          systemd.user.services.mako = {
            Unit = {
              Description = "mako";
              Documentation = ["man:mako(1)"];
              PartOf = ["sway-session.target"];
            };
            Service = {
              Type = "simple";
              ExecStart = "${pkgs.mako}/bin/mako";
              RestartSec = 3;
              Restart = "always";
            };
            Install = {
              WantedBy = ["sway-session.target"];
            };
          };
        };
      };
    };
  };
}
