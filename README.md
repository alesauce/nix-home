# My systems defined via Nix [![built with nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org)
My Nix configs for all my machines. This repo was particularly inspired by [lovesegfault's nix-config](https://github.com/lovesegfault/nix-config/tree/master), if you can't tell from the nearly identical structure and content :)

For the configurations' entry points see the individual [hosts], as well as [flake.nix]. For adding overlays see [overlays](#Adding-overlays).

## Structure

```
.
├── core         # Baseline configurations applicable to all machines
├── dev          # Developer tooling configuration
├── graphical    # Sway/i3 configuration for the desktop
├── hardware     # Hardware-specific configuration
├── hosts        # Machine definitions
├── nix          # Nix build support files (overlays, deployment code)
└── users        # Per-user configurations
```

## Usage

#### Darwin

For macOS hosts using `nix-darwin`:

```console 
$ darwin-rebuild --flake "github:alesauce/nix-home#hemingway" switch
```

#### Home Manager

For non-NixOS hosts (i.e. home-manager-only systems such as `wiggin`):

```console
$ home-manager --flake "github:alesauce/nix-home#myHost" switch
```

### Adding overlays

Overlays should be added as individual nix files to ./nix/overlays with format

```nix
final: prev: {
    hello = (prev.hello.overrideAttrs (oldAttrs: { doCheck = false; }));
}
```

For more examples see [./nix/overlays][overlays].
