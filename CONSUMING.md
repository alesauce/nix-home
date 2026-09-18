# Consuming this flake

Entry point is `flake.nix` — it does almost nothing itself. Everything under `modules/` and
`wrappedPrograms/` is auto-imported via `import-tree` (dendritic pattern), so there's no
central registry to search; read the directory listing directly.

## Wrapped-program packages

Each `wrappedPrograms/<name>.nix` exports `flake.modules.programs.<name>` — a
[nix-wrapper-modules](https://github.com/BirdeeHub/nix-wrapper-modules) module — and builds
`packages.<system>.<name>` from it locally. Three ways to consume one downstream:

**A. Compose the module into your own `.wrap` call** — full module-system power
(`mkDefault`/`mkForce`, compose with other modules):

```nix
packages.git = inputs.wrapper-modules.wrappers.git.wrap {
  inherit pkgs;
  imports = [inputs.nix-home.modules.programs.git];
  userEmail = "you@example.com";
};
```

**B. `.extendModules` on the pre-built package** — fewer inputs, same override power via
`lib.mkForce`:

```nix
packages.git = inputs.nix-home.packages.${system}.git.extendModules {
  modules = [{userEmail = lib.mkForce "you@example.com";}];
};
```

**C. Use `inputs.nix-home.packages.${system}.<name>` as-is** if the defaults already work.

Worked examples to read directly, in increasing complexity:

- `wrappedPrograms/htop.nix` — bare module, no options at all
- `wrappedPrograms/git.nix` — typed identity options (`userEmail`/`userName`/`githubUser`)
  layered over hardcoded opinionated config (delta, `editor = nvim`)
- `wrappedPrograms/claude-code.nix` — the full pattern: a custom option (`readOnlyPaths`), an
  overlay contributed to the shared `pkgs` instance, `allowUnfreePackages`, and opinionated
  settings baked in directly

**Trap**: the export path is `flake.modules.<class>.<name>` — exactly two levels, per
flake-parts' own `modules` extra (`lazyAttrsOf (lazyAttrsOf deferredModule)`). There is no
third `.main`/variant segment. `flake.modules.programs.git.main = gitModule;` looks reasonable
but actually makes the exported module's config contain a literal key `main`, and importing it
downstream fails with `The option 'main' does not exist`. All 10 `wrappedPrograms/*.nix` files
had exactly this bug until 2026-09-16 (PR #1805) — if you're reading an older commit or a fork
predating that, check for it before copying the pattern.

## Host base layers (`nixos.base` / `darwin.base` / `homeManager.base`)

`inputs.nix-home.modules.{nixos,darwin,homeManager}.base` — importable as ordinary
NixOS/nix-darwin/home-manager modules. Contributed across `modules/nixpkgs/instance.nix`,
`modules/home-manager/{base,nixos,darwin}.nix`, `modules/nix/settings.nix`, plus smaller
contributors (`modules/{aspell,fonts,sops,xdg,terminfo}.nix` — `rg -n
"flake.modules.(nixos|darwin|homeManager).base" modules/` for the current full list, it
changes).

**Not a clean slate** — verified empirically against a standalone downstream flake: `flake.meta.owner` / `flake.meta.theme` (`modules/owner.nix`, `modules/theme.nix`) — plain
flake-level values, not options a downstream import can override. If you need your own
identity or your own `pkgs`, don't import `base` wholesale; cherry-pick individual
contributing files instead.

## Named opt-in NixOS modules

`flake.nixosModules.<name>` — standalone, not aggregated into `base`, imported explicitly per
host. Current contributors: `modules/features/{niri,greetd}.nix`,
`modules/hosts/sanderson/{configuration,hardware}.nix` (host-specific, not generally
reusable). `rg -n "flake.nixosModules\." modules/` for the live list.

## Identity, theme, pkgs config

- `modules/owner.nix` — `flake.meta.owner` (email/name/username); also a real flake output,
  `nix eval .#meta.owner`
- `modules/theme.nix` — `flake.meta.theme` (family/flavor/palette/wallpaper); also `nix eval
.#meta.theme`
- `modules/nixpkgs/instance.nix` — the one shared `pkgs` instance every `perSystem`/nixos/darwin
  module gets; `overlays` and `allowUnfreePackages` are flake-parts options
  (`config.nixpkgs.overlays`, `config.nixpkgs.config.allowUnfreePackages`) any module in this
  flake can contribute to — read this file before assuming what's on or off by default.

## No generated option docs

`nixos-render-docs`-style option generation isn't wired up for this flake's custom modules
(tracked as a TODO, not built). Read the `options` block in the specific
`wrappedPrograms/*.nix` or `modules/*.nix` file directly — there's no other source of truth
for what's actually tunable.
