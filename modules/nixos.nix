_: {
  flake.modules = {
    homeManager.base = {
      pkgs,
      lib,
      ...
    }: {
      home.packages = lib.mkIf pkgs.stdenv.hostPlatform.isLinux [pkgs.xwayland-satellite];
    };
    nixos.base = {lib, ...}: {
      documentation = {
        enable = true;
        doc.enable = true;
        man.enable = true;
        info.enable = true;
      };

      environment.pathsToLink = ["/share/zsh"];

      i18n.defaultLocale = "en_US.UTF-8";

      programs.nix-index.enable = true;

      security.rtkit.enable = true;

      services = {
        openssh = {
          enable = true;
          permitRootLogin = lib.mkDefault "no";
        };
        printing.enable = true;
        pulseaudio.enable = false;
        pipewire = {
          enable = true;
          alsa.enable = true;
          alsa.support32Bit = true;
          pulse.enable = true;
        };
      };
    };
  };
}
