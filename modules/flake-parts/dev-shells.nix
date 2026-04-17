{
  perSystem = {
    pkgs,
    config,
    ...
  }: {
    devShells.default = pkgs.mkShell {
      name = "nix-home";

      shellHook = ''
        ${config.pre-commit.installationScript}
      '';
    };
  };
}
