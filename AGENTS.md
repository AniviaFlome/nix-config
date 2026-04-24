# AGENTS.md

## Architecture

NixOS flake configuration using **flake-parts**. Each host defines its own `flake.nix` inside its directory under `hosts/`.

- `flake/` — flake-parts modules (variables, lib, formatter, shells)
- `hosts/` — per-host configs: **nixos** (desktop), **vps**, **liveiso**, **liveiso-minimal**
- `modules/` — NixOS system-level modules
- `hm-modules/` — Home Manager user-level modules
- `overlays/` — nixpkgs overlays (unfree enabled, custom package overrides)
- `secrets/` — sops-nix encrypted secrets

Shared config lives in `flake/variables.nix` (username, default apps, fonts). Access it via `config.flake.variables` in flake-parts context or `specialArgs` in module configs.

## Hosts

| Host | nixpkgs | Home Manager | Notes |
|------|---------|-------------|-------|
| nixos | unstable | yes | desktop, full module set |
| vps | stable | no | uses disko for disk config |
| liveiso | unstable | no | ISO image build |
| liveiso-minimal | unstable | no | minimal ISO |

## Commands

```bash
just code          # lint: statix check + deadnix
just check         # nix flake check
just rekey         # re-encrypt sops secrets after key changes
just iso-normal    # build liveiso
just iso-minimal   # build liveiso-minimal
```

Build the desktop host: `nix build .#nixosConfigurations.nixos.config.system.build.toplevel`

## Conventions

- **Formatter** is treefmt-nix (`nix fmt`). Runs nixfmt, deadnix, statix, and shfmt.
- **statix**: `repeated_keys` rule is disabled (`statix.toml`).
- **Overlays**: unfree packages are allowed globally. Several inputs provide overlays (niri, firefox-addons, nur, nix-cachyos-kernel, nix-repository, llm-agents).
- `pkgs-millennium` overlay pulls `steam-millennium` from a nixpkgs PR branch (`nixpkgs-millennium` input) — don't replace this with a normal nixpkgs reference.
- **Secrets** use sops-nix with age keys. Key paths configured in `.sops.yaml`. Run `just rekey` after changing encryption keys.
- VPS uses `nixpkgs-stable` (not unstable like other hosts).
