{inputs, ...}: let
  ghModule = {
    config,
    lib,
    pkgs,
    ...
  }: {
    options.settings = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = {};
      description = "gh CLI config.yml settings.";
    };

    config = {
      package = lib.mkDefault pkgs.gh;
      env.GH_CONFIG_DIR = dirOf config.constructFiles.configYml.path;
      constructFiles.configYml = {
        content = builtins.toJSON config.settings;
        relPath = "config.yml";
      };
    };
  };
in {
  flake.modules.programs.gh.main = ghModule;

  perSystem = {pkgs, ...}: {
    packages.gh = inputs.wrapper-modules.lib.wrapPackage {
      inherit pkgs;
      imports = [ghModule];
      settings.git_protocol = "ssh";
    };
  };
}
