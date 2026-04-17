{inputs, ...}: {
  imports = [inputs.treefmt-nix.flakeModule];

  perSystem = {
    treefmt = {
      projectRootFile = "flake.nix";
      programs = {
        alejandra.enable = true;
        nixfmt.enable = false;
        prettier.enable = true;
        shfmt.enable = true;
      };
      settings = {
        on-unmatched = "fatal";
        global.excludes = [
          "*.jpg"
          "*.png"
          "LICENSE"
          ".claude/*"
        ];
      };
    };
    # TODO: uncomment when I set up pre-commit hooks
    # pre-commit.settings.hooks.treefmt.enable = true;
  };
}
