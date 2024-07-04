{
  lib,
  home-manager,
  lanzaboote,
  nix-index-database,
  stylix,
  ...
}: {
  imports = [
    home-manager.nixosModules.home-manager
    lanzaboote.nixosModules.lanzaboote
    nix-index-database.nixosModules.nix-index
    stylix.nixosModules.stylix
    ./tmux.nix
  ];

  boot.kernelParams = ["log_buf_len=10M"];

  documentation = {
    dev.enable = true;
    man.generateCaches = true;
  };

  i18n.defaultLocale = "en_US.UTF-8";

  programs = {
    command-not-found.enable = false;
    mosh.enable = true;
    zsh.enableGlobalCompInit = false;
  };

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
    stateVersion = "23.05";
  };
}
