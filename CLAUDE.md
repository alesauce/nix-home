# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build and Dev Commands

```bash
# Enter dev shell (installs pre-commit hooks)
nix develop

# Check the flake builds without activating
nix flake check

# Build a specific host config
nix build .#nixosConfigurations.sanderson.config.system.build.toplevel
nix build .#darwinConfigurations.vonnegut.system

# Format all files (alejandra for nix, prettier, shfmt)
nix fmt

# Run linters manually (also run as pre-commit hooks)
nix run .#checks.$(nix eval --impure --expr builtins.currentSystem --raw).pre-commit
```

Pre-commit hooks enforce: `deadnix`, `statix`, `nil` (LSP lint), `treefmt`, `shellcheck`, `actionlint`.

## Architecture

This is a **flake-parts + import-tree** ("dendritic pattern") Nix configuration. The entire `modules/` directory is auto-imported via `import-tree` — **no manual import lists anywhere**. Every `.nix` file in `modules/` is automatically part of the flake.

### How modules contribute config

Modules use `flake-parts` option namespaces. The key namespaces:

| Namespace                        | Purpose                                      |
| -------------------------------- | -------------------------------------------- |
| `flake.modules.nixos.base`       | Aggregated into every NixOS host             |
| `flake.modules.darwin.base`      | Aggregated into every Darwin host            |
| `flake.modules.homeManager.base` | Aggregated into home-manager user config     |
| `flake.nixosModules.<name>`      | Named NixOS modules (opt-in per host)        |
| `perSystem`                      | Per-architecture packages, devShells, checks |

Cross-cutting config (nix settings, nixpkgs instance, home-manager wiring) lives in `modules/nix/`, `modules/nixpkgs/`, and `modules/home-manager/`. Host-specific config lives in `modules/hosts/<hostname>/`.

### Key files

- `flake.nix` — minimal entry point; delegates everything to `modules/` via `import-tree`
- `modules/owner.nix` — single source of truth for `flake.meta.owner` (username, email, name); used by other modules via `config.flake.meta.owner`
- `modules/nixpkgs/instance.nix` — defines `perSystem.pkgs` (the nixpkgs instance); also wires `nixpkgs.pkgs`/`hostPlatform` into nixos/darwin base modules
- `modules/nix/settings.nix` — declares shared nix daemon options, then applies them to `flake.modules.{nixos,darwin,homeManager}.base`
- `modules/home-manager/base.nix` — HM user-scope config (`home.*`, `programs.home-manager.enable`); `homeDirectory` is platform-detected via `pkgs.stdenv.hostPlatform.isDarwin`
- `modules/home-manager/{nixos,darwin}.nix` — import HM NixOS/darwin modules and set system-scope `home-manager.*` options (`useGlobalPkgs`, `useUserPackages`, etc.)
- `modules/flake-parts/` — formatting (alejandra + prettier + shfmt via treefmt), pre-commit hooks, devShell, and system list

### Adding a new host

1. Create `modules/hosts/<hostname>/default.nix` defining `flake.nixosConfigurations.<hostname>` or `flake.darwinConfigurations.<hostname>`
2. Import `config.flake.modules.nixos.base` (or `.darwin.base`) directly into the `modules` list — see `modules/hosts/sanderson/default.nix` / `modules/hosts/vonnegut/default.nix` for the real pattern
3. No registration needed — `import-tree` picks it up automatically

### Adding home-manager user config

Already wired for both hosts. `modules/home-manager/{nixos,darwin}.nix` set `home-manager.users.${username}.imports = [config.flake.modules.homeManager.base]` at the system level; a host's own `default.nix` adds further HM modules on top (see sanderson's `home-manager.users.${owner.username}.imports = [self.homeManagerModules.ghostty ...]` block).
