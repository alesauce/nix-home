{inputs, ...}: {
  perSystem = {
    pkgs,
    lib,
    self',
    ...
  }: {
    packages.ghostty = inputs.wrapper-modules.wrappers.ghostty.wrap {
      inherit pkgs;
      settings.command = lib.getExe self'.packages.environment;
    };
  };
}
