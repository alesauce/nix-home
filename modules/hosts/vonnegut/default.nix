{
  inputs,
  config,
  ...
}: {
  flake.darwinConfigurations.vonnegut = inputs.darwin.lib.darwinSystem {
    modules = [config.flake.modules.darwin.base];
  };
}
