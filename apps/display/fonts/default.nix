{
  nix-config.apps.fonts = {
    tags = ["display"];

    home = {pkgs, ...}: {
      stylix.fonts = {
        sansSerif = {
          package = pkgs.ibm-plex;
          name = "IBM Plex Sans";
        };
        serif = {
          package = pkgs.ibm-plex;
          name = "IBM Plex Serif";
        };
        monospace = {
          package = pkgs.nerd-fonts.hack;
          name = "Hack Nerd Font";
        };
        emoji = {
          package = pkgs.noto-fonts-color-emoji;
          name = "Noto Color Emoji";
        };
        sizes = {
          applications = 15;
          desktop = 15;
          popups = 15;
          terminal = 17;
        };
      };
    };
  };
}
