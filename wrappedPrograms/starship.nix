{
  inputs,
  lib,
  ...
}: let
  starshipModule = _: {
    config.settings = {
      add_newline = false;
      character.error_symbol = "[✗](bold red)";
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
in {
  flake.modules.programs.starship.main = starshipModule;

  perSystem = {pkgs, ...}: {
    packages.starship = inputs.wrapper-modules.wrappers.starship.wrap {
      inherit pkgs;
      imports = [starshipModule];
    };
  };
}
