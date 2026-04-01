{
  perSystem = {
    pre-commit = {
      check.enable = true;
      settings.hooks = {
        actionlint.enable = true;
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
  };
}
