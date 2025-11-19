{
  config,
  self',
  pkgs,
  ...
}: {
  default = pkgs.mkShell {
    name = "nix-home";

    nativeBuildInputs = with pkgs; [
      # Nix
      alejandra
      deadnix
      nil
      self'.packages.nix-fast-build
      statix

      # GitHub Actions
      act
      actionlint

      # Misc
      jq
      pre-commit
    ];

    shellHook = ''
      ${config.pre-commit.installationScript}
    '';
  };
}
