# Neovim overlay - uses the nixvim-flake custom Neovim package
final: _: {
  neovim = final.__inputs.nixvim-flake.packages.${final.stdenv.hostPlatform.system}.default;
}
