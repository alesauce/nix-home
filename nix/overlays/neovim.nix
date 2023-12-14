final: _: {
  neovim = final.__inputs.nixvim-flake.packages.${final.stdenv.hostPlatform.system}.default;
}
