{
  self,
  inputs,
  config,
  ...
}: let
  enableSecrets = builtins.getEnv "ENABLE_SECRETS" == "true";
in {
  nixpkgs.config.allowUnfreePackages = ["steam" "steam-unwrapped" "discord"];

  flake.nixosConfigurations.sanderson = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      config.flake.modules.nixos.base
      self.nixosModules.sandersonConfiguration
      self.nixosModules.niri
      {
        home-manager.users.${config.flake.meta.owner.username}.imports = [
          self.homeManagerModules.ghostty
          self.homeManagerModules.niri
          self.homeManagerModules.noctalia
        ];
      }
      ({
        lib,
        config,
        pkgs,
        ...
      }: {
        # Matches `main`'s existing value — this is a marker of what NixOS
        # version the box was first installed with, not a version to bump.
        system.stateVersion = "25.05";

        boot = {
          loader.grub = {
            enable = true;
            device = "/dev/nvme0n1";
            useOSProber = true;
          };
        };

        hardware = {
          steam-hardware.enable = true;
        };

        programs = {
          steam = {
            enable = true;
            remotePlay.openFirewall = true;
          };
          # TODO: ladybird is currently marked insecure in nixpkgs
          # ladybird.enable = true;
        };

        environment.systemPackages = [pkgs.discord];

        nix = {
          gc = {
            automatic = true;
            dates = "02:30";
          };
          settings.max-substitution-jobs = 32;
          settings.system-features = [
            "nixos-test"
            "benchmark"
            "big-parallel"
            "kvm"
            "gccarch-znver3"
          ];
        };

        networking = {
          hostName = "sanderson";
          networkmanager.enable = true;
          # wireless.enable = true;
        };

        security = {
          sudo.wheelNeedsPassword = true;
        };

        programs.firefox.enable = true;

        services = {
          chrony = {
            enable = true;
            servers = [
              "time.nist.gov"
              "time.cloudflare.com"
              "time.google.com"
              "tick.usnogps.navy.mil"
            ];
            extraConfig = ''
              allow 10.0.0.0/24
            '';
          };
        };

        time.timeZone = "America/Denver";

        users = {
          mutableUsers = !enableSecrets;
          groups.alesauce.gid = 8888;
          users.alesauce = {
            isNormalUser = true;
            createHome = true;
            description = "Alexander Sauceda";
            group = "alesauce";
            extraGroups = ["wheel" "networkmanager" "dialout" "audio"];
            uid = 1000;
            shell = self.packages.${pkgs.stdenv.hostPlatform.system}.environment;
            ignoreShellProgramCheck = true;
            hashedPasswordFile = lib.mkIf enableSecrets config.sops.secrets.alesauce_passwd.path;
            initialPassword = lib.mkIf (!enableSecrets) "tempPassword";
          };
        };

        environment.variables = {
          ENABLE_SECRETS = "true";
        };

        sops = {
          defaultSopsFile = ../../../secrets.yaml;
          age = {
            sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
            keyFile = "/var/lib/sops-nix/key.txt";
            generateKey = true;
          };
          secrets = {
            alesauce_passwd = {
              neededForUsers = true;
            };
          };
        };
      })
    ];
  };
}
