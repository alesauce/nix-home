{inputs, ...}: {
  flake.modules = {
    nixos.base = {
      pkgs,
      lib,
      ...
    }: {
      nix = {
        package = pkgs.nixVersions.latest;
        settings = {
          accept-flake-config = true;
          auto-optimise-store = true;
          allowed-users = ["@wheel"];
          build-users-group = "nixbld";
          builders-use-substitutes = true;
          trusted-users = ["root" "@wheel"];
          sandbox = true;
          substituters = [
            "https://nix-config.cachix.org"
            "https://nix-community.cachix.org"
          ];
          trusted-public-keys = [
            "nix-config.cachix.org-1:Vd6raEuldeIZpttVQfrUbLvXJHzzzkS0pezXCVVjDG4="
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          ];
          cores = 0;
          max-jobs = "auto";
          experimental-features = ["auto-allocate-uids" "nix-command" "flakes"];
          connect-timeout = 5;
          http-connections = 0;
          flake-registry = "/etc/nix/registry.json";
        };
        distributedBuilds = true;
        extraOptions = ''
          !include tokens.conf
        '';
        daemonCPUSchedPolicy = "batch";
        daemonIOSchedPriority = 5;
        nixPath = ["nixpkgs=/run/current-system/nixpkgs"];
        optimise = {
          automatic = true;
          dates = ["03:00"];
        };
      };
    };

    darwin.base = {
      pkgs,
      lib,
      ...
    }: {
      nix = {
        package = pkgs.nixVersions.latest;
        settings = {
          accept-flake-config = true;
          # XXX: Causes annoying "cannot link ... to ...: File exists" errors on Darwin
          auto-optimise-store = false;
          allowed-users = ["@wheel"];
          build-users-group = "nixbld";
          builders-use-substitutes = true;
          trusted-users = ["root" "@wheel"];
          sandbox = false;
          substituters = [
            "https://nix-config.cachix.org"
            "https://nix-community.cachix.org"
          ];
          trusted-public-keys = [
            "nix-config.cachix.org-1:Vd6raEuldeIZpttVQfrUbLvXJHzzzkS0pezXCVVjDG4="
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          ];
          cores = 0;
          max-jobs = "auto";
          experimental-features = ["auto-allocate-uids" "nix-command" "flakes"];
          connect-timeout = 5;
          http-connections = 0;
          flake-registry = "/etc/nix/registry.json";
        };
        distributedBuilds = true;
        extraOptions = ''
          !include tokens.conf
        '';
        nixPath = ["nixpkgs=/run/current-system/sw/nixpkgs"];
        daemonIOLowPriority = false;
      };
    };
  };
}
