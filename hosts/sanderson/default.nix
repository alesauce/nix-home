{
  imports = [
    ../../core
    ../../graphical
    ../../users/alesauce
  ];

  networking = {
    hostName = "sanderson";
  };

  security = {
    sudo.wheelNeedsPassword = true;
  };

  stylix.fonts.sizes = {
    desktop = 16;
    applications = 14;
    terminal = 12;
    popups = 16;
  };
}
