{
  self,
  inputs,
  config,
  ...
}: {
  # TODO: restore `enableSecrets = builtins.getEnv "ENABLE_SECRETS" == "true";`
  # let binding when the users/sops blocks below are re-enabled.
  flake.nixosConfigurations.sanderson = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      config.flake.modules.nixos.base
      self.nixosModules.sandersonConfiguration
      (_: {
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

        # mutableUsers = true: password stays manually managed (passwd/live
        # account), no declarative password directive needed yet. Revisit
        # once sops-nix is wired up and we want the password itself declared.
        users = {
          mutableUsers = true;
          groups.alesauce = {};
          users.alesauce = {
            isNormalUser = true;
            group = "alesauce";
            extraGroups = ["wheel" "networkmanager"];
          };
        };

        environment.variables = {
          ENABLE_SECRETS = "true";
        };

        # TODO: add sops-nix as a flake input and import its NixOS module, then re-enable.
        # sops = {
        #   defaultSopsFile = ./../../secrets.yaml;
        #   age = {
        #     sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
        #     keyFile = "/var/lib/sops-nix/key.txt";
        #     generateKey = true;
        #   };
        #   secrets = {
        #     alesauce_passwd = {
        #       neededForUsers = true;
        #     };
        #   };
        # };

        # TODO: add stylix as a flake input and import its NixOS module, then re-enable.
        # stylix.fonts.sizes = {
        #   desktop = 16;
        #   applications = 14;
        #   terminal = 12;
        #   popups = 16;
        # };
      })
    ];
  };
}
