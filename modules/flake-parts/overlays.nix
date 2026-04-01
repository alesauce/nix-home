{inputs, ...}: let
  inherit (inputs.nixpkgs) lib;

  localOverlays = {
    # TODO: Remove overlay when https://github.com/NixOS/nixpkgs/pull/462090 merges
    fish = final: prev: {
      fish = prev.fish.overrideAttrs (oldAttrs: {
        doCheck = false;
        checkPhase = "";
        cmakeFlags =
          (oldAttrs.cmakeFlags or [])
          ++ [
            "-DBUILD_TESTING=OFF"
          ];
      });
    };

    neovim = final: _: {
      neovim = inputs.nixvim-flake.packages.${final.stdenv.hostPlatform.system}.default;
    };
  };
in {
  flake.overlays =
    localOverlays
    // {
      default = lib.composeManyExtensions (
        (lib.attrValues localOverlays)
        ++ [
          inputs.nixvim-flake.overlays.default
          inputs.nur.overlays.default
          (final: _: {
            inherit (inputs.nix-fast-build.packages.${final.stdenv.hostPlatform.system}) nix-fast-build;
          })
        ]
      );
    };
}
