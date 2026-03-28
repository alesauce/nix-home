{
  flake.modules.homeManager.base = {pkgs, ...}: {
    programs.ghostty = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
      installBatSyntax = !pkgs.stdenv.hostPlatform.isDarwin;
      # FIXME: Remove this hack when the nixpkgs pkg works again
      package =
        if pkgs.stdenv.hostPlatform.isDarwin
        then pkgs.hello
        else pkgs.ghostty;
      settings = {
        quit-after-last-window-closed = true;
      };
    };
  };
}
