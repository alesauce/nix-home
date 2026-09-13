{
  inputs,
  withSystem,
  ...
}: {
  # Bundles the wrapped programs onto zsh's own $PATH via runtimePkgs, so the
  # whole shell environment is a single derivation you can drop on any machine
  # with nix installed — no home-manager activation required.
  perSystem = {
    pkgs,
    self',
    ...
  }: {
    packages.environment = inputs.wrapper-modules.lib.wrapPackage {
      inherit pkgs;
      package = self'.packages.zsh;
      runtimePkgs = [
        self'.packages.git
        self'.packages.tmux
        self'.packages.atuin
        self'.packages.starship
        self'.packages.htop
        self'.packages.btop
        pkgs.mise
      ];
    };
  };

  flake.modules.homeManager.base = {pkgs, ...}: let
    currentSystem = pkgs.stdenv.hostPlatform.system;
    environmentPackage = withSystem currentSystem (
      {config, ...}: config.packages.environment
    );
  in {
    home.packages = [environmentPackage];
  };
}
