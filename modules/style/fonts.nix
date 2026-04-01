{
  flake.modules = {
    nixos.base = {pkgs, ...}: {
      fonts = {
        packages = with pkgs; [
          monaspace
          recursive
          nerd-fonts.hack
          noto-fonts
          noto-fonts-cjk-sans
          noto-fonts-cjk-serif
        ];
        enableDefaultPackages = false;
        enableGhostscriptFonts = false;
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
          package = pkgs.monaspace;
          name = "Argon Monaspace Font";
        };
        emoji = {
          package = pkgs.noto-fonts-color-emoji;
          name = "Noto Color Emoji";
        };
      };
    };

    darwin.base = {pkgs, ...}: {
      fonts.packages = with pkgs; [
        monaspace
        recursive
        nerd-fonts.hack
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
      ];

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
          package = pkgs.monaspace;
          name = "Argon Monaspace Font";
        };
        emoji = {
          package = pkgs.noto-fonts-color-emoji;
          name = "Noto Color Emoji";
        };
      };
    };

    homeManager.base = {pkgs, ...}: {
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
