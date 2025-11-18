# TODO: Remove overlay when https://github.com/NixOS/nixpkgs/pull/462090 merges
_: prev: {
  fish = prev.fish.overrideAttrs {
    doCheck = false;
  };
}
