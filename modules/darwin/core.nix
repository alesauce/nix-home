# Darwin-specific core system module
{
  config,
  lib,
  pkgs,
  self,
  home-manager,
  nix-index-database,
  stylix,
  tinted-schemes,
  ...
}: let
  cfg = config.nix-home.system.core;
in {
  config = lib.mkIf cfg.enable {
    # Nix daemon configuration
    nix = {
      package = pkgs.nixVersions.latest;
      settings =
        {
          accept-flake-config = true;
          auto-optimise-store = false; # Causes "File exists" errors on Darwin
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
        }
        // cfg.nix.settings;

      distributedBuilds = true;
      extraOptions = ''
        !include tokens.conf
        ${cfg.nix.extraConfig}
      '';

      nixPath = ["nixpkgs=/run/current-system/sw/nixpkgs"];
      daemonIOLowPriority = false;
    };

    # Documentation
    documentation = lib.mkIf cfg.documentation.enable {
      enable = true;
      doc.enable = true;
      man.enable = true;
      info.enable = true;
    };

    # Environment configuration
    environment = {
      pathsToLink = ["/share/zsh"];
      shells = with pkgs; [zsh];
      systemPackages =
        (with pkgs; [
          gnugrep
          gnutar
          ncurses
        ])
        ++ lib.optionals cfg.aspell.enable (with pkgs; [
          aspellDicts.en
          aspellDicts.en-computers
          aspellDicts.es
        ]);
      systemPath = lib.mkBefore ["/opt/homebrew/bin"];
      variables.SHELL = lib.getExe pkgs.zsh;
      extraSetup = ''
        ln -sv ${pkgs.path} $out/nixpkgs
      '';
    };

    # Home-manager configuration
    home-manager = {
      backupFileExtension = "backup";
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = {
        hostType = "darwin";
        inherit nix-index-database stylix tinted-schemes;
      };
    };

    # Aspell configuration
    environment.etc."aspell.conf" = lib.mkIf cfg.aspell.enable {
      text = ''
        master en_US
        add-extra-dicts en-computers.rws
        add-extra-dicts es.rws
      '';
    };

    # Homebrew
    homebrew = {
      enable = true;
      brews = ["bitwarden-cli"];
      onActivation = {
        cleanup = "zap";
        autoUpdate = true;
        upgrade = true;
      };
    };

    # Services
    services.nix-daemon.logFile = "/var/log/nix-daemon.log";

    # Programs
    programs = {
      nix-index.enable = true;
      zsh.enable = true;
    };

    # System defaults
    system = {
      stateVersion = 4;
      defaults.SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;
    };

    # Default user configuration
    users.users.alesauce = {
      createHome = true;
      description = "Alexander Sauceda";
      home = "/Users/alesauce";
      isHidden = false;
      shell = pkgs.zsh;
    };
  };
}
