# Fish shell overlay - disables tests to work around build issues
# TODO: Remove overlay when https://github.com/NixOS/nixpkgs/pull/462090 merges
final: prev: {
  fish = prev.fish.overrideAttrs (oldAttrs: {
    doCheck = false;
    checkPhase = "";
    cmakeFlags =
      (oldAttrs.cmakeFlags or [])
      ++ [
        "-DBUILD_TESTING=OFF"
      ];
  });
}
