let
  tags = ["entertainment"];
in
{
  nix-config = {
    homeApps = [
      {
        inherit tags;
        systems = [ "x86_64-linux" "aarch64-darwin" ];
        packages = [
          "spotify"
        ];
      }
    ];
  };
}
