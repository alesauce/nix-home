# Development tools module
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.nix-home.user.dev;
in {
  config = lib.mkIf cfg.enable {
    # Development packages
    home = {
      extraOutputsToInstall = cfg.extraOutputsToInstall;
      packages =
        (with pkgs; [
          duckdb
          goose-cli
          git-lfs
          insomnia
          jujutsu
          nix-output-monitor
          tldr
          uv
        ])
        ++ cfg.packages.dev;
    };

    # Direnv configuration
    programs.direnv = lib.mkIf cfg.tools.direnv.enable {
      enable = true;
      nix-direnv.enable = true;
      stdlib = ''
        : ''${XDG_CACHE_HOME:=$HOME/.cache}
        declare -A direnv_layout_dirs
        direnv_layout_dir() {
            echo "''${direnv_layout_dirs[$PWD]:=$(
                echo -n "$XDG_CACHE_HOME"/direnv/layouts/
                echo -n "$PWD" | shasum | cut -d ' ' -f 1
            )}"
        }
      '';
    };

    # GitHub CLI configuration
    programs.gh = lib.mkIf cfg.tools.gh.enable {
      enable = true;
      settings.git_protocol = "ssh";
    };

    # GitHub Dashboard configuration
    programs.gh-dash = lib.mkIf cfg.tools.ghDash.enable {
      enable = true;
      settings = {
        prSections = [
          {
            title = "My Pull Requests";
            filters = "is:open author:@me";
          }
        ];
      };
    };

    # Jujutsu (jj) is enabled via package in home.packages
    # It's controlled by cfg.tools.jujutsu.enable through conditional inclusion
  };
}
