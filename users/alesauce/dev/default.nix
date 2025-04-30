{pkgs, ...}: {
  home = {
    extraOutputsToInstall = ["doc" "devdoc"];
    packages = with pkgs; [
      aider-chat-with-bedrock
      duckdb
      git-lfs
      nix-output-monitor
      tldr
    ];
    sessionVariables = {
      AIDER_DARK_MODE = "true";
    };
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

    gh-dash = {
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
  };
}
