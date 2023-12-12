{
  base16-schemes,
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
    stateVersion = "23.05";
    # TODO: add a reference to nixvim flake here, also need to reference the system variable here - might need to use the forAllSystems function to pass that in
    # referencing: https://gist.github.com/siph/288b7c6b5f68a1902d28aebc95fde4c5
    packages = with pkgs; [
      alejandra
      eza
      fd
      fzf
      kalker
      mosh
      neovim
      ripgrep
      tmuxp
      tree
    ];
    shellAliases = {
      ",cat" = "bat";
      ",cls" = "clear";
      ",l" = "ls";
      ",la" = "ls --all";
      ",ls" = "eza --binary --header --long --classify";
      ",man" = "batman";
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
    base16Scheme = "${base16-schemes}/ayu-mirage.yaml";
  };

  systemd.user.startServices = "sd-switch";

  xdg.configFile."nixpkgs/config.nix".text = "{ allowUnfree = true; }";
}
