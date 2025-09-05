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

  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
    };
    ladybird = {
      enable = true;
    };
  };
}
