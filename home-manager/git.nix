{ ... }:

{
  programs.git = {
    enable = true;
    delta = {
      enable = true;
      decorations = {
        commit-decoration-style = "bold yellow box ul";
        file-decoration-style = "none";
        file-style = "bold yellow ul";
      };
      features = "decorations";
      whitespace-error-style = "22 reverse";
    };
    diff-so-fancy.enable = true;
    aliases = {
      co = "checkout";
      cob = "git checkout -b";
      br = "git branch";
      sw = "switch";
    };
    ignores = [
      ".env"
      ".vscode"
      "pyrightconfig.json"
    ];
  };
}
