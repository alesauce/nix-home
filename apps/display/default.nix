{lib, ...}:
let
  inherit (lib.my) mkSubdirList;
  tags = ["display"];
  systems = ["x86_64-linux"];
in
{
  imports = mkSubdirList {rootDir = ./.;};
  nix-config = {
    homeApps = [
      {
        inherit tags;
        packages = ["xdg-utils" "rbw"];
      }
      {
        inherit tags systems;
        packages = [
          "brave"
          "obsidian"
          "todoist-electron"
        ];
      }
    ];
  };
}
