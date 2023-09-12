{ ... }:

{
  programs.nixvim = {
    # TODO: review docs and configure harpoon: https://github.com/ThePrimeagen/harpoon
    # nixvim docs: https://nix-community.github.io/nixvim/#_plugins_harpoon_enable
    plugins.harpoon = {
      enable = true;
    };
  };
}
