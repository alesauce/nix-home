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
    image = pkgs.fetchurl {
      url = "https://www.amazon.com/photos/shared/sm6sTzxXQYOkgT5EwtJAUA.oLstPFMFeG-SoN0CGYou67/gallery/_DYiRRFrSyWc3lk8F_Tmzw";
      hash = "sha256-twq+drJQxH6O3Wn1TnGZuwYvf2qVYSXPkKzrH9VhWGA=";
    };
  };
}
