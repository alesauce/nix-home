let
  tags = ["chat"];
in
{
  nix-config = {
    homeApps = [
      {
        inherit tags;
        systems = [ "x86_64-linux" ];
        packages = ["beeper" "slack"];
      }
      {
        inherit tags;
        systems = [ "x86_64-linux" "aarch64-darwin" ];
        packages = ["discord"];
      }
    ];
  };
}
