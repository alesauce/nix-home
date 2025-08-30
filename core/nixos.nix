{
  lib,
  home-manager,
  nix-index-database,
  stylix,
  pkgs,
  ...
}: {
  imports = [
    home-manager.nixosModules.home-manager
    nix-index-database.nixosModules.nix-index
    stylix.nixosModules.stylix
  ];

  environment.systemPackages = [pkgs.ghostty.terminfo];

  i18n.defaultLocale = "en_US.UTF-8";

  security = {
    sudo = {
      enable = true;
      wheelNeedsPassword = lib.mkDefault false;
    };
  };

  services = {
    openssh = {
      enable = true;
      settings.PermitRootLogin = lib.mkDefault "no";
    };
  };

  system = {
    stateVersion = "25.05";
  };

  users = {
    mutableUsers = true;
  };
}
