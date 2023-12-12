{lib, ...}: {
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;
      format = lib.concatStrings [
        "$username"
        "$hostname"
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
        "$character"
      ];
    };
  };
}
