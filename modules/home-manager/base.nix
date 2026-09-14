{config, ...}: {
  flake.modules.homeManager.base = {pkgs, ...}: {
    home = {
      inherit (config.flake.meta.owner) username;
      homeDirectory =
        if pkgs.stdenv.hostPlatform.isDarwin
        then "/Users/${config.flake.meta.owner.username}"
        else "/home/${config.flake.meta.owner.username}";
      # TODO: allow per-host override for future hosts on different versions
      # https://github.com/search?q=repo%3Amightyiam%2Finfra%20stateVersion&type=code
      stateVersion = "23.11";
    };
    programs.home-manager.enable = true;
    systemd.user.startServices = "sd-switch";
  };
}
