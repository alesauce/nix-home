{
  self,
  pre-commit-hooks,
  ...
}: system:
with self.pkgs.${system}; {
  pre-commit-check =
    pre-commit-hooks.lib.${system}.run
    {
      src = lib.cleanSource self;
      hooks = {
        actionlint.enable = false;
        alejandra.enable = true;
        deadnix.enable = true;
        nil.enable = true;
        statix.enable = true;
      };
      settings = {
        deadnix = {
          noLambdaArg = true;
          noLambdaPatternNames = true;
          noUnderscore = true;
        };
      };
    };
}
