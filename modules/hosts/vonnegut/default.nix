{
  self,
  inputs,
  config,
  ...
}: {
  flake.darwinConfigurations.vonnegut = inputs.darwin.lib.darwinSystem {
    modules = [
      config.flake.modules.darwin.base
      self.darwinModules.aerospace
      ({pkgs, ...}: {
        system = {
          # Matches `main`'s existing value — not a version to bump.
          stateVersion = 4;
          primaryUser = config.flake.meta.owner.username;
          defaults.SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;
        };

        users.users.${config.flake.meta.owner.username} = {
          home = "/Users/${config.flake.meta.owner.username}";
          createHome = true;
          description = config.flake.meta.owner.name;
          isHidden = false;
          shell = pkgs.zsh;
        };

        homebrew.brews = ["bitwarden-cli"];

        # TODO: OmniWM (https://github.com/BarutSRB/OmniWM) — Apple Silicon
        # niri-style scrolling WM. Not packaged for nix (Swift app needing
        # code-signing/Accessibility entitlements); official install is
        # `brew install --cask omniwm`, so `homebrew.casks = ["omniwm"];`
        # here whenever this gets picked up. Waiting to see how niri feels
        # on Linux first before investing in a second scrolling WM.

        # TODO: `main`'s real graphical/darwin.nix has a bunch of real,
        # tuned machine polish that hasn't been ported to this branch yet:
        # homebrew casks (aldente/appcleaner/brave-browser/firefox@nightly/
        # ghostty/keymapp/obsidian/raycast/reader, all greedy=true),
        # security.pam.services.sudo_local.touchIdAuth, and system.defaults
        # for dock/finder/menuExtraClock/NSGlobalDomain/screencapture/
        # spaces, plus system.keyboard (Colemak input source, caps->escape).
        # See "Nix-Home Window Manager Abstraction" vault note for the full
        # itemized list.
      })
    ];
  };
}
