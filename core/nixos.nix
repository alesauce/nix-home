{
  lib,
  home-manager,
  nix-index-database,
  stylix,
  ...
}: {
  imports = [
    home-manager.nixosModules.home-manager
    nix-index-database.nixosModules.nix-index
    stylix.nixosModules.stylix
  ];

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
    stateVersion = "23.11";
  };

  users = {
    mutableUsers = false;
  };
}
