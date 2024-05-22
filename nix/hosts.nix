let
  hasSuffix = suffix: content: let
    inherit (builtins) stringLength substring;
    lenContent = stringLength content;
    lenSuffix = stringLength suffix;
  in
    lenContent
    >= lenSuffix
    && substring (lenContent - lenSuffix) lenContent content == suffix;

  mkHost = {
    type,
    hostPlatform,
    homeDirectory ? null,
  }:
    if type == "nixos"
    then
      assert (hasSuffix "linux" hostPlatform); {
        inherit type hostPlatform;
      }
    else if type == "darwin"
    then
      assert (hasSuffix "darwin" hostPlatform); {
        inherit type hostPlatform;
      }
    else if type == "home-manager"
    then
      assert homeDirectory != null; {
        inherit type hostPlatform homeDirectory;
      }
    else throw "unknown host type '${type}'";
in {
  hemingway = mkHost {
    type = "darwin";
    hostPlatform = "aarch64-darwin";
  };
  vonnegut = mkHost {
    type = "darwin";
    hostPlatform = "aarch64-darwin";
  };
  wiggin = mkHost {
    type = "home-manager";
    hostPlatform = "x86_64-linux";
    homeDirectory = "/home/alesauce";
  };
}
