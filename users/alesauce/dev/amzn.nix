{
  config,
  pkgs,
  ...
}: {
  home = {
    sessionPath = [
      "${config.home.homeDirectory}/.toolbox/bin"
    ];
    sessionVariables = {
      BRAZIL_PLATFORM_OVERRIDE =
        if pkgs.stdenv.hostPlatform.isAarch64
        then "AL2_aarch64"
        else if pkgs.stdenv.hostPlatform.isx86_64
        then "AL2_x86_64"
        else null;
    };
  };

  programs.zsh.initExtraBeforeCompInit = ''
    fpath+=("${config.home.homeDirectory}/.zsh/completion")
    fpath+=("${config.home.homeDirectory}/.brazil_completion/zsh_completion")
  '';
}
