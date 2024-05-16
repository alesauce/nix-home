{
  lib,
  pkgs,
  ...
}: {
  home = {
    extraOutputsToInstall = ["doc" "devdoc"];
    packages = with pkgs; [
      duckdb
      git-lfs
      nix-output-monitor
      (lib.hiPrio nixpkgs-review)
      nix-update
    ];
  };

  programs = {
    direnv = {
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

    gh = {
      enable = true;
      settings.git_protocol = "ssh";
    };
  };
}
