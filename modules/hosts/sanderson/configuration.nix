{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.sandersonConfiguration = {
    pkgs,
    lib,
    ...
  }: {
    imports = [
      self.nixosModules.sandersonHardware
    ];

    nix.settings.experimental-features = ["nix-command" "flakes"];
  };
}
