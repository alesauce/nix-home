{
  services = {
    displayManager = {
      cosmic-greeter.enable = true;
    };
    desktopManager = {
      cosmic = {
        enable = true;
        xwayland.enable = true;
      };
    };
  };
}
