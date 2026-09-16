{
  inputs,
  config,
  ...
}: let
  claudeCodeModule = {
    lib,
    config,
    ...
  }: {
    options.readOnlyPaths = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Absolute paths Claude Code may read without a permission prompt, in addition to the project directory.";
    };

    config.settings = {
      editorMode = "vim";
      tui = "fullscreen";
      enabledPlugins."caveman@caveman" = true;
      extraKnownMarketplaces.caveman.source = {
        source = "github";
        repo = "JuliusBrussee/caveman";
      };
      permissions = {
        allow = map (p: "Read(${p}/**)") config.readOnlyPaths;
        additionalDirectories = config.readOnlyPaths;
      };
    };
  };
in {
  flake.modules.programs.claude-code = claudeCodeModule;

  nixpkgs.overlays = [inputs.claude-code-nix.overlays.default];
  nixpkgs.config.allowUnfreePackages = ["claude-code"];

  perSystem = {pkgs, ...}: {
    packages.claude-code = inputs.wrapper-modules.wrappers.claude-code.wrap {
      inherit pkgs;
      imports = [claudeCodeModule];
      readOnlyPaths = [
        (
          if pkgs.stdenv.hostPlatform.isDarwin
          then "/Users/${config.flake.meta.owner.username}/workplace/vaults"
          else "/home/${config.flake.meta.owner.username}/workplace/vaults"
        )
      ];
    };
  };
}
