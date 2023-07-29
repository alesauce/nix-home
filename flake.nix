{
  description = "alesauce's Darwin configs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
	url = "github:lnl7/nix-darwin";
	inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
	url = "github:nix-community/home-manager";
	inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager }:
  let
    username = "alesauce";
    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ pkgs.vim
        ];

      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
      # nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true;  # default shell on catalina
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 4;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#Alexanders-MacBook-Pro
    darwinConfigurations."Alexanders-MacBook-Pro" = nix-darwin.lib.darwinSystem {
      modules = [
	self.darwinModules.base
	self.darwinModules.homebrew-handler
	home-manager.darwinModules.home-manager
	./home-manager
      ];
    };

    darwinModules = {
      base = { pkgs, ...}: import ./nix-darwin/base {
	inherit pkgs;
      };

      homebrew-handler = {
	imports = [ ./nix-darwin/homebrew-handler ];
      };
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."Alexanders-MacBook-Pro".pkgs;
  };
}
