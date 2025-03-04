{pkgs, ...}: {
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
      controlcenter.BatteryShowPercentage = true;
      dock = {
        autohide = true;
        orientation = "right";
        show-recents = false;
        mru-spaces = false;
        persistent-apps = [
          {
            app = "/System/Applications/Launchpad.app";
          }
          {
            app = "${pkgs.alacritty}/Applications/Alacritty.app";
          }
          {
            app = "/System/Volumes/Data/Applications/Firefox Nightly.app";
          }
          {
            app = "/System/Volumes/Data/Applications/Obsidian.app";
          }
          {
            app = "/System/Volumes/Data/Applications/Todoist.app";
          }
        ];
      };
      finder = {
        CreateDesktop = false;
        QuitMenuItem = true;
        FXRemoveOldTrashItems = true;
      };
      menuExtraClock.Show24Hour = true;
      NSGlobalDomain = {
        AppleICUForce24HourTime = true;
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
