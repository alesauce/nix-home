{inputs, ...}: {
  flake.modules = {
    nixos.base = {
      lib,
      pkgs,
      ...
    }: {
      imports = [
        inputs.home-manager.nixosModules.home-manager
        inputs.nix-index-database.nixosModules.nix-index
        inputs.stylix.nixosModules.stylix
        inputs.sops-nix.nixosModules.sops
      ];

      environment.systemPackages = [pkgs.ghostty.terminfo];

      i18n.defaultLocale = "en_US.UTF-8";

      security = {
        rtkit.enable = true;
        sudo = {
          enable = true;
          wheelNeedsPassword = lib.mkDefault false;
        };
      };

      services = {
        openssh = {
          enable = true;
          settings.PermitRootLogin = lib.mkDefault "no";
        };
        printing.enable = true;
        pulseaudio.enable = false;
        pipewire = {
          enable = true;
          alsa.enable = true;
          alsa.support32Bit = true;
          pulse.enable = true;
        };
      };

      system.stateVersion = "25.05";

      home-manager = {
        backupFileExtension = "backup";
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = {
          inherit (inputs) nix-index-database stylix tinted-schemes;
        };
      };

      documentation = {
        enable = true;
        doc.enable = true;
        man.enable = true;
        info.enable = true;
      };

      environment.pathsToLink = ["/share/zsh"];

      programs = {
        nix-index.enable = true;
        zsh.enable = true;
      };
    };

    darwin.base = {
      lib,
      pkgs,
      ...
    }: {
      imports = [
        inputs.home-manager.darwinModules.home-manager
        inputs.nix-index-database.darwinModules.nix-index
        inputs.stylix.darwinModules.stylix
      ];

      environment = {
        shells = with pkgs; [zsh];
        systemPackages = with pkgs; [
          gnugrep
          gnutar
          ncurses
        ];
        systemPath = lib.mkBefore ["/opt/homebrew/bin"];
        variables.SHELL = lib.getExe pkgs.zsh;
        extraSetup = ''
          ln -sv ${pkgs.path} $out/nixpkgs
        '';
      };

      homebrew = {
        enable = true;
        brews = ["bitwarden-cli"];
        onActivation = {
          cleanup = "zap";
          autoUpdate = true;
          upgrade = true;
        };
      };

      services.nix-daemon.logFile = "/var/log/nix-daemon.log";

      system = {
        stateVersion = 4;
        defaults.SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;
        primaryUser = "alesauce";
      };

      home-manager = {
        backupFileExtension = "backup";
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = {
          inherit (inputs) nix-index-database stylix tinted-schemes;
        };
      };

      documentation = {
        enable = true;
        doc.enable = true;
        man.enable = true;
        info.enable = true;
      };

      environment.pathsToLink = ["/share/zsh"];

      programs = {
        nix-index.enable = true;
        zsh.enable = true;
      };
    };
  };
}
