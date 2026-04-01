{inputs, ...}: {
  perSystem = {system, ...}: {
    _module.args.pkgs = import inputs.nixpkgs {
      localSystem = system;
      overlays = [inputs.self.overlays.default];
      config = {
        allowUnfree = true;
        allowAliases = true;
      };
    };
  };
}
