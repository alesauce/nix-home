{self, ...}: {
  flake.homeManagerModules.ghostty = {pkgs, ...}: {
    home.packages = [self.packages.${pkgs.stdenv.hostPlatform.system}.ghostty];
  };
}
