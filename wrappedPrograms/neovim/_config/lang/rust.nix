{pkgs, ...}: {
  extraPackages = with pkgs; [
    clippy
  ];

  plugins = {
    rustaceanvim = {
      enable = true;
      settings = {
        tools = {
          enable_clippy = true;
        };
      };
    };
  };
}
