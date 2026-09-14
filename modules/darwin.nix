{config, ...}: let
  ownerUsername = config.flake.meta.owner.username;
in {
  flake.modules.darwin.base = {
    pkgs,
    lib,
    ...
  }: {
    environment = {
      shells = [pkgs.zsh];
      systemPackages = [
        pkgs.gnugrep
        pkgs.gnutar
        pkgs.ncurses
      ];
      systemPath = lib.mkBefore ["/opt/homebrew/bin"];
      variables.SHELL = lib.getExe pkgs.zsh;
      extraSetup = ''
        ln -sv ${pkgs.path} $out/nixpkgs
      '';
    };

    services.nix-daemon.logFile = "/var/log/nix-daemon.log";

    homebrew = {
      enable = true;
      onActivation = {
        cleanup = "zap";
        autoUpdate = true;
        upgrade = true;
      };
      casks = map (name: {
        inherit name;
        greedy = true;
      }) ["aldente" "appcleaner" "brave-browser" "firefox@nightly" "keymapp" "obsidian" "raycast" "reader"];
    };

    security.pam.services.sudo_local.touchIdAuth = true;

    system = {
      keyboard = {
        enableKeyMapping = true;
        remapCapsLockToEscape = true;
      };

      defaults = {
        controlcenter.BatteryShowPercentage = true;
        CustomUserPreferences = {
          "com.apple.HIToolbox" = {
            AppleCurrentKeyboardLayoutInputSourceID = "com.apple.keylayout.US";
            AppleEnabledInputSources = [
              {
                InputSourceKind = "Keyboard Layout";
                "KeyboardLayout ID" = 0;
                "KeyboardLayout Name" = "U.S.";
              }
              {
                "Bundle ID" = "com.apple.CharacterPaletteIM";
                InputSourceKind = "Non Keyboard Input Method";
              }
              {
                InputSourceKind = "Keyboard Layout";
                "KeyboardLayout ID" = 12825;
                "KeyboardLayout Name" = "Colemak";
              }
            ];
          };
        };
        dock = {
          autohide = true;
          orientation = "right";
          show-recents = false;
          mru-spaces = false;
          persistent-apps = [
            {app = "/System/Applications/Launchpad.app";}
            {app = "/Users/${ownerUsername}/Applications/Home Manager Apps/Ghostty.app";}
            {app = "/System/Volumes/Data/Applications/Firefox Nightly.app";}
            {app = "/System/Volumes/Data/Applications/Obsidian.app";}
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
        screencapture.location = "/Users/${ownerUsername}/screenshots";
        spaces.spans-displays = false;
      };
    };
  };
}
