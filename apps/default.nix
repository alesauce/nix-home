{lib, ...}: let
  inherit (lib.my) mkSubdirList;
in {
  imports = mkSubdirList {rootDir = ./.;};

  nix-config.defaultTags = {
    development = true;
  };

  nix-config.apps.init = {
    enable = true;
    home = {pkgs, ...}: {
      dconf.enable = lib.mkIf pkgs.stdenv.isLinux (lib.mkForce true);
      systemd.user.startServices = "sd-switch";
      xdg = {
        enable = true;
        configFile."nixpkgs/config.nix".text = "{ allowUnfree = true; }";
        mimeApps.enable = pkgs.stdenv.isLinux;
        userDirs = {
          enable = pkgs.stdenv.isLinux;
          desktop = "$HOME/opt";
          documents = "$HOME/doc";
          download = "$HOME/tmp";
          music = "$HOME/mus";
          pictures = "$HOME/img";
          publicShare = "$HOME/opt";
          templates = "$HOME/opt";
          videos = "$HOME/opt";
        };
      };
    };
  };
}
