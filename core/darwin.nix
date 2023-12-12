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
      git
      gnugrep
      gnutar
      ncurses
      openssh
    ];
    systemPath = lib.mkBefore [
      "/opt/homebrew/bin"
    ];
    variables = {
      SHELL = lib.getExe pkgs.zsh;
    };
    postBuild = ''
      ln -sv ${pkgs.path} $out/nixpkgs
    '';
  };

  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };
  };

  services = {
    nix-daemon = {
      enable = true;
      logFile = "/var/log/nix-daemon.log";
    };
  };

  system = {
    stateVersion = 4;
    defaults.SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;
  };
}
