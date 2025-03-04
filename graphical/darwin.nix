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

  services.aerospace = {
    enable = true;
    settings = {
      mode.main.binding = {
        cmd-alt-ctrl-shift-k = "focus right";
        cmd-alt-ctrl-shift-j = "focus left";
        ctrl-f1 = "workspace 1";
        ctrl-f2 = "workspace 2";
        ctrl-f3 = "workspace 3";
        ctrl-f4 = "workspace 4";
        ctrl-f5 = "workspace 5";
        ctrl-f6 = "workspace 6";
        ctrl-shift-alt-1 = "move-node-to-workspace 1";
        ctrl-shift-alt-2 = "move-node-to-workspace 2";
        ctrl-shift-alt-3 = "move-node-to-workspace 3";
        ctrl-shift-alt-4 = "move-node-to-workspace 4";
        ctrl-shift-alt-5 = "move-node-to-workspace 5";
        ctrl-shift-alt-6 = "move-node-to-workspace 6";
      };
    };
  };

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
