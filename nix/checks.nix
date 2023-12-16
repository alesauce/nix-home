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
      # TODO: add actionlint when you add in the flake publishing workflow
      # https://github.com/rhysd/actionlint
      hooks = {
        alejandra.enable = true;
        deadnix.enable = true;
        nil.enable = true;
        statix.enable = true;
      };
    };
}
