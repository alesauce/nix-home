{inputs, ...}: let
  # Starting bare — main's config was a mostly-untouched copy of btop's own
  # defaults, kept for years without knowing what most of it did. Add options
  # here deliberately, one at a time, once you actually want to change
  # something from btop's default behavior.
  btopModule = _: {};
in {
  flake.modules.programs.btop.main = btopModule;

  perSystem = {pkgs, ...}: {
    packages.btop = inputs.wrapper-modules.wrappers.btop.wrap {
      inherit pkgs;
      imports = [btopModule];
    };
  };
}
