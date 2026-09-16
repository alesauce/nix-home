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
    packages.environment =
      inputs.wrapper-modules.lib.wrapPackage {
        inherit pkgs;
        package = self'.packages.zsh;
        runtimePkgs = [
          self'.packages.git
          self'.packages.tmux
          self'.packages.atuin
          self'.packages.starship
          self'.packages.htop
          self'.packages.btop
          self'.packages.neovim
          self'.packages.direnv
          self'.packages.gh
          self'.packages.gh-dash
          self'.packages.claude-code
          pkgs.mise
          pkgs.duckdb
          pkgs.uv
        ];
      }
      # Lets a host opt into this as users.users.<name>.shell (NixOS's
      # types.shellPackage requires a shellPath passthru) without every host
      # having to do it — headless hosts will want this, desktop hosts with a
      # terminal emulator can wire the shell there instead.
      // {shellPath = "/bin/zsh";};
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
