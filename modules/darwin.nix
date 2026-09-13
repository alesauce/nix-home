_: {
  flake.modules.darwin.base = {
    pkgs,
    lib,
    ...
  }: {
    environment = {
      shells = [pkgs.zsh];
      systemPackages = [
        pkgs.gnugrep
        pkgs.gnutar
        pkgs.ncurses
      ];
      systemPath = lib.mkBefore ["/opt/homebrew/bin"];
      variables.SHELL = lib.getExe pkgs.zsh;
      extraSetup = ''
        ln -sv ${pkgs.path} $out/nixpkgs
      '';
    };

    services.nix-daemon.logFile = "/var/log/nix-daemon.log";

    homebrew = {
      enable = true;
      onActivation = {
        cleanup = "zap";
        autoUpdate = true;
        upgrade = true;
      };
    };
  };
}
