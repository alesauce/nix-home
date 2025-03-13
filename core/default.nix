{
  hostType,
  nix-index-database,
  stylix,
  tinted-schemes,
  ...
}: {
  imports = [
    (
      if hostType == "nixos"
      then ./nixos.nix
      else if hostType == "darwin"
      then ./darwin.nix
      else throw "Unknown hostType '${hostType}' for core"
    )
    ./aspell.nix
    ./nix.nix
  ];

  documentation = {
    enable = true;
    doc.enable = true;
    man.enable = true;
    info.enable = true;
  };

  environment = {
    pathsToLink = [
      "/share/zsh"
    ];
    # systemPackages = with pkgs; [
    #  man-pages
    # ];
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    # https://github.com/danth/stylix/issues/617
    sharedModules = [
      {
        stylix.enable = true;
      }
    ];
    extraSpecialArgs = {
      inherit
        hostType
        nix-index-database
        stylix
        tinted-schemes
        ;
    };
  };

  programs = {
    nix-index.enable = true;
    zsh.enable = true;
  };

  stylix = {
    enable = true;
    autoEnable = true;
    base16Scheme = "${tinted-schemes}/base16/catppuccin-mocha.yaml";
    # We need this otherwise the autoimport clashes with our manual import.
    homeManagerIntegration.autoImport = false;
    image = ../graphical/mt_fuji_across_lake.jpg;
  };
}
