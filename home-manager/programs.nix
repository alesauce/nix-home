{ pkgs, ... }:

{
  direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  exa = {
    enable = true;
  };

  fzf = {
    enable = true;
  };

  home-manager = {
    enable = true;
  };

  pls = {
    enable = true;
    enableAliases = true;
  };

  starship = {
    enable = true;
    enableNushellIntegration = true;
    enableZshIntegration = true;
    settings = {
      hostname.ssh_only = false;
    };
  };

  zoxide = {
    enable = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
  };

  zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
  };
}
