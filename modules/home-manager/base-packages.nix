{
  flake.modules.homeManager.base = {pkgs, ...}: {
    home = {
      extraOutputsToInstall = ["doc" "devdoc"];
      packages = with pkgs; [
        duckdb
        git-lfs
        insomnia
        jujutsu
        nix-output-monitor
        tldr
        uv
        wireshark
      ];
    };
  };
}
