{lib ? import <nixpkgs/lib> {}, ...}: {
  mkSubdirList = let
    inherit (builtins) readDir;
    inherit (lib.attrsets) foldlAttrs;
    inherit (lib.lists) optional elem;
  in
    {
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
}
