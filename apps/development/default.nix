{
  lib,
  nix-index-database,
  ...
}: let
  inherit (lib.my) mkSubdirList;
  tags = ["development"];
in {
  imports =
    [
      nix-index-database.hmModules.nix-index
    ]
    ++ mkSubdirList {rootDir = ./.;};
  nix-config = {
    homeApps = [
      {
        inherit tags;
        packages = ["age" "eternal-terminal" "fd" "fzf" "nh" "ripgrep" "tmuxp" "tree"];
      }
    ];
    apps = {
      bat = {
        inherit tags;
        home = {pkgs, ...}: {
          programs.bat = {
            enable = true;
            extraPackages = with pkgs.bat-extras; [batman];
          };
          shellAliases = {
            cat = "bat";
            man = "batman";
          };
        };
      };
      eza = {
        inherit tags;
        home = {pkgs, ...}: {
          packages = with pkgs; [eza];
          shellAliases = {
            ls = "eza --icons --classify --binary --header --long";
          };
        };
      };
      nix-index = {
        inherit tags;
        home.programs.nix-index.enable = true;
      };
      zoxide = {
        inherit tags;
        home.programs.zoxide.enable = true;
      };
    };
  };
}
