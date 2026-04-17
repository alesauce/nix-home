{
  perSystem = {pkgs, config, ...}: {
    devShells.default = pkgs.mkShell {
      name = "nix-home";

      # TODO: uncomment after setting up pre-commit hooks
      #shellHook = ''
      #  ${config.pre-commit.installationScript}
      #'';
    };
  };
}
