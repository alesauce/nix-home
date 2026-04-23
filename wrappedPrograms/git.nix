{
  config,
  inputs,
  lib,
  ...
}: let
  # Defined as a let binding so perSystem can import it directly
  # without going through self.modules (avoids self-reference cycle).
  # Other flakes consume it via inputs.nix-home.modules.programs.git.main.
  gitModule = {
    config,
    lib,
    pkgs,
    ...
  }: {
    options = {
      userEmail = lib.mkOption {
        type = lib.types.str;
        description = "Git user email address.";
      };
      userName = lib.mkOption {
        type = lib.types.str;
        description = "Git user display name.";
      };
      githubUser = lib.mkOption {
        type = lib.types.str;
        description = "GitHub username for github.user config key. Defaults to userName downcased — override when GH handle differs.";
      };
    };

    config = {
      extraPackages = [pkgs.delta pkgs.git-lfs];

      settings = {
        user = {
          email = config.userEmail;
          name = config.userName;
        };
        core.pager = lib.getExe pkgs.delta;
        interactive.diffFilter = "${lib.getExe pkgs.delta} --color-only";
        delta = {
          navigate = true;
          syntax-theme = "Nord";
        };
        diff.colorMoved = "default";
        difftool.prompt = true;
        github.user = config.githubUser;
        init.defaultBranch = "main";
        merge.conflictstyle = "diff3";
        mergetool.prompt = true;
      };
    };
  };
in {
  flake.modules.programs.git.main = gitModule;

  perSystem = {pkgs, ...}: {
    packages.git = inputs.wrapper-modules.wrappers.git.wrap {
      inherit pkgs;
      imports = [gitModule];
      userEmail = config.flake.meta.owner.email;
      userName = config.flake.meta.owner.name;
      githubUser = config.flake.meta.owner.username;
    };
  };
}
