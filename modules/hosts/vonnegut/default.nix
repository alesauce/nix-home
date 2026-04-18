{
  self,
  inputs,
  ...
}: {
  flake.darwinConfigurations.vonnegut = inputs.nix-darwin.lib.darwinSystem {};
}
