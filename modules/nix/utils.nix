{withSystem, ...}: {
  perSystem = {pkgs, ...}: let
    systemPrinter = pkgs.writeShellScriptBin "system" ''
      nix-instantiate --eval --expr builtins.currentSystem --raw
    '';
  in {
    packages.system = systemPrinter;
  };

  flake.modules.homeManager.base = {pkgs, ...}: let
    currentSystem = pkgs.stdenv.hostPlatform.system;

    systemPrinterPackage = withSystem currentSystem (
      {config, ...}:
        config.packages.system
    );
  in {
    home.packages =
      (with pkgs; [
        nix-output-monitor
        nix-fast-build
        nix-tree
        nvd
        nix-diff
      ])
      ++ [
        systemPrinterPackage
      ];

    programs.nh.enable = true;
  };
}
