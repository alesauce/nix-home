# Defines the flake.modules option with proper merge semantics.
# This allows multiple dendritic modules to contribute to the same
# module class (e.g., flake.modules.homeManager.base) and have
# their definitions merged as deferredModules.
{lib, ...}: {
  options.flake.modules = lib.mkOption {
    type = lib.types.lazyAttrsOf (lib.types.lazyAttrsOf lib.types.deferredModule);
    default = {};
    description = "Exported NixOS, Darwin, and Home Manager modules organized by class and role.";
  };
}
