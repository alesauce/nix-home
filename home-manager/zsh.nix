{ ... }:

{
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      ll = "ls -l";
      ".." = "cd ..";
      sz = "source ~/.zshrc";

      # git aliases
      ga = "git add";
      gaa = "git add -A";
      gd = "git diff";
      gs = "git status";
      gr = "git restore";
      gl = "git log";
      gc = "git commit";
      gcm = "git commit -m";
      gps = "git push";
      gpl = "git pull";
      gch = "git checkout";
      gcb = "git checkout -b";
      gb = "git branch";

      # tmux aliases
      tk = "tmux kill-session";
      tka = "tmux kill-server";
      tkt = "tmux kill-session -t";
      tls = "tmux ls";
      tn = "tmux new";
      ta = "tmux attach -t";

      # nix/darwin aliases
      # TODO: modify darwin command to rebuild from github flake and not just locally
      dr = "darwin-rebuild switch --flake ~/.config/nix-darwin";
      dpr = "git -C  ~/.config/nix-darwin pull && darwin-rebuild switch --flake ~/.config/nix-darwin";
      drb = "darwin-rebuild --rollback";
      ngc = "nix store gc";
    };
    initExtra = ''
      NEW_USER="''${(C)USERNAME}"
      if [ -e ~/$NEW_USER-config ]; then
        source ~/$NEW_USER-config/entry-point
      fi

      # Rust toolchain path (until I figure out a better way to use Nix)
      export PATH="$PATH:$HOME/.cargo/:$HOME/.cargo/bin:$HOME/.rustup"
    '';
  };
}
