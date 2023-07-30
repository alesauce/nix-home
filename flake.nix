{
  description = "alesauce's Darwin configs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = { 
      url = "github:nix-community/nixvim"; 
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, nixvim, ... }:
    let
      username = "alesauce";
      stateVersion = "23.05";

      overlays = [
        (final: prev: {
          homeDirectory = if (prev.stdenv.isDarwin) then
            "/Users/${username}"
          else
            "/home/${username}";

          inherit stateVersion username;
        })
      ];
    in {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#Alexanders-MacBook-Pro
      darwinConfigurations."Alexanders-MacBook-Pro" =
        nix-darwin.lib.darwinSystem {
	  inherit inputs;
          modules = [
            self.darwinModules.base
            self.darwinModules.homebrew-handler
            home-manager.darwinModules.home-manager {
	      home-manager.users.alesauce.imports = [
	        inputs.nixvim.homeManagerModules.nixvim
	      ];
	    }
	    ./home-manager
          ];
        };

      darwinModules = {
        base = { pkgs, ... }:
          import ./nix-darwin/base { inherit overlays pkgs; };

        homebrew-handler = { imports = [ ./nix-darwin/homebrew-handler ]; };
      };

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations."Alexanders-MacBook-Pro".pkgs;
    };
}
