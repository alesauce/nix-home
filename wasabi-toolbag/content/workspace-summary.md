# Workspace Summary: nix-home

**Last Updated**: 2025-11-19T17:48:25.237Z
**Workspace Type**: Nix-based System Configuration Repository

## Overview

This is a sophisticated personal Nix configuration repository that manages system configurations, home environments, and user settings across multiple machines using declarative Nix expressions. The repository uses modern Nix flakes with flake-parts for modular configuration management.

## Repository Purpose

Manages machine configurations for:
- **macOS systems** (via nix-darwin)
- **NixOS systems** (full system configuration)
- **Linux systems** (via home-manager only)

All configurations are declarative, version-controlled, and reproducible across multiple architectures (x86_64 and aarch64).

## Architecture Overview

### Hosts

Four named machines (named after famous authors):

- **hemingway**: aarch64-darwin (macOS Apple Silicon)
- **vonnegut**: x86_64-darwin (macOS Intel)
- **sanderson**: x86_64-linux (NixOS)
- **wiggin**: x86_64-linux (home-manager only)

### Directory Structure

```
.
├── core/           # Baseline configurations applicable to all machines
│                   # (aspell, darwin, nix settings, nixos)
├── graphical/      # Desktop environment configuration (Sway/i3, AeroSpace)
│                   # Includes wallpaper images
├── hardware/       # Hardware-specific configuration
├── hosts/          # Individual machine definitions (4 hosts)
├── nix/            # Nix build support (overlays, deployment, packages)
├── users/          # Per-user configurations (user: alesauce)
│   ├── core/       # Core tools: git, neovim, tmux, zsh, starship, atuin, btop, htop
│   ├── dev/        # Development tools (including Amazon-specific configs)
│   ├── graphical/  # User graphical environment settings
│   └── modules/    # Custom user modules
├── .github/        # CI/CD workflows (automated builds & flake updates)
└── wasabi-toolbag/ # Wasabi-specific tooling and documentation
```

## Languages & Technologies

### Primary Language: Nix

- **51+ .nix configuration files** across the repository
- Declarative system configuration language
- Handles all system, user, and application configuration

### Supporting Languages

- **Shell/Bash/ZSH**: Custom scripts and functions
  - Custom ZSH function: `fzd.sh` (fuzzy directory navigation using fd and fzf)
- **YAML**: GitHub Actions workflows, SOPS configuration, pre-commit hooks

## Build System

### Nix Flakes with flake-parts

- **No traditional compilation**: This is a configuration repository, not a software project
- **Build = Configuration Activation**: Nix evaluates and builds system configurations
- **Recent migration**: Moved to flake-parts for modular flake organization (15h ago)

### Deployment Methods

```bash
# macOS (nix-darwin)
darwin-rebuild --flake "github:alesauce/nix-home#hemingway" switch

# NixOS
nixos-rebuild --flake "github:alesauce/nix-home#sanderson" switch

# Home Manager only
home-manager --flake "github:alesauce/nix-home#wiggin" switch
```

### Build Validation Commands

```bash
# Validate flake structure
nix flake show

# Check all outputs
nix flake check

# Build specific host
nix build .#darwinConfigurations.hemingway.system
nix build .#nixosConfigurations.sanderson.config.system.build.toplevel

# Build development shell
nix build .#devShells.aarch64-darwin.default
```

## Dependencies

### Nix Flake Inputs

**Core Components:**
- `nixpkgs` (nixos-unstable) - Main package repository
- `flake-parts` - Modular flake organization framework
- `nur` - Nix User Repository

**System Management:**
- `darwin` (nix-darwin) - macOS system configuration
- `home-manager` - User environment management
- `nixvim-flake` (alesauce/nixvim-flake) - Personal Neovim configuration

**Development Tools:**
- `git-hooks` (cachix/git-hooks.nix) - Pre-commit hooks integration
- `nix-fast-build` (Mic92/nix-fast-build) - Faster CI builds
- `nix-index-database` - Command-not-found functionality

