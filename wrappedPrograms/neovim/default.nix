{
  inputs,
  config,
  ...
}: let
  neovimModule = {
    imports = [(inputs.import-tree ./_config)];
  };

  allLanguagesModule = _: {
    config.languages = {
      bash.enable = true;
      haskell.enable = true;
      java.enable = true;
      kotlin.enable = true;
      nix.enable = true;
      rust.enable = true;
      scala.enable = true;
      typescript.enable = true;
    };
  };
in {
  flake.modules.programs.neovim = neovimModule;

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

    packages.neovim-full = inputs.nixvim.legacyPackages.${system}.makeNixvimWithModule {
      inherit pkgs;
      module = {
        imports = [neovimModule allLanguagesModule];
      };
      extraSpecialArgs.theme = config.flake.meta.theme;
    };
  };
}
