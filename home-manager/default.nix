{ ... }:

{
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnsupportedSystem = true;
    };
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users = {
      alesauce = { pkgs, ... }: {
        imports = [ ./neovim ./tmux ./zsh.nix ];
        home = {
          inherit (pkgs) stateVersion;
          packages = with pkgs; [ fd ripgrep gh htop wget cheat nixfmt jq];
        };

        programs = import ./programs.nix { inherit pkgs; };

        home.file = {
          "amethyst" = {
            source = ./amethyst/amethyst.yml;
            target = ".amethyst.yml";
          };
        };

        xdg.configFile = {
          "alacritty" = {
            source = ./alacritty;
            recursive = false;
          };
          # TODO: figure out more elegant way to handle multiple config files
          "tmux-cht-command" = {
            source = ./tmux/tmux-cht-command;
            target = "tmux/tmux-cht-command";
          };
          "tmux-cht-languages" = {
            source = ./tmux/tmux-cht-languages;
            target = "tmux/tmux-cht-languages";
          };
        };
      };
    };
  };
}
