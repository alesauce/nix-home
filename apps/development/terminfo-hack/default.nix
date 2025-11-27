{
  nix-config.apps.terminfo-hack = {
    tags = ["development"];

    home = {pkgs, ...}: {
      home.file.".terminfo".source = pkgs.symlinkJoin {
        name = "terminfo-dirs";
        paths = with pkgs; [
          (ncurses + "/share/terminfo")
          (ghostty + "/share/terminfo")
        ];
      };
    };
  };
}
