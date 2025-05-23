{
  imports = [
    ../../core
    ../../graphical
    ../../users/alesauce
  ];

  home-manager.users.alesauce = {config, ...}: {
    home.sessionPath = [
      "${config.home.homeDirectory}/.local/bin"
    ];
  };

  homebrew = {
    casks = [
      {
        name = "beeper";
        greedy = true;
      }
      {
        name = "cold-turkey-blocker";
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
}
