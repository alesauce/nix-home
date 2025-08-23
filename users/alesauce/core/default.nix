{
  hostType,
  lib,
  nix-index-database,
  pkgs,
  stylix,
  tinted-schemes,
  ...
}: {
  imports = [
    nix-index-database.hmModules.nix-index
    stylix.homeModules.stylix

    ./zsh
    ./atuin.nix
    ./btop.nix
    ./git.nix
    ./htop.nix
    ./neovim.nix
    ./starship.nix
    ./tmux.nix
    ./xdg.nix
  ];

  # XXX: Manually enabled in the graphic module
  dconf.enable = false;

  home = {
    username = "alesauce";
    stateVersion = "23.11";
    packages = with pkgs; [
      alejandra
      eternal-terminal
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
      ",wp" = ''fzd -m 2 -M 2 -i "build logs"'';
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
    base16Scheme = "${tinted-schemes}/base16/catppuccin-mocha.yaml";
    image = ../../../graphical/mt_fuji_across_lake.jpg;
    targets = {
      gnome.enable = hostType == "nixos";
      gtk.enable = hostType == "nixos";
      kde.enable = lib.mkDefault false;
      xfce.enable = lib.mkDefault false;
      nixvim = {
        plugin = "base16-nvim";
      };
    };
  };

  systemd.user.startServices = "sd-switch";

  xdg.configFile."nixpkgs/config.nix".text = "{ allowUnfree = true; }";
}
