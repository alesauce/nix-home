{inputs, ...}: {
  flake.modules = {
    nixos.base = {
      stylix = {
        enable = true;
        autoEnable = true;
        base16Scheme = "${inputs.tinted-schemes}/base16/catppuccin-mocha.yaml";
        homeManagerIntegration.autoImport = false;
        image = ../../assets/looking_across_lake_moraine.jpg;
      };
    };

    darwin.base = {
      stylix = {
        enable = true;
        autoEnable = true;
        base16Scheme = "${inputs.tinted-schemes}/base16/catppuccin-mocha.yaml";
        homeManagerIntegration.autoImport = false;
        image = ../../assets/looking_across_lake_moraine.jpg;
      };
    };

    homeManager.base = {
      pkgs,
      lib,
      tinted-schemes,
      ...
    }: {
      stylix = {
        enable = true;
        base16Scheme = "${tinted-schemes}/base16/catppuccin-mocha.yaml";
        image = ../../assets/looking_across_lake_moraine.jpg;
        targets = {
          gnome.enable = pkgs.stdenv.isLinux;
          gtk.enable = pkgs.stdenv.isLinux;
          kde.enable = lib.mkDefault false;
          xfce.enable = lib.mkDefault false;
          nixvim.plugin = "base16-nvim";
        };
      };
    };
  };
}
