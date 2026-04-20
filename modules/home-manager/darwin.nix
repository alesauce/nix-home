{inputs, ...}: {
  flake.modules.darwin.base = {
    imports = [inputs.home-manager.darwinModules.home-manager];

    home-manager = {
      backupFileExtension = "backup";
      useGlobalPkgs = true;
      useUserPackages = true;
    };
  };
}
