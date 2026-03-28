{inputs, ...}: {
  flake.modules = {
    nixos.base = {
      config,
      lib,
      pkgs,
      ...
    }: {
      users.groups.alesauce.gid = config.users.users.alesauce.uid;

      users.users.alesauce = {
        createHome = true;
        description = "Alexander Sauceda";
        group = "alesauce";
        extraGroups =
          [
            "wheel"
            "dialout"
            "audio"
            "networkmanager"
          ]
          ++ lib.optionals config.programs.sway.enable [
            "input"
            "video"
          ];
        isNormalUser = true;
        shell = pkgs.zsh;
        uid = 8888;
      };

      home-manager.users.alesauce = {lib, ...}: {
        imports = builtins.attrValues inputs.self.modules.homeManager;
        home.uid = config.users.users.alesauce.uid;
        # c.f. https://github.com/danth/stylix/issues/865
        nixpkgs.overlays = lib.mkForce null;
      };
    };

    darwin.base = {
      config,
      pkgs,
      ...
    }: {
      users.users.alesauce = {
        createHome = true;
        description = "Alexander Sauceda";
        home = "/Users/alesauce";
        isHidden = false;
        shell = pkgs.zsh;
      };

      home-manager.users.alesauce = {
        imports = builtins.attrValues inputs.self.modules.homeManager;
        home.username = config.users.users.alesauce.name;
        home.uid = config.users.users.alesauce.uid;
      };
    };

    homeManager.base = {
      nix-index-database,
      stylix,
      pkgs,
      ...
    }: {
      imports = [
        nix-index-database.hmModules.nix-index
        stylix.homeModules.stylix
        ./_uid.nix
      ];

      # XXX: Manually enabled in the linux-desktop module
      dconf.enable = false;

      home = {
        username = "alesauce";
        stateVersion = "23.11";
        packages = with pkgs; [
          age
          eternal-terminal
          eza
          fd
          fzf
          nh
          ripgrep
          tmuxp
          tree
        ];
        shellAliases = {
          cat = "bat";
          ls = "eza --icons --classify --binary --header --long";
          man = "batman";
          ssh = "TERM=xterm-256color ssh";
        };
      };

      programs = {
        bat = {
          enable = true;
          extraPackages = with pkgs.bat-extras; [batman];
        };
        nix-index.enable = true;
        zoxide.enable = true;
      };

      systemd.user.startServices = "sd-switch";

      xdg.configFile."nixpkgs/config.nix".text = "{ allowUnfree = true; }";
    };
  };
}
