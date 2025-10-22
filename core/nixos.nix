{
  lib,
  home-manager,
  nix-index-database,
  stylix,
  pkgs,
  sops-nix,
  ...
}: {
  imports = [
    home-manager.nixosModules.home-manager
    nix-index-database.nixosModules.nix-index
    stylix.nixosModules.stylix
    sops-nix.nixosModules.sops
  ];

  environment.systemPackages = [pkgs.ghostty.terminfo];

  i18n.defaultLocale = "en_US.UTF-8";

  security = {
    rtkit.enable = true;
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
    printing.enable = true;
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };

  system = {
    stateVersion = "25.05";
  };
}
