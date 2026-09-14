_: let
  fontPackages = pkgs:
    with pkgs; [
      monaspace
      recursive
      nerd-fonts.hack
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
    ];
in {
  flake.modules.nixos.base = {pkgs, ...}: {
    fonts = {
      packages = fontPackages pkgs;
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
  };

  flake.modules.darwin.base = {pkgs, ...}: {
    fonts.packages = fontPackages pkgs;
  };
}