**Security:**
- `sops-nix` (Mic92/sops-nix) - Secrets management with SOPS/age encryption

**Theming:**
- `stylix` (danth/stylix) - System-wide theming framework
- `tinted-schemes` - Base16 color schemes

**All flake inputs follow nixpkgs** to ensure version consistency.

## Code Style & Formatting

### Automated Tooling

**Formatter:** alejandra (opinionated Nix formatter)
- Integrated via pre-commit hooks
- Runs automatically on git commit

**Linters:**
- `statix` - Nix static analysis (anti-patterns, style issues)
- `deadnix` - Dead code detection (unused bindings, lambda args)
- `nil` - Nix language server
- `actionlint` - GitHub Actions workflow validation

### Style Rules

- **Indentation**: 2 spaces (no tabs)
- **Line Length**: ~100 characters (soft limit, formatter-determined)
- **Trailing Commas**: Enforced by alejandra
- **Unused Code**: All lambda arguments and pattern names must be used
- **No Underscore Workarounds**: Even underscore-prefixed bindings must be used

### deadnix Configuration

```nix
noLambdaArg = true          # Report unused lambda arguments
noLambdaPatternNames = true # Report unused lambda pattern names
noUnderscore = true         # Report unused bindings even with underscore prefix
```

### Development Shell Tools

Available via `nix develop`:
- alejandra, statix, deadnix, nil, actionlint

## Testing Approach

### Build-Based Validation

This repository uses **declarative testing** rather than traditional unit tests:

- **"If it builds, it works"** - Nix's evaluation serves as type checking
- No unit test files or testing frameworks
- Configuration correctness validated through successful builds

### CI/CD Testing

**GitHub Actions Workflow** (`.github/workflows/ci.yaml`):

1. **Platform Matrix**: Builds across all target platforms
   - x86_64-linux (Ubuntu runners)
   - aarch64-linux (ARM Ubuntu runners)
   - x86_64-darwin (macOS Intel)
   - aarch64-darwin (macOS Apple Silicon)

2. **Build Targets**:
   - All host configurations (hemingway, vonnegut, sanderson, wiggin)
   - Development shells for each platform
   - Eval-only attributes for unsupported platforms

3. **CI Steps**:
   - `flake-show` - Validate flake structure
   - `get-attrs` - Discover all buildable attributes
   - `build` - Matrix job building each configuration
   - `check` - Aggregate results and verify success

4. **Optimizations**:
   - Uses `nix-fast-build` for efficient multi-target builds
   - `--skip-cached` flag avoids rebuilding
   - Parallel matrix builds
   - Retry logic (3 attempts) for transient failures

### Testing Commands

```bash
# Full flake validation
nix flake check

# Build all derivations (like CI does)
nix-fast-build --flake '.#darwinConfigurations.hemingway.system'

# Evaluate without building
nix eval .#nixosConfigurations.sanderson.config.system.build.toplevel

# Run pre-commit hooks manually
pre-commit run --all-files
```

## Custom Tools

### Existing Custom Tools

**None currently.** The workspace relies on standard Nix tooling.

### Why No Custom Tools?

The existing Nix ecosystem provides comprehensive tooling:
- Nix commands are well-designed with clear output
- Pre-commit hooks automate formatting and linting
- Direct command execution is more flexible than wrappers
- No complex parameter parsing or output transformation needed

### Recommended Commands for Wasabi

```bash
# Formatting
alejandra .                    # Format all Nix files

# Linting
statix check .                 # Check for anti-patterns
deadnix .                      # Find unused code

# Building
nix build .#<host>             # Build specific host
nix flake check                # Validate all outputs

# Development
nix develop                    # Enter dev shell with all tools
```

## Development Environment

### direnv Integration

- `.envrc` file present with Nix flake support
- Automatically loads development shell when entering directory
- File watchers configured for automatic shell reloads

### Pre-commit Hooks

Configured via `git-hooks` flake input:
- Runs alejandra formatter
- Runs statix and deadnix linters
- Validates GitHub Actions with actionlint
- Executes automatically on `git commit`

### Development Shell Contents

