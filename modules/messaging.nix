{
  flake.modules.homeManager.base = {
    lib,
    pkgs,
    ...
  }: {
    home.packages = with pkgs;
      lib.filter (lib.meta.availableOn stdenv.hostPlatform) [
        discord
        signal-desktop
      ]
      ++ lib.optionals (stdenv.hostPlatform.system == "x86_64-linux") [
        beeper
      ];
  };
}
