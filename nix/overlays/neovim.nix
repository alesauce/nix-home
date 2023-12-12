final: _: {
  neovim = final.__inputs.nixvim-flake.packages.${final.__inputs.pkgs.hostPlatform.system}.default;
}
