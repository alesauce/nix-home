{
  inputs,
  config,
  ...
}: {
  flake.darwinConfigurations.vonnegut = inputs.darwin.lib.darwinSystem {
    modules = [
      config.flake.modules.darwin.base
      {
        # Matches `main`'s existing value — not a version to bump.
        system.stateVersion = 4;
        system.primaryUser = config.flake.meta.owner.username;
        users.users.${config.flake.meta.owner.username}.home = "/Users/${config.flake.meta.owner.username}";
      }
    ];
  };
}
