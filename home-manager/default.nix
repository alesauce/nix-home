{ pkgs, ... }:

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
        imports = [ ./neovim ./tmux ];
        home = {
          inherit (pkgs) stateVersion;
          packages = with pkgs; [ ripgrep gh nixfmt nixpkgs-fmt htop wget ];
        };

        programs = import ./programs.nix { inherit pkgs; };

        xdg.configFile = {
          "alacritty" = {
            source = ./configs/alacritty;
            recursive = false;
          };
        };
      };
    };
  };
}
