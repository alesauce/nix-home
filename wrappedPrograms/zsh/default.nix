{inputs, ...}: let
  zshModule = {pkgs, ...}: {
    config = {
      extraPackages = with pkgs; [
        bat
        bat-extras.batman
        eza
        fd
        fzf
        zoxide
      ];

      zshAliases = {
        cat = "bat";
        ls = "eza --icons --classify --binary --header --long";
        man = "batman";
        ssh = "TERM=xterm-256color ssh";
      };

      zshenv.content = ''
        export LESSHISTFILE="''${XDG_DATA_HOME:-$HOME/.local/share}/less_history"
        export CARGO_HOME="''${XDG_CACHE_HOME:-$HOME/.cache}/cargo"
        export RPROMPT=""
      '';

      zshrc.content = ''
        HISTFILE="''${XDG_DATA_HOME:-$HOME/.local/share}/zsh/history"
        HISTSIZE=10000
        SAVEHIST=10000
        setopt EXTENDED_HISTORY
        setopt HIST_EXPIRE_DUPS_FIRST
        setopt HIST_IGNORE_DUPS
        setopt HIST_IGNORE_SPACE
        setopt SHARE_HISTORY
        setopt AUTO_CD

        autoload -Uz compinit && compinit

        source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
        source ${pkgs.zsh-fast-syntax-highlighting}/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
        source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
        source ${pkgs.zsh-autopair.src}/zsh-autopair.plugin.zsh

        eval "$(${pkgs.zoxide}/bin/zoxide init zsh)"

        fpath=(${./functions} $fpath)
        autoload -Uz fzd
      '';
    };
  };
in {
  flake.modules.programs.zsh.main = zshModule;

  perSystem = {pkgs, ...}: {
    packages.zsh = inputs.wrapper-modules.wrappers.zsh.wrap {
      inherit pkgs;
      imports = [zshModule];
    };
  };
}
