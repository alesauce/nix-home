{
  inputs,
  config,
  ...
}: {
  flake.darwinConfigurations.vonnegut = inputs.darwin.lib.darwinSystem {
    modules = [
      config.flake.modules.darwin.base
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
      })
    ];
  };
}
