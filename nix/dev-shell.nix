{self, ...}: hostPlatform:
with self.pkgs.${hostPlatform}; {
  default = mkShell {
    name = "nix-home";

    nativeBuildInputs = [
      # Nix
      alejandra
      deadnix
      nil
      self.packages.${hostPlatform}.nix-eval-jobs
      self.packages.${hostPlatform}.nix-fast-build
      statix

      # GitHub Actions
      act
      actionlint

      # Misc
      pre-commit
    ];

    shellHook = ''
      ${self.checks.${hostPlatform}.pre-commit-check.shellHook}
    '';
  };
}
