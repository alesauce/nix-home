{lib, ...}: {
  nix-config.apps.starship = {
    tags = ["development"];

    home = {...}: {
      programs.starship = {
        enable = true;
        enableZshIntegration = true;
        settings = {
          add_newline = false;
          character = {
            error_symbol = "[✗](bold red)";
          };
          time.disabled = false;
          format = lib.concatStrings [
            "$username"
            "$hostname"
            "$time"
            "$directory"
            "$git_branch"
            "$git_commit"
            "$git_state"
            "$git_status"
            "$package"
            "$haskell"
            "$python"
            "$rust"
            "$java"
            "$nix_shell"
            "$line_break"
            "$jobs"
            "$cmd_duration"
            "$character"
          ];
        };
      };
    };
  };
}
