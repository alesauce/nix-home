{inputs, ...}: {
  imports = [inputs.git-hooks.flakeModule];
  perSystem = {
    pre-commit = {
      check.enable = true;
      settings.hooks = {
        actionlint.enable = true;
        check-added-large-files.enable = true;
        check-merge-conflicts.enable = true;
        deadnix = {
          enable = true;
          settings = {
            noLambdaArg = true;
            noLambdaPatternNames = true;
            noUnderscore = true;
          };
        };
        nil.enable = true;
        shellcheck = {
          enable = true;
          excludes = [
            ".envrc"
            # zsh autoload function bodies; shellcheck can't parse zsh syntax.
            "^wrappedPrograms/zsh/functions/.*\\.sh$"
          ];
        };
        statix.enable = true;
        treefmt.enable = true;
      };
    };
  };
}
