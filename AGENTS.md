# AGENTS.md

## Architecture

NixOS flake built with **flake-parts**. The top-level `flake.nix` only declares inputs and calls `mkFlake`; real wiring lives in `flake/` and `hosts/<name>/flake.nix`. `flake/default.nix` imports every flake-parts module and host — that file is the source of truth for which hosts exist.

- `flake/` — flake-parts modules: `variables.nix` (shared vars), `lib.nix` (extends `nixpkgs.lib` with `relativeToRoot`), `formatter.nix` (treefmt), `shell.nix` (devShell)
- `hosts/` — per-host configs; each has its own `flake.nix` defining `flake.nixosConfigurations.<name>`, plus `configuration.nix`, `imports.nix` (system modules). The `nixos` host also has `hm-imports.nix` (home-manager modules) and `hardware-custom.nix`.
- `modules/` — NixOS system-level modules grouped by category (`gaming/`, `packages/`, `programs/`, `security/`, `server/`, `system/`, `theme/`)
- `hm-modules/` — Home Manager user-level modules (`desktop/`, `misc/`, `options/`, `programs/`, `scripts/`, `theme/`)
- `overlays/` — nixpkgs overlays (unfree enabled; custom package overrides; exposes `pkgs.stable`)
- `secrets/` — sops-nix encrypted `secrets.yaml`

## Variable / specialArgs flow

`flake/variables.nix` defines `config.flake.variables` (username, default apps, fonts, wallpaper). Each host's `flake.nix` spreads these into `nixosSystem` `specialArgs`:

- NixOS modules destructure individual vars by name (`{ username, browser, terminal, ... }:`) and also receive `flakeVars` (full attrset), `inputs`, `self`, `config.flake.lib`.
- Home Manager modules receive `flakeVars // { inherit inputs; }` via `extraSpecialArgs` (set in `modules/system/home-manager.nix`).

When editing a module, take the var you need from the function args — don't redeclare it.

## Hosts

| Host | nixpkgs | Home Manager | Notes |
|------|---------|-------------|-------|
| nixos | unstable | yes | desktop, full module set, NVIDIA + ASUS laptop hardware |
| vps | **stable** (FlakeHub) | no | disko disk config, server services |
| liveiso | unstable | no | graphical ISO (Plasma + Calamares) |
| liveiso-minimal | unstable | no | minimal ISO |

Build: `nix build .#nixosConfigurations.<host>.config.system.build.toplevel`
ISOs: `just iso-normal` / `just iso-minimal` (or `build-iso.yml` workflow_dispatch)

## Commands

- `nix fmt` — format everything (treefmt: nixfmt, deadnix, statix, shfmt, keep-sorted)
- `just code` — lint (`statix check; deadnix`; semicolon means deadnix runs even if statix fails — exit code is deadnix's)

No pre-commit hooks are configured.

## Secrets

sops-nix + age; key rules in `.sops.yaml` (one user key, one host key for `nixos`).

- System: `modules/system/sops-nix.nix`, age key at `/var/lib/sops-nix/keys.txt`
- Home-manager: `hm-modules/misc/sops-nix.nix`, age key at `~/.config/sops/age/keys.txt`

## Overlays

Applied in `modules/system/nix.nix` via `nixpkgs.overlays = import ../../overlays { inherit inputs; }`.

## Gotchas

- `result` and `result-*` are gitignored — don't commit the build symlink.
- `flake.lock` is marked `linguist-generated` (diffs collapse on GitHub).
- `statix.toml` disables the `repeated_keys` check.
- Running `nix build` / `nix fmt` auto-rewrites `flake.lock` when `flake.nix` inputs differ from the lock (e.g. an input removed from `flake.nix` but still in the lock). Check `git diff flake.lock` after nix commands.
