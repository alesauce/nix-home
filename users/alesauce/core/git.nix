{ pkgs, ... }: {
  programs.git = {
    enable = true;
    delta = {
      enable = true;
      options = {
        navigate = true;
        syntax-theme = "Nord";
      };
    };
    package = pkgs.gitFull;
    lfs.enable = true;
    userEmail = "alexander@alexandersauceda.dev";
    userName = "Alexander Sauceda";
    extraConfig = {
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

  home.shellAliases = rec {
    ga = "git add";
    gaa = "${ga} -A";
    gb = "git branch";
    gch = "git checkout";
    gcl = "git clone";
    gco = "git commit";
    gcom = "${gco} --message";
    gcoa = "${gco} --amend";
    gcoan = "${gcoa} --no-edit";
    gdf = "git diff";
    gdfs = "${gdf} --staged";
    gdt = "git difftool";
    gdts = "${gdt} --staged";
    gl = "git log --decorate --pretty=format:'%C(auto)%h %C(green)(%as)%C(reset)%C(blue) %<(20,trunc) %an%C(reset) %s%C(auto)%d'";
    gm = "git merge";
    gma = "${gm} --abort";
    gmc = "${gm} --continue";
    gpl = "git pull --rebase";
    gps = "git push";
    grb = "git rebase";
    grba = "${grb} --abort";
    grbc = "${grb} --continue";
    grbsn = "${grb} --exec 'git commit --amend --no-edit -n -S'";
    grs = "git restore";
    grss = "${grs} --staged";
    gs = "git status";
    gsw = "git switch";
    gswc = "${gsw} -c";
    gswcf = "${gsw} -C";
  };
}