Available packages in `nix develop`:
- All formatting and linting tools
- Nix evaluation and build tools
- Language servers and IDE support

## Secrets Management

### SOPS Integration

- **Encrypted secrets**: `secrets.yaml` in repository root
- **Configuration**: `.sops.yaml` defines encryption keys
- **Keys configured**: age keys for user alesauce and host sanderson
- **Integration**: Via `sops-nix` flake input

## CI/CD

### Automated Workflows

**1. CI Workflow** (`.github/workflows/ci.yaml`):
- Triggers: Push to `main`, pull requests
- Builds all host configurations
- Tests dev shells for each platform
- Uses matrix strategy for parallel builds
- Caching via Cachix (nix-config.cachix.org, nix-community.cachix.org)

**2. Update Workflow** (`.github/workflows/update-flakes.yaml`):
- Automated flake input updates
- Keeps dependencies current

### Build Caches

- `nix-config.cachix.org` - Personal configuration cache
- `nix-community.cachix.org` - Community cache

## Key Features

1. **Multi-platform support**: Unified configuration for macOS and Linux
2. **Reproducible**: Flake lock ensures deterministic builds
3. **Encrypted secrets**: SOPS with age for secure configuration
4. **Automated formatting/linting**: Pre-commit hooks enforce style
5. **Comprehensive CI**: All configurations tested on every commit
6. **Modular design**: flake-parts enables clean organization
7. **Custom tooling**: Personal Neovim configuration via separate flake
8. **System theming**: Stylix for consistent visual appearance

## Amazon Integration

### Development Tools

- Amazon-specific configurations in `users/alesauce/dev/amzn.nix`
- **No Brazil/Peru**: This is a personal configuration repo, not an Amazon package
- **No AWS SDK**: No application code requiring AWS services

## Logging & Metrics

**Not applicable.** This is a configuration repository without runtime application code.

### Simple Output Patterns

- Shell scripts use `echo` for user feedback
- Error messages: `echo "Error: message" >&2`
- CI uses `printf` for GitHub Actions summaries

### Configuration Logs

- Nix daemon log: `/var/log/nix-daemon.log` (macOS)
- btop log level: `WARNING` (levels: ERROR, WARNING, INFO, DEBUG)

## Notable Characteristics

- **Literary naming**: All hosts named after famous authors
- **Recent refactoring**: Migrated to flake-parts (15h ago)
- **Active maintenance**: Automated dependency updates via Dependabot
- **Clean structure**: Follows common Nix community conventions
- **Personal but professional**: Includes Amazon-specific dev configurations

## Usage Guidelines for Wasabi

### When Making Changes

1. **Always validate with**: `nix flake check`
2. **Format before committing**: Pre-commit hooks will run automatically
3. **Consider target platform**: Ensure changes are appropriate for the host's platform
4. **Use 2-space indentation**: Follow alejandra's formatting conventions
5. **Avoid unused code**: deadnix will catch unused bindings and lambda args

### Common Operations

```bash
# Check syntax and evaluate
nix flake check

# Build a specific host
nix build .#darwinConfigurations.hemingway.system

# Enter development shell
nix develop

# Format all Nix files
alejandra .

# Find unused code
deadnix .

# Check for anti-patterns
statix check .
```

### File Locations

- **Core system configs**: `core/`
- **Host-specific configs**: `hosts/<hostname>/`
- **User configs**: `users/alesauce/`
- **Overlays**: `nix/overlays/`
- **Development shell**: `nix/dev-shell.nix`

## References

- **Flake definition**: `flake.nix`
- **README**: `README.md`
- **CI configuration**: `.github/workflows/ci.yaml`
- **Pre-commit config**: Auto-generated by git-hooks.nix
- **SOPS config**: `.sops.yaml`

## Version Information

**Nix System**: nixos-unstable (follows latest)
**All flake inputs follow nixpkgs** for version consistency

---

**This summary is maintained for Wasabi's context.** It provides essential information about the workspace structure, conventions, and tooling to ensure consistent and appropriate code generation and assistance.
