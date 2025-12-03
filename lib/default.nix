{lib ? import <nixpkgs/lib> {}, ...}: let
    inherit (builtins) readDir;
  inherit (lib.lists) elem optional;
    inherit (lib.attrsets) foldlAttrs;
in  {
  mkSubdirList = {
      rootDir,
      excludeList ? [],
    }: (
      foldlAttrs (
        accumulator: name: type:
          accumulator ++ optional (type == "directory" && ! elem name excludeList)
      )
      []
      (readDir rootDir)
    );

  mkFileList = let
  inherit (lib) hasSuffix;
  in {
    rootDir,
    fileSuffix ? ".nix",
    excludeList ? ["default.nix"],
  }: (
      foldlAttrs (
        accumulator: name: type:
          accumulator ++ optional (type == "file" && ! elem name excludeList && hasSuffix fileSuffix name)
      )
      []
      (readDir rootDir)
  );
}
