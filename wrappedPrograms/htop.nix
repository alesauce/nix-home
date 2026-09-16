{inputs, ...}: let
  # Starting bare — same reasoning as btop.nix. main's meter layout came from
  # home-manager's config.lib.htop helpers, which don't carry over 1:1 to this
  # wrapper's plain `settings` (htoprc key/value) shape. Not worth reproducing
  # blind; add settings here once you know what you want htop to show.
  htopModule = _: {};
in {
  flake.modules.programs.htop = htopModule;

  perSystem = {pkgs, ...}: {
    packages.htop = inputs.wrapper-modules.wrappers.htop.wrap {
      inherit pkgs;
      imports = [htopModule];
    };
  };
}
