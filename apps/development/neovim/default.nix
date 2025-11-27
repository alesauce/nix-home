{
  nix-config.apps.neovim = {
    tags = ["development"];

    home = {
      config,
      pkgs,
      ...
    }: {
      # c.f. https://github.com/danth/stylix/blob/e7c09d206680e6fe6771e1ac9a83515313feaf95/docs/src/configuration.md#standalone-nixvim
      # https://github.com/alesauce/nixvim-flake/
      home.packages = [(pkgs.alesauce-nixvim.extend config.lib.stylix.nixvim.config)];
      home.sessionVariables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
      };
      programs.git.extraConfig.core.editor = "nvim";
    };
  };
}
