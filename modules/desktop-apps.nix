{
  flake.modules.homeManager.base = {
    lib,
    pkgs,
    ...
  }: {
    home.packages = with pkgs;
      [
        xdg-utils
        rbw
      ]
      ++ lib.optionals (stdenv.hostPlatform.system == "x86_64-linux") [
        brave
        spotify
        obsidian
        todoist-electron
      ];
  };
}
