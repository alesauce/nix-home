{
  pkgs,
  base16-schemes,
  hostType,
  nix-index-database,
  stylix,
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
    extraSpecialArgs = {
      inherit
        base16-schemes
        hostType
        nix-index-database
        stylix
        ;
    };
  };

  programs = {
    nix-index.enable = true;
    zsh.enable = true;
  };

  stylix = {
    enable = true;
    base16Scheme = "${base16-schemes}/catppuccin-mocha.yaml";
    # We need this otherwise the autoimport clashes with our manual import.
    homeManagerIntegration.autoImport = false;
    image = ../graphical/mt_fuji_across_lake.jpg;
  };
}
