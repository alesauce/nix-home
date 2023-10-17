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
          # TODO: move nixfmt to language-specific flake
          packages = with pkgs; [ fd ripgrep gh htop wget cheat nixfmt jq tmuxp tree ];
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
        };
      };
    };
  };
}
