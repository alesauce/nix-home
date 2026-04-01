{
  flake.modules.homeManager.base = {
    pkgs,
    lib,
    ...
  }: {
    home.packages = lib.optionals pkgs.stdenv.isLinux (with pkgs; [
      wl-clipboard
      shotman
    ]);

    wayland.windowManager.sway = lib.mkIf pkgs.stdenv.isLinux {
      enable = true;
      config = {
        modifier = "Mod4";
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

    services.mako = lib.mkIf pkgs.stdenv.isLinux {
      enable = true;
      settings = {
        icons = true;
      };
    };

    systemd.user.services.mako = lib.mkIf pkgs.stdenv.isLinux {
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
}
