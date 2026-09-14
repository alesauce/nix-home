{lib, ...}: {
  options = {
    flake.homeManagerModules = lib.mkOption {
      type = lib.types.lazyAttrsOf lib.types.deferredModule;
      default = {};
      description = ''
        Named home-manager modules, importable via `self.homeManagerModules.<name>`.
      '';
    };

    flake.darwinModules = lib.mkOption {
      type = lib.types.lazyAttrsOf lib.types.deferredModule;
      default = {};
      description = ''
        Named nix-darwin modules, importable via `self.darwinModules.<name>`.
      '';
    };
  };
}
