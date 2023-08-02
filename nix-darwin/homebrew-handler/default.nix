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
      # uncomment to add tiling window manager
      #"amethyst"
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
