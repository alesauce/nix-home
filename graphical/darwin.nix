{
  homebrew = {
    casks = [
      {
        name = "aldente";
        greedy = true;
      }
      {
        name = "appcleaner";
        greedy = true;
      }
      {
        name = "firefox@nightly";
        greedy = true;
      }
      {
        name = "keymapp";
        greedy = true;
      }
      {
        name = "obsidian";
        greedy = true;
      }
      {
        name = "raycast";
        greedy = true;
      }
      {
        name = "reader";
        greedy = true;
      }
      {
        name = "spotify";
        greedy = true;
      }
    ];
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  system = {
    defaults = {
      dock = {
        autohide = true;
        orientation = "right";
        show-recents = false;
      };
      finder = {
        CreateDesktop = false;
        QuitMenuItem = true;
      };
      menuExtraClock.Show24Hour = true;
      NSGlobalDomain = {
        AppleInterfaceStyle = "Dark";
        "com.apple.keyboard.fnState" = true;
        "com.apple.swipescrolldirection" = false;
      };
      screencapture.location = "/Users/alesauce/screenshots";
      spaces.spans-displays = false;
    };
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
    };
  };
}
