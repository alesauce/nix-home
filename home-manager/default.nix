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
          packages = with pkgs; [ fd ripgrep gh htop wget cheat ];
        };

        programs = import ./programs.nix { inherit pkgs; };

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
          # TODO: figure out less noob-y way to handle shell scripts
          # TODO: figure out how to patch the shebang from Nix
          "tmux-cht.sh" = {
            source = ./tmux/tmux-cht.sh;
            target = "tmux/tmux-cht.sh";
            executable = true;
          };
        };
      };
    };
  };
}
