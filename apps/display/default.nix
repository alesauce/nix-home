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
      {
        inherit tags;
        systems = [ "x86_64-linux" "aarch64-darwin" "aarch64-linux"];
        disableTags = ["non-experimental"];
        packages = [
          "ladybird"
        ];
      }
    ];
  };
}
