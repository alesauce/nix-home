let
  tags = ["wayland"];
  disableTags = ["noCosmic"];
  systems = ["x86_64-linux" "aarch64-linux"];
in
{
  nix-config.apps.cosmic-de = {
    inherit tags systems disableTags;
    nixos = {
      services = {
          displayManager = {
            cosmic-greeter.enable = true;
          };
          desktopManager = {
            cosmic = {
              enable = true;
              xwayland.enable = true;
            };
          };
      };
    };
  };
}
