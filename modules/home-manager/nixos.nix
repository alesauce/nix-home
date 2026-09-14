{
  inputs,
  config,
  ...
}: {
  flake.modules.nixos.base = {
    imports = [inputs.home-manager.nixosModules.home-manager];

    home-manager = {
      backupFileExtension = "backup";
      useGlobalPkgs = true;
      useUserPackages = true;
      users.${config.flake.meta.owner.username}.imports = [config.flake.modules.homeManager.base];
    };
  };
}
