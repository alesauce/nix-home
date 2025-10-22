{
  nix-secrets,
  config,
  lib,
  ...
}: let
  secretspath = builtins.toString nix-secrets;
  enableSecrets = builtins.getEnv "ENABLE_SECRETS" == "true";
in {
  imports = [
    ../../core
    ../../graphical
    ../../users/alesauce
    ./hardware-configuration.nix
  ];

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

  users = {
    mutableUsers = enableSecrets;
    users.alesauce = {
      hashedPasswordFile = lib.mkIf enableSecrets config.sops.secrets.alesauce_passwd.path;
    };
  };

  environment.variables = {
    ENABLE_SECRETS = "true";
  };

  sops = {
    defaultSopsFile = "${secretspath}/secrets.yaml";
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

  stylix.fonts.sizes = {
    desktop = 16;
    applications = 14;
    terminal = 12;
    popups = 16;
  };
}
