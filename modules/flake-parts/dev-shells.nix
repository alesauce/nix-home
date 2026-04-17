{
  perSystem = {
    pkgs,
    config,
    ...
  }: {
    devShells.default = pkgs.mkShell {
      name = "nix-home";

      nativeBuildInputs = config.pre-commit.settings.enabledPackages;

      shellHook = ''
        ${config.pre-commit.installationScript}
      '';
    };
  };
}
