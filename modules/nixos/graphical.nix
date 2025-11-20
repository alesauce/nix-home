# NixOS-specific graphical system module
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.nix-home.system.graphical;
in {
  config = lib.mkIf cfg.enable {
    # Fonts
    fonts = lib.mkIf cfg.fonts.enable {
      enableDefaultPackages = false;
      enableGhostscriptFonts = false;
      packages =
        (with pkgs; [
          monaspace
          recursive
          nerd-fonts.hack
          noto-fonts
          noto-fonts-cjk-sans
          noto-fonts-cjk-serif
        ])
        ++ cfg.fonts.additionalPackages;

      fontconfig.localConf = ''
        <?xml version="1.0"?>
        <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
        <fontconfig>
            <alias binding="weak">
                <family>monospace</family>
                <prefer>
                    <family>emoji</family>
                </prefer>
            </alias>
            <alias binding="weak">
                <family>sans-serif</family>
                <prefer>
                    <family>emoji</family>
                </prefer>
            </alias>
            <alias binding="weak">
                <family>serif</family>
                <prefer>
                    <family>emoji</family>
                </prefer>
            </alias>
        </fontconfig>
      '';
    };

    # Stylix fonts
    stylix.fonts = lib.mkIf cfg.fonts.enable {
      sansSerif = {
        package = pkgs.ibm-plex;
        name = "IBM Plex Sans";
      };
      serif = {
        package = pkgs.ibm-plex;
        name = "IBM Plex Serif";
      };
      monospace = {
        package = pkgs.monaspace;
        name = "Argon Monaspace Font";
      };
      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
    };

    # Display and desktop managers
    services = {
      displayManager.cosmic-greeter.enable = true;
      desktopManager.cosmic = {
        enable = true;
        xwayland.enable = true;
      };
    };

    # Programs
    programs = {
      steam = {
        enable = true;
        remotePlay.openFirewall = true;
      };
      ladybird.enable = true;
    };
  };
}
