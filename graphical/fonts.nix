{
  hostType,
  lib,
  pkgs,
  ...
}: {
  fonts =
    {
      packages = with pkgs; [
        monaspace
        recursive
        nerd-fonts.hack
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
        noto-fonts-extra
      ];
    }
    // lib.optionalAttrs (hostType == "nixos")
    {
      enableDefaultPackages = false;
      enableGhostscriptFonts = false;
      fontconfig = {
        localConf = ''
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
      package = pkgs.noto-fonts-emoji;
      name = "Noto Color Emoji";
    };
    sizes = {
      applications = 16;
      desktop = 16;
      popups = 16;
      terminal = 17;
    };
  };
}
