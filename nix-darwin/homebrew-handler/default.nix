{ ... }:

{
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
    };
    brews = [
      "openapi-generator"
    ];
    casks = [
      "alacritty"
      "amethyst"
      "arc"
      "brave-browser"
      "discord"
      "karabiner-elements"
      "obsidian"
      "raycast"
      "spotify"
      "todoist"
    ];
  };
}
