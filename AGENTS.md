# AGENTS Guide
## Big Picture
- `nixos-config-user` is the reusable Home Manager/user-tooling flake consumed by other repos such as `nix-devbox`.
- It exports per-system overlays and a module tree, not a host-specific machine config.
- The repo is organized by concern: `modules/dev-lang`, `modules/dev-tools`, `modules/sys-tools`, plus shared home-manager defaults in `modules/home.nix`.

## Architecture (Read First)
- `flake.nix`: flake inputs and exports; exposes `overlays`, `nixosModules`, and `templates` for each system.
- `modules/default.nix`: top-level aggregator importing `home.nix`, `dev-lang`, `dev-tools`, `sys-tools`.
- `modules/home.nix`: shared Home Manager defaults (`preferXdgDirectories`, `programs.home-manager.enable`, `systemd.user.startServices = "sd-switch"`).
- `overlays/default.nix`: composes package overlays (`allow-unfree`, JetBrains, `git-libsecret`).
- `templates/`: starter configs for consumers rather than repo-internal implementation.

## Composition and Data Flow
- Consumers usually import `nixosModules.<system>` from this flake, then layer local overrides on top.
- `modules/default.nix` fans out into category aggregators; category `default.nix` files are the place to register new submodules.
- `sys-tools/default.nix` adds common packages and links the `modules/sys-tools/scripts/` tree into `home.file.scripts`.
- Overlays are exported separately from modules; package customization and module behavior are intentionally split.

## Critical Workflows
- Use Make targets instead of raw commands: `make show`, `make flake-check`, `make build`, `make switch`, `make setup`.
- `make build` / `make switch` call `home-manager ... --flake .#x86_64-linux` by default; override with `SYSTEM=...` if needed.
- `make repl` and `make develop` are thin wrappers over `nix repl` / `nix develop` with flakes enabled.
- `make setup` bootstraps `~/.config/home-manager`, `~/.local/state/nix/profiles`, and `~/.vimrc` symlinks.

## Project-Specific Conventions
- Add new language/tool areas through aggregator files like `modules/dev-lang/default.nix` or `modules/dev-tools/default.nix`.
- Keep shared Home Manager behavior in `modules/home.nix`; keep tool-specific settings in category submodules.
- Package overlays belong under `overlays/`, not mixed into modules.
- `sys-tools/default.nix` shows the pattern for global packages plus repo-managed script linking.
- README coverage is sparse; prefer reading module aggregators to understand what is actually enabled.

## Integrations and Boundaries
- Key dependencies: `home-manager`, `nixpkgs`, `nixpkgs-ruby`, `nix-jetbrains-plugins`, and `system-manager` (tool availability only, not for building configs here).
- This repo is designed to be imported by downstream flakes; avoid hard-coding machine identity or host paths here.
- JetBrains and unfree-package policy are handled through overlays, so changes there may affect many downstream consumers.

## Agent Change Rules
- Prefer small module additions in the appropriate category over expanding `flake.nix`.
- When adding a module, wire it into the nearest `default.nix` aggregator or it will stay unused.
- Preserve the separation between reusable upstream defaults here and machine-specific overrides in downstream repos like `nix-devbox`.
- If a downstream repo already overrides behavior, do not move that assumption upstream without checking for broader impact.

