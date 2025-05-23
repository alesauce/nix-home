{
  home-manager,
  lib,
  nix-index-database,
  pkgs,
  stylix,
  ...
}: {
  imports = [
    home-manager.darwinModules.home-manager
    nix-index-database.darwinModules.nix-index
    stylix.darwinModules.stylix
  ];

  environment = {
    shells = with pkgs; [zsh];
    systemPackages = with pkgs; [
      gnugrep
      gnutar
      ncurses
    ];
    systemPath = lib.mkBefore [
      "/opt/homebrew/bin"
    ];
    variables = {
      SHELL = lib.getExe pkgs.zsh;
    };
    extraSetup = ''
      ln -sv ${pkgs.path} $out/nixpkgs
    '';
  };

  homebrew = {
    enable = true;
    brews = [
      "bitwarden-cli"
    ];
    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };
  };

  services = {
    nix-daemon.logFile = "/var/log/nix-daemon.log";
  };

  system = {
    stateVersion = 4;
    defaults.SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;
    primaryUser = "alesauce";
  };
}
