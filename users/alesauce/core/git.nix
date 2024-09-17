{
  programs.git = {
    enable = true;
    delta = {
      enable = true;
      options = {
        navigate = true;
        syntax-theme = "Nord";
      };
    };
    lfs.enable = true;
    userEmail = "alexander@alexandersauceda.dev";
    userName = "Alexander Sauceda";
    extraConfig = {
      core.editor = "nvim";
      diff = {
        colorMoved = "default";
      };
      difftool.prompt = true;
      github.user = "alesauce";
      init.defaultBranch = "main";
      merge.conflictstyle = "diff3";
      mergetool.prompt = true;
    };
  };

  home.shellAliases = {
    ",g" = "git";
    ",ga" = "git add";
    ",gaa" = "git add -A";
    ",gb" = "git branch";
    ",gch" = "git checkout";
    ",gcl" = "git clone";
    ",gco" = "git commit";
    ",gcom" = "git commit --message";
    ",gcoa" = "git commit --amend";
    ",gcoan" = "git commit --amend --no-edit";
    ",gdf" = "git diff";
    ",gdfs" = "git diff --staged";
    ",gl" = "git log --decorate --pretty=format:'%C(auto)%h %C(green)(%as)%C(reset)%C(blue) %<(20,trunc) %an%C(reset) %s%C(auto)%d'";
    ",gm" = "git merge";
    ",gma" = "git merge --abort";
    ",gmc" = "git merge --continue";
    ",gms" = "git merge --squash";
    ",gpl" = "git pull --rebase";
    ",gps" = "git push";
    ",grs" = "git restore";
    ",grss" = "git restore --staged";
    ",gs" = "git status";
    ",gsw" = "git switch";
    ",grb" = "git rebase";
    ",grba" = "git rebase --abort";
    ",grbc" = "git rebase --continue";
  };
}
