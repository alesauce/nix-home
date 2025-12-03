{lib, ...}: let
  inherit (lib.my) mkSubdirList mkFileList;
  rootDir = ./.;
in {
  imports = mkSubdirList {inherit rootDir;} ++ mkFileList {inherit rootDir;};

  nix-config = {
    defaultTags = {
      development = true;
      display = false;
      chat = false;
      entertainment = false;
      wayland = false;
    };

    apps.init = {
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
  };
}
