{
  flake.modules.homeManager.base = {
    programs.mise = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
