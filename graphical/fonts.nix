{
  hostType,
  lib,
  pkgs,
  ...
}: let
  fontPackages = with pkgs; [
    monaspace
    recursive
    nerdfonts
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-extra
  ];
in {
  fonts =
    lib.optionalAttrs (hostType == "nixos")
    {
      packages = fontPackages;
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
    }
    // lib.optionalAttrs (hostType == "darwin") {
      fonts = fontPackages;
      fontDir.enable = true;
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
      package = pkgs.monaspace.override {fonts = ["Argon"];};
      name = "Argon Monaspace Font";
    };
    emoji = {
      package = pkgs.noto-fonts-emoji;
      name = "Noto Color Emoji";
    };
  };
}