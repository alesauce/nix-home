{
  inputs,
  config,
  ...
}: let
  neovimModule = {
    imports = [(inputs.import-tree ./_config)];
  };
in {
  flake.modules.programs.neovim.main = neovimModule;

  perSystem = {
    pkgs,
    system,
    ...
  }: {
    packages.neovim = inputs.nixvim.legacyPackages.${system}.makeNixvimWithModule {
      inherit pkgs;
      module = neovimModule;
      extraSpecialArgs.theme = config.flake.meta.theme;
    };
  };
}
