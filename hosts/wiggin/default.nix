{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../../users/alesauce
    ../../users/alesauce/dev/amzn.nix
  ];

  home = {
    uid = 22314791;
    packages = with pkgs; [
      nix-fast-build
      nodejs_18
      nodenv
      opensshWithKerberos
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
  };
}
