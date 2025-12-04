{
  nix-config.apps.ghostty = {
    tags = ["display"];

    home = {pkgs, ...}: {
      programs.ghostty = {
        enable = true;
        enableBashIntegration = true;
        enableFishIntegration = true;
        enableZshIntegration = true;
        installBatSyntax = !pkgs.stdenv.hostPlatform.isDarwin;
        package =
          if pkgs.stdenv.hostPlatform.isDarwin
          then pkgs.ghostty-bin
          else pkgs.ghostty;
        settings = {
          quit-after-last-window-closed = true;
          auto-update = "off";
        };
      };
    };
  };
}
