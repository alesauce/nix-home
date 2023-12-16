{
  hostType,
  pkgs,
  ...
}: {
  imports = [
    (
      if hostType == "darwin"
      then ./darwin.nix
      else throw "Unknown hostType '${hostType}' for users/alesauce/graphical"
    )
    ./alacritty.nix
  ];

  home.packages = with pkgs;
    [
      xdg-utils
    ]
    ++ lib.filter (lib.meta.availableOn stdenv.hostPlatform) [
      discord
      signal-desktop
    ]
    ++ lib.optionals (stdenv.hostPlatform.system == "x86_64-linux") [
      spotify
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
      package = pkgs.nerdfonts.override {fonts = ["Hack"];};
      name = "Hack Nerd Font";
    };
    emoji = {
      package = pkgs.noto-fonts-emoji;
      name = "Noto Color Emoji";
    };
    sizes = {
      applications = 15;
      desktop = 15;
      popups = 15;
      terminal = 17;
    };
  };
}
