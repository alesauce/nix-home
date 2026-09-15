{
  perSystem = {
    pkgs,
    config,
    ...
  }: {
    devShells.default = pkgs.mkShell {
      name = "nix-home";

      nativeBuildInputs = config.pre-commit.settings.enabledPackages ++ [pkgs.act];

      shellHook = ''
        ${config.pre-commit.installationScript}
      '';
    };
  };
}
