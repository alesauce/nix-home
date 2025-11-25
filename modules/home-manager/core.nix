# Core user tools module
{
  config,
  lib,
  pkgs,
  tinted-schemes,
  ...
}: let
  cfg = config.nix-home.user.core;
  defaultScheme = "${tinted-schemes}/base16/catppuccin-mocha.yaml";
in {
  config = lib.mkIf cfg.enable {
    # Home configuration
    home = {
      username = cfg.username;
      homeDirectory =
        if cfg.homeDirectory != ""
        then cfg.homeDirectory
        else
          (
            if pkgs.stdenv.isDarwin
            then "/Users/${cfg.username}"
            else "/home/${cfg.username}"
          );
      stateVersion = cfg.stateVersion;

      # Core packages
      packages =
        (with pkgs; [
          age
          alejandra
          eternal-terminal
          eza
          fd
          fzf
          nh
          ripgrep
          tmuxp
          tree
        ])
        ++ cfg.packages.core
        ++ lib.optionals cfg.tools.neovim.enable [
          (
            if cfg.tools.neovim.package != null
            then cfg.tools.neovim.package
            else (pkgs.alesauce-nixvim.extend config.lib.stylix.nixvim.config)
          )
        ]
        ++ lib.optionals cfg.tools.btop.enable (with pkgs; [btop]);

      # Shell aliases - merge defaults with user-provided
      shellAliases =
        {
          # File operations
          cat = "bat";
          ls = "eza --icons --classify --binary --header --long";
          man = "batman";
          # SSH with proper TERM for Alacritty
          ssh = "TERM=xterm-256color ssh";
        }
        // cfg.shellAliases
        // lib.optionalAttrs cfg.tools.git.enable {
          ",g" = "git";
          ",ga" = "git add";
          ",gaa" = "git add -A";
          ",gb" = "git branch";
          ",gch" = "git checkout";
          ",gcl" = "git clone";
          ",gco" = "git commit";
          ",gcom" = "git commit --message";
          ",gcoa" = "git commit --amend";
          ",gcoan" = "git commit --amend --no-edit";
          ",gdf" = "git diff";
          ",gdfs" = "git diff --staged";
          ",gl" = "git log --decorate --pretty=format:'%C(auto)%h %C(green)(%as)%C(reset)%C(blue) %<(20,trunc) %an%C(reset) %s%C(auto)%d'";
          ",gm" = "git merge";
          ",gma" = "git merge --abort";
          ",gmc" = "git merge --continue";
          ",gms" = "git merge --squash";
          ",gpl" = "git pull --rebase";
          ",gps" = "git push";
          ",grs" = "git restore";
          ",grss" = "git restore --staged";
          ",gs" = "git status";
          ",gsw" = "git switch";
          ",grb" = "git rebase";
          ",grba" = "git rebase --abort";
          ",grbc" = "git rebase --continue";
        }
        // lib.optionalAttrs cfg.tools.tmux.enable {
          ",tk" = "tmux kill-session";
          ",tka" = "tmux kill-server";
          ",tkt" = "tmux kill-session -t";
          ",tls" = "tmux ls";
          ",tn" = "tmux new";
          ",ta" = "tmux attach -t";
        };
    };

    # XDG configuration
    xdg = {
      enable = true;
      mimeApps.enable = pkgs.stdenv.isLinux;
      userDirs = {
        enable = pkgs.stdenv.isLinux;
        desktop = "$HOME/opt";
        documents = "$HOME/doc";
        download = "$HOME/tmp";
        music = "$HOME/mus";
        pictures = "$HOME/img";
        publicShare = "$HOME/opt";
        templates = "$HOME/opt";
        videos = "$HOME/opt";
      };
      configFile."nixpkgs/config.nix".text = "{ allowUnfree = true; }";
    };

    # Git configuration
    programs.git = lib.mkIf cfg.tools.git.enable {
      inherit (cfg.tools.git) userEmail userName;
      enable = true;
      delta = {
        enable = true;
        options = {
          navigate = true;
          syntax-theme = "Nord";
        };
      };
      ignores = [
        # nix
        "result"
        "result-man"
      ];
      lfs.enable = true;
      extraConfig =
        {
          diff.colorMoved = "default";
          difftool.prompt = true;
          github.user = "alesauce";
          init.defaultBranch = "main";
          merge.conflictstyle = "diff3";
          mergetool.prompt = true;
        }
        // lib.optionalAttrs cfg.tools.neovim.enable {
          core.editor = "nvim";
        }
        // cfg.tools.git.extraConfig;
    };

    home.sessionVariables = lib.mkIf cfg.tools.neovim.enable {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    # Tmux configuration
    programs.tmux = lib.mkIf cfg.tools.tmux.enable {
      enable = true;
      tmuxp.enable = true;
      sensibleOnTop = false;
      aggressiveResize = true;
      clock24 = true;
      newSession = false;
      baseIndex = 1;
      plugins = with pkgs.tmuxPlugins; [
        tmux-fzf
        vim-tmux-navigator
        catppuccin
        yank
      ];
      terminal = "tmux-256color";
      historyLimit = 30000;
      disableConfirmationPrompt = true;
      keyMode = "vi";
      mouse = true;
      customPaneNavigationAndResize = true;
      extraConfig = ''
        # update the env when attaching to an existing session
        set -g update-environment -r
        # automatically renumber windows
        set -g renumber-windows on

        bind R source-file ~/.config/tmux/tmux.conf \; display-message "Config reloaded..."

        # Copy mode keybindings
        bind-key -T copy-mode-vi v send-keys -X begin-selection
        bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
        bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

        # Open panes in current directory with new bindings
        bind | split-window -h -c "#{pane_current_path}"
        bind - split-window -v -c "#{pane_current_path}"
        bind c new-window -c "#{pane_current_path}"
        unbind '"'
        unbind %

        bind : command-prompt
        set-window-option -g automatic-rename
      '';
    };

    # Zsh configuration
    programs.zsh = lib.mkIf cfg.tools.zsh.enable {
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
      envExtra = ''
        export LESSHISTFILE="${config.xdg.dataHome}/less_history"
        export CARGO_HOME="${config.xdg.cacheHome}/cargo"
      '';
      initContent = ''
        source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh

        source ${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh

        source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh

        source ${pkgs.zsh-autopair.src}/zsh-autopair.plugin.zsh

        NEW_USER="''${(C)USERNAME}"
        if [ -e ~/$NEW_USER-config ]; then
          source ~/$NEW_USER-config/entry-point
        fi

        ${lib.optionalString cfg.tools.atuin.enable ''
          if [[ $options[zle] = on ]]; then
            zvm_after_init_commands+=(eval \"$(${lib.getExe pkgs.atuin} init zsh)\")
          fi
        ''}
      '';
      siteFunctions = let
        shellFilesDir = ../../users/alesauce/core/zsh/functions;
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

    # Starship configuration
    programs.starship = lib.mkIf cfg.tools.starship.enable {
      enable = true;
      enableZshIntegration = true;
      settings = {
        add_newline = false;
        character.error_symbol = "[✗](bold red)";
        time.disabled = false;
        format = lib.concatStrings [
          "$username"
          "$hostname"
          "$time"
          "$directory"
          "$git_branch"
          "$git_commit"
          "$git_state"
          "$git_status"
          "$package"
          "$haskell"
          "$python"
          "$rust"
          "$java"
          "$nix_shell"
          "$line_break"
          "$jobs"
          "$cmd_duration"
          "$character"
        ];
      };
    };

    # Atuin configuration
    programs.atuin = lib.mkIf cfg.tools.atuin.enable {
      enable = true;
      settings = {
        auto_sync = false;
        enter_accept = false;
        filter_mode_shell_up_key_binding = "directory";
        history_format = "{time} - {duration} - {command} - {directory}";
        keymap_mode = "vim-normal";
        secrets_filter = true;
      };
    };

    # Atuin integration with zsh-vi-mode

    # Btop configuration
    xdg.configFile."btop/btop.conf" = lib.mkIf cfg.tools.btop.enable {
      text = let
        mkValueString = v:
          with builtins; let
            err = t: v:
              abort
              ("generators.mkBtopKV: "
                + "${t} not supported: ${toPretty {} v}");
          in
            if isInt v
            then toString v
            else if lib.isDerivation v
            then toString v
            else if isString v
            then ''"${v}"''
            else if v
            then "True"
            else if !v
            then "False"
            else if null == v
            then err "null" v
            else if isList v
            then ''"${toString v}"''
            else if isAttrs v
            then err "attrsets" v
            else if isFunction v
            then err "functions" v
            else if isFloat v
            then lib.strings.floatToString v
            else err "this value is" (toString v);
        mkKeyValue = lib.generators.mkKeyValueDefault {inherit mkValueString;} "=";
      in
        lib.generators.toKeyValue {inherit mkKeyValue;} {
          color_theme = "Default";
          theme_background = true;
          force_tty = false;
          presets = "cpu:-6:default,proc:0:default cpu:0:default,mem:0:default,net:0:default cpu:0:block,net:0:tty";
          vim_keys = true;
          rounded_corners = true;
          graph_symbol = "braille";
          graph_symbol_cpu = "default";
          graph_symbol_mem = "default";
          graph_symbol_net = "default";
          graph_symbol_proc = "default";
          shown_boxes = "cpu mem net proc";
          update_ms = 1000;
          proc_sorting = "cpu lazy";
          proc_reversed = false;
          proc_tree = false;
          proc_colors = true;
          proc_gradient = true;
          proc_per_core = true;
          proc_mem_bytes = true;
          proc_info_smaps = false;
          proc_left = false;
          cpu_graph_upper = "total";
          cpu_graph_lower = "total";
          cpu_invert_lower = true;
          cpu_single_graph = false;
          cpu_bottom = false;
          show_uptime = true;
          check_temp = true;
          cpu_sensor = "Auto";
          show_coretemp = true;
          cpu_core_map = "";
          temp_scale = "celsius";
          show_cpu_freq = true;
          clock_format = "%X";
          background_update = true;
          custom_cpu_name = "";
          disks_filter = "/ /nix /nix/state /nix/store /mnt/emp /mnt/movies /mnt/music /mnt/redacted /mnt/shows";
          mem_graphs = false;
          mem_below_net = false;
          show_swap = true;
          swap_disk = true;
          show_disks = true;
          only_physical = false;
          use_fstab = false;
          show_io_stat = true;
          io_mode = false;
          io_graph_combined = false;
          io_graph_speeds = "";
          net_download = 1024;
          net_upload = 1024;
          net_auto = false;
          net_sync = false;
          net_iface = "";
          show_battery = true;
          selected_battery = "Auto";
          log_level = "WARNING";
        };
    };

    # Htop configuration
    programs.htop = lib.mkIf cfg.tools.htop.enable {
      enable = true;
      settings =
        {
          delay = 10;
          show_program_path = false;
          show_cpu_frequency = true;
          show_cpu_temperature = true;
          hide_kernel_threads = true;
        }
        // (with config.lib.htop;
          leftMeters [
            (bar "AllCPUs2")
            (bar "Memory")
            (bar "Swap")
          ])
        // (with config.lib.htop;
          rightMeters [
            (text "Hostname")
            (text "Tasks")
            (text "LoadAverage")
            (text "Uptime")
            (text "Systemd")
          ]);
    };

    # Bat configuration
    programs.bat = lib.mkIf cfg.tools.bat.enable {
      enable = true;
      extraPackages = with pkgs.bat-extras; [batman];
    };

    # Zoxide configuration
    programs.zoxide.enable = lib.mkIf cfg.tools.zoxide.enable true;

    # Nix-index configuration
    programs.nix-index.enable = true;

    # Stylix user-level theming
    stylix = lib.mkIf cfg.stylix.enable {
      enable = true;
      base16Scheme =
        if cfg.stylix.base16Scheme != null
        then cfg.stylix.base16Scheme
        else lib.mkDefault defaultScheme;
      image = lib.mkIf (cfg.stylix.image != null) cfg.stylix.image;
      targets = {
        gnome.enable = pkgs.stdenv.isLinux;
        gtk.enable = pkgs.stdenv.isLinux;
        kde.enable = lib.mkDefault false;
        xfce.enable = lib.mkDefault false;
        nixvim.plugin = "base16-nvim";
      };
    };

    # Systemd user services
    systemd.user.startServices = lib.mkIf pkgs.stdenv.isLinux "sd-switch";

    # Manually disabled dconf (enabled in graphical module)
    dconf.enable = lib.mkDefault false;
  };
}
