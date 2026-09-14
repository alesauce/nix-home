{
  self,
  inputs,
  config,
  ...
}: let
  enableSecrets = builtins.getEnv "ENABLE_SECRETS" == "true";
in {
  flake.nixosConfigurations.sanderson = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      config.flake.modules.nixos.base
      self.nixosModules.sandersonConfiguration
      self.nixosModules.niri
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

        # Matches `main`'s existing setup — same uid/gid so ownership of the
        # real box's home dir doesn't shift. mutableUsers stays true (password
        # managed by hand) until ENABLE_SECRETS=true is passed at eval time
        # (see the sops block below), at which point the password comes from
        # the encrypted secret instead.
        users = {
          mutableUsers = !enableSecrets;
          groups.alesauce.gid = config.users.users.alesauce.uid;
          users.alesauce = {
            isNormalUser = true;
            createHome = true;
            description = "Alexander Sauceda";
            group = "alesauce";
            extraGroups = ["wheel" "networkmanager" "dialout" "audio"];
            uid = 8888;
            shell = pkgs.zsh;
            # zsh is wrapped separately (wrappedPrograms/zsh) rather than via
            # programs.zsh, so skip the check that wants that module enabled.
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

        # stylix.nixosModules.stylix isn't imported yet (see modules/theme.nix)
        # — its regreet submodule doesn't evaluate against the pinned
        # nixpkgs-unstable rev (`services.displayManager.regreet` option is
        # gone/renamed upstream), and it's greeter/DM theming anyway, which
        # is moot until sanderson has a DE. Revisit alongside that.
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
