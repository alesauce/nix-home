# Host definition helpers and validation
{lib}: let
  # Check if a string ends with a suffix
  hasSuffix = suffix: content: let
    inherit (builtins) stringLength substring;
    lenContent = stringLength content;
    lenSuffix = stringLength suffix;
  in
    lenContent
    >= lenSuffix
    && substring (lenContent - lenSuffix) lenContent content == suffix;

  # Validate host type and platform combination
  validateHost = type: hostPlatform:
    if type == "nixos"
    then
      assert lib.assertMsg
      (hasSuffix "linux" hostPlatform)
      "NixOS hosts must use a Linux platform (got ${hostPlatform})"; true
    else if type == "darwin"
    then
      assert lib.assertMsg
      (hasSuffix "darwin" hostPlatform)
      "Darwin hosts must use a Darwin platform (got ${hostPlatform})"; true
    else if type == "home-manager"
    then true # Home-manager works on any platform
    else throw "Unknown host type '${type}'. Valid types: nixos, darwin, home-manager";
in {
  # Create a host definition with validation
  mkHost = {
    type,
    hostPlatform,
    homeDirectory ? null,
    modules ? [],
    specialArgs ? {},
    extraSpecialArgs ? {},
  }:
    assert validateHost type hostPlatform;
      if type == "home-manager"
      then
        assert lib.assertMsg
        (homeDirectory != null)
        "home-manager hosts require a homeDirectory to be specified"; {
          inherit type hostPlatform homeDirectory modules extraSpecialArgs;
        }
      else {
        inherit type hostPlatform modules specialArgs;
      };

  # Generate configurations from a host attrset
  # Used by the builder functions to filter and map hosts
  filterHostsByType = hostType: hosts:
    lib.filterAttrs (_: host: host.type == hostType) hosts;

  # Validate a complete hosts attrset
  validateHosts = hosts: let
    invalidHosts =
      lib.filterAttrs
      (_: host: !(builtins.elem host.type ["nixos" "darwin" "home-manager"]))
      hosts;
  in
    if builtins.length (builtins.attrNames invalidHosts) > 0
    then throw "Invalid host types found: ${builtins.toString (builtins.attrNames invalidHosts)}"
    else hosts;

  # Helper to get all host platforms for CI/CD
  getHostPlatforms = hosts:
    lib.unique (lib.mapAttrsToList (_: host: host.hostPlatform) hosts);

  # Helper to get hosts by platform
  getHostsByPlatform = platform: hosts:
    lib.filterAttrs (_: host: host.hostPlatform == platform) hosts;
}
