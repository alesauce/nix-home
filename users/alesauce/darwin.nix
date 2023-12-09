{ pkgs, ... }: {
  home-manager.users.alesauce = {
    imports = [
      ./graphical
    ];
  };

  users.users.alesauce = {
    createHome = true;
    description = "Alexander Sauceda";
    home = "/Users/alesauce";
    isHidden = false;
    shell = pkgs.zsh;
  };
}
