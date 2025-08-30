{
  imports = [
    ../../core
    ../../graphical
    ../../users/alesauce
  ];

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
  };

  security = {
    sudo.wheelNeedsPassword = true;
  };

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

  stylix.fonts.sizes = {
    desktop = 16;
    applications = 14;
    terminal = 12;
    popups = 16;
  };
}
