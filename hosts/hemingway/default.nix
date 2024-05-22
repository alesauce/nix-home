{lib, ...}: {
  imports = [
    ../../core
    ../../graphical
    ../../users/alesauce
  ];

  environment.variables.JAVA_HOME = "$(/usr/libexec/java_home)";

  home-manager.users.alesauce = {config, ...}: {
    imports = [../../users/alesauce/dev/amzn.nix];
    home.sessionPath = [
      "${config.home.homeDirectory}/.local/bin"
    ];
    programs = {
      git.userEmail = lib.mkForce "alesauce@amazon.com";
    };
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
