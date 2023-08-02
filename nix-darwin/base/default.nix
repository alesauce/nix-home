{ overlays, pkgs, ... }:

{
  config = {
    fonts = {
      fontDir.enable = true;
      fonts = with pkgs; [
        recursive
        (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" ]; })
      ];
    };

    nix = {
      package = pkgs.nixVersions.unstable;
      settings = {
        auto-optimise-store = true;
        build-users-group = "nixbld";
        experimental-features = "nix-command flakes";
        extra-nix-path = "nixpkgs=flake:nixpkgs";
        max-jobs = "auto";
        warn-dirty = false;
      };
    };

    nixpkgs = {
      config = { allowUnfree = true; };
      inherit overlays;
    };

    programs = {
      nix-index.enable = true;
      zsh.enable = true;
    };

    services.nix-daemon.enable = true;

    security.pam.enableSudoTouchIdAuth = true;

    system = {
      defaults = {
        dock = {
          autohide = true;
          mru-spaces = false;
          orientation = "right";
          show-recents = false;
          # Uncomment to show only open applications on the dock
          # static-only = true;
        };
        finder.CreateDesktop = false;
        magicmouse.MouseButtonMode = "TwoButton";
        menuExtraClock.Show24Hour = true;
        NSGlobalDomain = {
          "com.apple.keyboard.fnState" = true;
          "com.apple.swipescrolldirection" = false;
        };
        screencapture.location = "/Users/alesauce/screenshots";
        SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;
        spaces.spans-displays = false;
      };

      # TODO: look into additional keymappings for base computer or disabling keyboard:
      # https://developer.apple.com/library/archive/technotes/tn2450/_index.html
      keyboard.enableKeyMapping = true;
      keyboard.remapCapsLockToEscape = true;
    };

    users.users.alesauce.name = "alesauce";
    users.users.alesauce.home = pkgs.homeDirectory;
  };
}
