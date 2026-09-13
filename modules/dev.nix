_: {
  flake.modules.homeManager.base = {
    home.extraOutputsToInstall = ["doc" "devdoc"];
  };
}
