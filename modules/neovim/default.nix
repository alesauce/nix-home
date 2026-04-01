{
  flake.modules.homeManager.base = {
    config,
    pkgs,
    ...
  }: {
    home.packages = [(pkgs.alesauce-nixvim.extend config.lib.stylix.nixvim.config)];
    home.sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
    programs.git.extraConfig.core.editor = "nvim";
  };
}
