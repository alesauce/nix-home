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
        home = {
	  inherit (pkgs) stateVersion;
          packages = with pkgs; [
	    ripgrep
	    gh
	    nixfmt
	    nixpkgs-fmt
	    htop
	    wget
	  ];
	};
        programs = import ./programs.nix { inherit pkgs; };
      };
    };
  };
}
