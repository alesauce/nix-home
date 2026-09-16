{inputs, ...}: let
  direnvModule = {
    config,
    lib,
    pkgs,
    ...
  }: {
    config = {
      package = lib.mkDefault pkgs.direnv;
      env.DIRENV_CONFIG = dirOf config.constructFiles.direnvrc.path;
      constructFiles.direnvrc = {
        content = "source ${pkgs.nix-direnv}/share/nix-direnv/direnvrc";
        relPath = "direnvrc";
      };
    };
  };
in {
  flake.modules.programs.direnv = direnvModule;

  perSystem = {pkgs, ...}: {
    packages.direnv = inputs.wrapper-modules.lib.wrapPackage {
      inherit pkgs;
      imports = [direnvModule];
    };
  };
}
