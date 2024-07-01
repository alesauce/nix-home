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

    ./btop.nix
    ./git.nix
    ./htop.nix
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
      fh
      fzf
      kalker
      mosh
      neovim
      ripgrep
      tmuxp
      tree
    ];
    shellAliases = {
      cat = "bat";
      ls = "eza --icons --classify --binary --header --long";
      man = "batman";
      vim = "nvim";
      vi = "nvim";
      # Adding this so that Alacritty works with remote hosts
      ssh = "TERM=xterm-256color ssh";
      # tmux aliases
      ",tk" = "tmux kill-session";
      ",tka" = "tmux kill-server";
      ",tkt" = "tmux kill-session -t";
      ",tls" = "tmux ls";
      ",tn" = "tmux new";
      ",ta" = "tmux attach -t";
    };
  };

  programs = {
    atuin = {
      enable = true;
      settings.auto_sync = false;
      flags = ["--disable-up-arrow"];
    };
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
    image = pkgs.fetchurl {
      url = "https://www.amazon.com/photos/shared/sm6sTzxXQYOkgT5EwtJAUA.oLstPFMFeG-SoN0CGYou67/gallery/_DYiRRFrSyWc3lk8F_Tmzw";
      hash = "sha256-+j5sFXwqaVYGbhIwVf9642+FQl6a1KnQtkfMHPcbVFw=";
    };
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
