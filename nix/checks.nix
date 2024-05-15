{
  self,
  git-hooks,
  ...
}: system:
with self.pkgs.${system}; {
  pre-commit-check =
    git-hooks.lib.${system}.run
    {
      src = lib.cleanSource self;
      hooks = {
        actionlint.enable = false;
        alejandra.enable = true;
        deadnix = {
          enable = true;
          settings = {
            noLambdaArg = true;
            noLambdaPatternNames = true;
            noUnderscore = true;
          };
        };
        nil.enable = true;
        statix.enable = true;
      };
    };
}
