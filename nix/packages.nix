{ self, nix-fast-build, ... }:

hostPlatform:

let
  inherit (self.pkgs.${hostPlatform}) lib linkFarm;

  # TODO: add nixos back in here when that gets going
  # https://github.com/lovesegfault/nix-config/blob/master/nix/packages.nix
  homeDrvs = lib.mapAttrs (_: home: home.activationPackage) self.homeConfigurations;
  darwinDrvs = lib.mapAttrs (_: darwin: darwin.system) self.darwinConfigurations;
  hostDrvs = homeDrvs // darwinDrvs;

  compatHosts = lib.filterAttrs (_: host: host.hostPlatform == hostPlatform) self.hosts;
  compatHostDrvs = lib.mapAttrs
    (name: _: hostDrvs.${name})
    compatHosts;

  compatHostsFarm = linkFarm "hosts-${hostPlatform}" (lib.mapAttrsToList (name: path: { inherit name path; }) compatHostDrvs);
in
compatHostDrvs
// (lib.optionalAttrs (compatHosts != { }) {
  default = compatHostsFarm;
}) // {
  inherit (nix-fast-build.packages.${hostPlatform}) nix-fast-build;
  inherit (self.pkgs.${hostPlatform}) cachix nix-eval-jobs;
}
