{inputs, ...}: let
  ghDashModule = {
    config,
    lib,
    pkgs,
    ...
  }: {
    options.settings = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = {};
      description = "gh-dash config.yml settings.";
    };

    config = {
      package = lib.mkDefault pkgs.gh-dash;
      env.GH_DASH_CONFIG = config.constructFiles.configYml.path;
      constructFiles.configYml = {
        content = builtins.toJSON config.settings;
        relPath = "config.yml";
      };
    };
  };
in {
  flake.modules.programs.gh-dash.main = ghDashModule;

  perSystem = {pkgs, ...}: {
    packages.gh-dash = inputs.wrapper-modules.lib.wrapPackage {
      inherit pkgs;
      imports = [ghDashModule];
      settings.prSections = [
        {
          title = "My Pull Requests";
          filters = "is:open author:@me";
        }
      ];
    };
  };
}
