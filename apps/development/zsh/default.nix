{
  nix-config.apps.zsh = {
    tags = ["development"];

    home = {
      pkgs,
      config,
      lib,
      ...
    }: {
      programs.zsh = {
        enable = true;
        autosuggestion.enable = true;
        enableCompletion = true;
        autocd = true;
        dotDir = "${config.xdg.configHome}/zsh";
        history = {
          expireDuplicatesFirst = true;
          extended = true;
          ignoreDups = true;
          ignoreSpace = true;
          path = "${config.xdg.dataHome}/zsh/history";
          save = 10000;
          share = true;
        };
        plugins = [
          {
            name = "vi-mode";
            src = pkgs.zsh-vi-mode;
            file = "share/zsh/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
          }
          {
            name = "fast-syntax-highlighting";
            src = pkgs.zsh-fast-syntax-highlighting;
            file = "share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh";
          }
          {
            name = "autosuggestions";
            src = pkgs.zsh-autosuggestions;
            file = "share/zsh-autosuggestions/zsh-autosuggestions.zsh";
          }
          {
            name = "autopair";
            inherit (pkgs.zsh-autopair) src;
            file = "zsh-autopair.plugin.zsh";
          }
        ];
        envExtra = ''
          export LESSHISTFILE="${config.xdg.dataHome}/less_history"
          export CARGO_HOME="${config.xdg.cacheHome}/cargo"
        '';
        initContent = ''
          NEW_USER="''${(C)USERNAME}"
          if [ -e ~/$NEW_USER-config ]; then
            source ~/$NEW_USER-config/entry-point
          fi
        '';
        siteFunctions = let
          shellFilesDir = ./functions;
          getShellFiles = files: builtins.filter (file: lib.hasSuffix ".sh" file) files;
          shellFiles = getShellFiles (builtins.attrNames (builtins.readDir shellFilesDir));
          makeNameValuePair = file: {
            name = lib.removeSuffix ".sh" file;
            value = builtins.readFile (shellFilesDir + "/${file}");
          };
        in
          builtins.listToAttrs (map makeNameValuePair shellFiles);
        sessionVariables = {
          RPROMPT = "";
        };
      };
    };

    nixos = {
      host,
      pkgs,
      ...
    }: {
      users.users.${host.username}.shell = pkgs.zsh;
    };

    darwin = {
      host,
      pkgs,
      ...
    }: {
      users.users.${host.username}.shell = pkgs.zsh;
    };
  };
}
