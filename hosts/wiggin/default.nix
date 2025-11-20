{
  lib,
  pkgs,
  ...
}: {
  # Enable nix-home modules
  nix-home.user = {
    enable = true;
    core.enable = true;
    dev.enable = true;
  };

  imports = [
    ../../users/alesauce/dev/amzn.nix
    ../../users/alesauce/core/terminfo-hack.nix
  ];

  home = {
    username = "alesauce";
    homeDirectory = "/home/alesauce";
    packages = with pkgs; [
      nix-fast-build
      nodenv
      opensshWithKerberos
      jupyter
    ];
  };

  programs = {
    bash = {
      bashrcExtra = ''
        if [ -f /etc/bashrc ]; then
          . /etc/bashrc
        fi
      '';
      profileExtra = ''
        if [ -f /etc/profile ]; then
          . /etc/profile
        fi
      '';
    };
    git.userEmail = lib.mkForce "alesauce@amazon.com";
    home-manager.enable = true;
  };
}
