{ pkgs, ... }:

{
  direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  fzf = {
    enable = true;
  };

  home-manager = {
    enable = true;
  };

  nixvim = import ./nvim.nix {
    inherit pkgs;
  };

  starship = {
    enable = true;
    enableNushellIntegration = true;
    enableZshIntegration = true;
    settings = {
      hostname.ssh_only = false;
    };
  };

  tmux = import ./tmux.nix {
    inherit (pkgs) tmuxPlugins;
  };

  zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
  };
}
