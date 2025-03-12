{
  base16-schemes,
  hostType,
  lib,
  nix-index-database,
  pkgs,
  stylix,
  ...
}: {
  imports = [
    nix-index-database.hmModules.nix-index
    stylix.homeManagerModules.stylix

    ./atuin.nix
    ./btop.nix
    ./git.nix
    ./htop.nix
    ./neovim.nix
    ./starship.nix
    ./tmux.nix
    ./xdg.nix
    ./zsh.nix
  ];

  # XXX: Manually enabled in the graphic module
  dconf.enable = false;

  home = {
    username = "alesauce";
    stateVersion = "23.11";
    packages = with pkgs; [
      alejandra
      eza
      fd
      fzf
      ripgrep
      tmuxp
      tree
    ];
    shellAliases = {
      cat = "bat";
      ls = "eza --icons --classify --binary --header --long";
      man = "batman";
      # Adding this so that Alacritty works with remote hosts
      ssh = "TERM=xterm-256color ssh";
    };
  };

  programs = {
    bat = {
      enable = true;
      extraPackages = with pkgs.bat-extras; [batman];
    };
    nix-index.enable = true;
    zoxide.enable = true;
  };

  stylix = {
    enable = true;
    base16Scheme = "${base16-schemes}/catppuccin-mocha.yaml";
    image = ../../../graphical/mt_fuji_across_lake.jpg;
    targets = {
      gnome.enable = hostType == "nixos";
      gtk.enable = hostType == "nixos";
      kde.enable = lib.mkDefault false;
      xfce.enable = lib.mkDefault false;
    };
  };

  systemd.user.startServices = "sd-switch";

  xdg.configFile."nixpkgs/config.nix".text = "{ allowUnfree = true; }";
}
