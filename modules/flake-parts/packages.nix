{
  perSystem = {inputs', ...}: {
    packages = {
      inherit (inputs'.nix-fast-build.packages) nix-fast-build;
    };
  };
}
