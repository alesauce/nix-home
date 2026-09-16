{
  config,
  inputs,
  lib,
  ...
}: let
  # bat/delta name their bundled Catppuccin syntax themes "Catppuccin <Flavor>"
  # (title case, space-joined) — a naming convention specific to bat, not part
  # of the general theme.family/flavor pair, so the transform lives here
  # rather than in modules/theme.nix.
  titleCase = s: lib.toUpper (builtins.substring 0 1 s) + builtins.substring 1 (-1) s;
  batThemeName = "${titleCase config.flake.meta.theme.family} ${titleCase config.flake.meta.theme.flavor}";

  # Defined as a let binding so perSystem can import it directly
  # without going through self.modules (avoids self-reference cycle).
  # Other flakes consume it via inputs.nix-home.modules.programs.git.
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
      runtimePkgs = [pkgs.delta pkgs.git-lfs];

      settings = {
        user = {
          email = config.userEmail;
          name = config.userName;
        };
        core = {
          editor = "nvim";
          pager = lib.getExe pkgs.delta;
        };
        interactive.diffFilter = "${lib.getExe pkgs.delta} --color-only";
        delta = {
          navigate = true;
          syntax-theme = batThemeName;
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
  flake.modules.programs.git = gitModule;

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
