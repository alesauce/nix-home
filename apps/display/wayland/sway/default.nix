{
  nix-config.apps.sway = {
    tags = ["wayland"];
    systems = ["x86_64-linux" "aarch64-linux"];

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
}
