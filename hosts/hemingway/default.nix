{
  lib,
  pkgs,
  self,
  ...
}: {
  # Enable nix-home system modules
  nix-home.system = {
    core.enable = true;
    graphical.enable = true;
  };

  # Configure user through home-manager
  home-manager.users.alesauce = {config, ...}: {
    imports = [
      self.homeManagerModules.default
      ../../users/alesauce/dev/amzn.nix
    ];

    # Enable nix-home user modules
    nix-home.user = {
      enable = true;
      core.enable = true;
      dev.enable = true;
      graphical.enable = true;
    };

    home = {
      sessionPath = [
        "${config.home.homeDirectory}/.local/bin"
      ];
      packages = with pkgs; [
        python313
      ];
    };

    programs = {
      git.userEmail = lib.mkForce "alesauce@amazon.com";
    };
  };

  environment = {
    variables.JAVA_HOME = "$(/usr/libexec/java_home)";
    systemPackages = [(lib.hiPrio pkgs.opensshWithKerberos)];
  };

  nix = {
    gc.automatic = true;
    linux-builder.enable = true;
    settings = {
      max-substitution-jobs = 20;
      system-features = ["big-parallel" "gccarch-armv8-a"];
      trusted-users = ["alesauce"];
    };
  };

  users.users.alesauce = {
    uid = 504;
    gid = 20;
  };

  system.primaryUser = "alesauce";
}
