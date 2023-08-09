{ ... }:

{
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      ll = "ls -l";
      ".." = "cd ..";

      # git aliases
      ga = "git add";
      gs = "git status";
      gr = "git restore";
      gl = "git log";
      gc = "git commit -m";
      gp = "git push";

      # tmux aliases
      tk = "tmux kill-session";
      tn = "tmux new";
    };
    initExtra = ''
      NEW_USER="''${(C)USERNAME}"
      if [ -e ~/$NEW_USER-config ]; then 
        source ~/$NEW_USER-config/entry-point
      fi
    '';
  };
}
