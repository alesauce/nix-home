let
  tags = ["wayland"];
  disableTags = ["noSway"];
  systems = ["x86_64-linux" "aarch64-linux"];
in
{
  nix-config = {
    apps = {
      sway = {
        inherit tags systems disableTags;

        home = {pkgs, ...}: {
          home.packages = with pkgs; [
            wl-clipboard
            shotman
          ];

          wayland.windowManager.sway = {
            enable = true;
            config = {
              modifier = "Mod4"; # Super key
              terminal = "ghostty";
              output = {
                "Virtual-1" = {
                  mode = "1920x1080@60Hz";
                };
              };
            };
            extraConfig = ''
              bindsym Print               exec shotman -c output
              bindsym Print+Shift         exec shotman -c region
              bindsym Print+Shift+Control exec shotman -c window
            '';
          };
        };
      };

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
