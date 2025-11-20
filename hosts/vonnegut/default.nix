{
  lib,
  pkgs,
  self,
  ...
}: {
  # Enable nix-home modules
  nix-home.system = {
    core.enable = true;
    graphical.enable = true;
  };

  home-manager.users.alesauce = {config, ...}: {
    imports = [
      self.homeManagerModules.default
    ];

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
  };

  homebrew = {
    casks = [
      {
        name = "beeper";
        greedy = true;
      }
      {
        name = "todoist";
        greedy = true;
      }
    ];
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
