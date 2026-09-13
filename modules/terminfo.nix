_: {
  flake.modules.homeManager.base = {pkgs, ...}: {
    home.file.".terminfo".source = pkgs.symlinkJoin {
      name = "terminfo-dirs";
      paths = with pkgs; [
        (ncurses + "/share/terminfo")
        ((
            if stdenv.hostPlatform.isDarwin
            then ghostty-bin
            else ghostty
          )
          + "/share/terminfo")
      ];
    };
  };
}
