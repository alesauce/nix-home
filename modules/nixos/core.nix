# NixOS-specific core system module
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.nix-home.system.core;
in {
  options.nix-home.system.core = import ./options.nix {inherit lib;};

  config = lib.mkIf cfg.enable {
    # Nix daemon configuration
    nix = {
      package = pkgs.nixVersions.latest;
      settings =
        {
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
        }
        // cfg.nix.settings;

      distributedBuilds = true;
      extraOptions = ''
        !include tokens.conf
        ${cfg.nix.extraConfig}
      '';

      daemonCPUSchedPolicy = "batch";
      daemonIOSchedPriority = 5;
      nixPath = ["nixpkgs=/run/current-system/nixpkgs"];
      optimise = {
        automatic = true;
        dates = ["03:00"];
      };
    };

    documentation = lib.mkIf cfg.documentation.enable {
      enable = true;
      doc.enable = true;
      man.enable = true;
      info.enable = true;
    };

    environment = {
      pathsToLink = ["/share/zsh"];
      systemPackages =
        [pkgs.ghostty.terminfo]
        ++ lib.optionals cfg.aspell.enable (with pkgs; [
          aspellDicts.en
          aspellDicts.en-computers
          aspellDicts.es
        ]);
    };

    environment.etc."aspell.conf" = lib.mkIf cfg.aspell.enable {
      text = ''
        master en_US
        add-extra-dicts en-computers.rws
        add-extra-dicts es.rws
      '';
    };

    i18n.defaultLocale = "en_US.UTF-8";

    security = {
      rtkit.enable = true;
      sudo.enable = true;
      sudo.wheelNeedsPassword = lib.mkDefault false;
    };

    services = {
      openssh.enable = true;
      openssh.settings.PermitRootLogin = lib.mkDefault "no";
      printing.enable = true;
      pulseaudio.enable = false;
      pipewire.enable = true;
      pipewire.alsa.enable = true;
      pipewire.alsa.support32Bit = true;
      pipewire.pulse.enable = true;
    };

    programs = {
      nix-index.enable = true;
      zsh.enable = true;
    };

    system.stateVersion = "25.05";
  };
}
