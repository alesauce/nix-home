{ ... }:

{
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
    };
    casks = [
      "alacritty"
      "arc"
      "brave-browser"
      "discord"
      "karabiner-elements"
      "obsidian"
      "raycast"
      "spotify"
      "todoist"
    ];
    taps = [ "homebrew/cask" ];
  };
}
