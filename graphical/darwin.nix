{
  homebrew = {
    casks = [
      {
        name = "alacritty";
        greedy = true;
      }
      {
        name = "aldente";
        greedy = true;
      }
      {
        name = "alt-tab";
        greedy = true;
      }
      {
        name = "amethyst";
        greedy = true;
      }
      {
        name = "appcleaner";
        greedy = true;
      }
      {
        name = "arc";
        greedy = true;
      }
      {
        name = "firefox";
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
        name = "spotify";
        greedy = true;
      }
      {
        name = "todoist";
        greedy = true;
      }
    ];
  };

  security.pam.enableSudoTouchIdAuth = true;

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
