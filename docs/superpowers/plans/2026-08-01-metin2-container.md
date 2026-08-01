# Metin2 NixOS Container (nested Weston) Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Run 1 Metin2 client inside a NixOS declarative container (`systemd-nspawn`) with nested Weston (X11 backend) routing through a SOCKS5 proxy, on the `nixos` host.

**Architecture:** One new module `modules/server/metin2.nix` defines `containers.metin2` unconditionally (no `options`). The container bind-mounts the host's X socket, DRM nodes, NVIDIA userspace libs (`/run/opengl-driver`), and PipeWire socket. Inside, Weston runs with its X11 backend (rendering as one X window on the host), Wine runs against Weston's Wayland under `proxychains-ng` for IP isolation, with a persistent Wine prefix at `/var/lib/wine-prefix` for stable HWID.

**Tech Stack:** NixOS flakes, `containers.<name>` (systemd-nspawn), `wineWow64Packages.staging`, `dxvk`, `weston`, `proxychains-ng`, `winetricks`, NVIDIA + PipeWire on host.

## Global Constraints

- No `options.services.metin2` interface — module hardcodes values inline.
- Target host: `nixos` only. Do not enable on `vps`/`liveiso`/`liveiso-minimal`.
- GPU is NVIDIA; use `/run/opengl-driver` bind-mount (not OCI toolkit).
- Display via Weston X11 backend against host `/tmp/.X11-unix/X0` (`DISPLAY=:0`).
- Audio via host PipeWire PulseAudio compat socket `/run/user/1000/pulse/native` (`PULSE_SERVER=unix:/run/user/1000/pulse/native`).
- Proxy is a plain `host:port` (SOCKS5); no sops auth.
- `autoStart = false`; `ephemeral = false`; `privateNetwork = false`.
- Repo conventions: 2-space indent, no comments unless asked, `nix fmt` + `just code` lint.
- Do NOT commit `result`/`result-*` (gitignored). Check `git diff flake.lock` after any `nix` command.
- Only commit when the user explicitly asks.

---

## File Structure

- **Create** `modules/server/metin2.nix` — the single module: `containers.metin2` definition + host-side `xhost` permission so the container can reach the X server.
- **Modify** `hosts/nixos/imports.nix` — add one import line under the `# Server` section.
- **No test files** — NixOS container modules have no unit test harness in this repo; verification is via build eval + manual smoke test (see Task 4).

---

### Task 1: Create the `modules/server/metin2.nix` module

**Files:**
- Create: `modules/server/metin2.nix`

**Interfaces:**
- Consumes: host `config` (read-only, for things like `config.services.xserver.displayManager.sessionCommands` if needed). Takes no specialArgs beyond what NixOS modules already receive.
- Produces: `containers.metin2` attribute on the host system; a launcher script inside the container at `/etc/metin2-launcher` (executable via `environment.etc."metin2-launcher"` with `executable = true`).

- [ ] **Step 1: Write the module file**

Create `modules/server/metin2.nix` with exactly this content:

```nix
{
  pkgs,
  ...
}:
{
  containers.metin2 = {
    autoStart = false;
    ephemeral = false;
    privateNetwork = false;

    bindMounts = {
      "/game" = {
        hostPath = "/opt/metin2";
        isReadOnly = true;
      };
      "/tmp/.X11-unix" = {
        hostPath = "/tmp/.X11-unix";
        isReadOnly = false;
      };
      "/dev/dri" = {
        hostPath = "/dev/dri";
        isReadOnly = false;
      };
      "/run/opengl-driver" = {
        hostPath = "/run/opengl-driver";
        isReadOnly = true;
      };
      "/run/user/1000" = {
        hostPath = "/run/user/1000";
        isReadOnly = false;
      };
    };

    config = { pkgs, ... }: {
      hardware.graphics.enable = true;

      environment.systemPackages = with pkgs; [
        weston
        wineWow64Packages.staging
        dxvk
        proxychains-ng
        winetricks
      ];

      environment.variables = {
        DISPLAY = ":0";
        WINEPREFIX = "/var/lib/wine-prefix";
        XDG_RUNTIME_DIR = "/run/user/0";
        PULSE_SERVER = "unix:/run/user/1000/pulse/native";
      };

      environment.etc."proxychains4.conf".text = ''
        strict_chain
        proxy_dns
        [ProxyList]
        socks5 203.0.113.12:1080
      '';

      environment.etc."metin2-launcher" = {
        mode = "0755";
        text = ''
          #!${pkgs.bash}/bin/bash
          set -euo pipefail

          mkdir -p "$XDG_RUNTIME_DIR"

          echo "[metin2] starting Weston (x11 backend)..."
          weston --backend=x11-backend.so --idle-time=0 &
          WESTON_PID=$!

          for i in $(seq 1 50); do
            if [ -S "$XDG_RUNTIME_DIR/wayland-0" ]; then
              break
            fi
            sleep 0.1
          done

          if [ ! -S "$XDG_RUNTIME_DIR/wayland-0" ]; then
            echo "[metin2] Weston did not create wayland-0; aborting." >&2
            kill "$WESTON_PID" 2>/dev/null || true
            exit 1
          fi

          export WAYLAND_DISPLAY=wayland-0

          echo "[metin2] starting Wine + proxychains..."
          exec proxychains4 -f /etc/proxychains4.conf wine /game/metin2.exe
        '';
      };

      system.activationScripts.wine-init = ''
        mkdir -p /var/lib/wine-prefix
      '';
    };
  };
}
```

Notes on the choices baked in above (do not write these into the file as comments — they're for the implementer):
- `/run/user/1000` is bind-mounted whole so the container can reach both `/run/user/1000/pulse/native` (PipeWire Pulse compat) and any future host runtime sockets without a mount per socket.
- `XDG_RUNTIME_DIR=/run/user/0` inside the container: Weston runs as root (nspawn default) and needs a writable runtime dir it owns. The launcher creates it.
- `environment.etc."proxychains4.conf"` overrides the default proxychains config path so `proxychains4 -f /etc/proxychains4.conf` works without extra args.
- `environment.etc."metin2-launcher"` with `mode = "0755"` produces an executable at `/etc/metin2-launcher` inside the container.

- [ ] **Step 2: Verify it parses (no build yet)**

Run: `nix-instantiate --parse modules/server/metin2.nix`
Expected: prints the AST, exit 0, no syntax errors.

- [ ] **Step 3: Commit**

```bash
git add modules/server/metin2.nix
git commit -m "feat(server): add metin2 NixOS container module"
```

---

### Task 2: Wire the module into the `nixos` host

**Files:**
- Modify: `hosts/nixos/imports.nix:31` (the `# Server` section)

**Interfaces:**
- Consumes: `modules/server/metin2.nix` from Task 1.
- Produces: `containers.metin2` present in the `nixos` eval.

- [ ] **Step 1: Add the import line**

In `hosts/nixos/imports.nix`, under the `# Server` comment block, add the metin2 line alongside the existing `syncthing.nix` import. The section currently reads:

```nix
    # Server
    ../../modules/server/syncthing.nix
```

Change it to:

```nix
    # Server
    ../../modules/server/metin2.nix
    ../../modules/server/syncthing.nix
```

(keep alphabetical order — `m` before `s`.)

- [ ] **Step 2: Verify the host flake still evaluates**

Run: `nix flake check --no-build .#`
Expected: exits 0 (or only pre-existing warnings). If it errors with something about `containers.metin2`, fix before continuing.

If `nix flake check` is too slow/heavy, run the targeted eval instead:
`nix-instantiate --eval -E '(builtins.getFlake (toString ./.)).nixosConfigurations.nixos.config.containers.metin2.config.system.build.toplevel.drvPath'`
Expected: prints a store path string, exit 0.

- [ ] **Step 3: Full build of the host toplevel**

Run: `nix build .#nixosConfigurations.nixos.config.system.build.toplevel --no-link`
Expected: builds successfully (may take a while — Wine + Weston pull a lot). Exit 0.

- [ ] **Step 4: Check flake.lock for accidental rewrites**

Run: `git diff flake.lock`
Expected: no changes (the module adds no new flake inputs). If changed, inspect — do NOT commit a rewritten lock unless the change is intentional.

- [ ] **Step 5: Lint**

Run: `nix fmt && just code`
Expected: `nix fmt` reformats if needed; `just code` runs `statix check; deadnix` and exits 0 (deadnix's exit code is what matters per the AGENTS.md note).

- [ ] **Step 6: Commit**

```bash
git add hosts/nixos/imports.nix
git commit -m "hosts(nixos): import metin2 container module"
```

(Also stage any reformatting `nix fmt` did to `modules/server/metin2.nix`.)

---

### Task 3: Grant the container access to the host X server

**Files:**
- Modify: `modules/server/metin2.nix` (add host-side `xhost` permission)

**Interfaces:**
- Consumes: nothing new.
- Produces: the container's root user can connect to host `:0`.

The container runs as root and connects to the host X server via the bind-mounted `/tmp/.X11-unix`. By default X拒绝 local root unless `xhost` allows it. Add a small host-side activation that permits the container's principal.

- [ ] **Step 1: Add the xhost permission to the module**

Edit `modules/server/metin2.nix`. The module's top-level function currently only sets `containers.metin2`. Add a host-side `system.activationScripts` entry next to it so the final file looks like:

```nix
{
  pkgs,
  ...
}:
{
  containers.metin2 = {
    # ... (unchanged) ...
  };

  system.activationScripts.metin2-xhost = ''
    if [ -e /tmp/.X11-unix/X0 ]; then
      ${pkgs.xorg.xhost}/bin/xhost +SI:localuser:root >/dev/null 2>&1 || true
    fi
  '';
}
```

Use `+SI:localuser:root` (the stricter, secure-interior form) rather than `xhost +local:`. The `|| true` keeps activation from failing on a headless build. The `if [ -e ... ]` guard avoids running xhost when X isn't up (e.g. during a non-graphical `nixos-rebuild build`).

- [ ] **Step 2: Rebuild eval**

Run: `nix-instantiate --eval -E '(builtins.getFlake (toString ./.)).nixosConfigurations.nixos.config.containers.metin2.config.system.build.toplevel.drvPath'`
Expected: prints a store path, exit 0.

- [ ] **Step 3: Lint**

Run: `nix fmt && just code`
Expected: exit 0.

- [ ] **Step 4: Commit**

```bash
git add modules/server/metin2.nix
git commit -m "feat(server/metin2): allow container root on host X server"
```

---

### Task 4: Manual smoke test

**Files:** none (verification only)

This task verifies the container actually works. It requires the user's real Metin2 client files and a real SOCKS5 proxy, so it's a manual step — the engineer doing this task should confirm with the user before running it on their machine, or skip and hand off to the user.

**Prerequisites (user must provide):**
- Metin2 client directory placed at `/opt/metin2` on the host (or change `hostPath` in the module to wherever it actually lives).
- The client's main executable is `metin2.exe` at the root of that directory (if it's named differently, update the launcher's `wine /game/metin2.exe` line).
- A reachable SOCKS5 proxy at the address in `environment.etc."proxychains4.conf"` (currently `203.0.113.12:1080` — a placeholder; user must edit to the real proxy).

- [ ] **Step 1: Apply the config to the running system**

Run: `sudo nixos-rebuild switch --flake .#nixos`
Expected: activates; `container-metin2.service` exists but is inactive (autoStart=false).

- [ ] **Step 2: Start the container**

Run: `sudo nixos-container start metin2`
Expected: container boots, `systemctl status container-metin2` shows active.

- [ ] **Step 3: Confirm Weston + Wine launch**

Run: `sudo nixos-container root-login metin2 -- /etc/metin2-launcher`
Expected:
- A Weston X window appears on the host screen.
- Terminal shows `[metin2] starting Weston...` then `[metin2] starting Wine + proxychains...`.
- Metin2 launcher/window appears inside the Weston window.
- If the proxy is unreachable, proxychains logs an error and Wine's network calls fail loudly (expected behavior — not a module bug).

- [ ] **Step 4: Confirm IP egress through the proxy**

With the client running, from inside the container in a separate shell:
`sudo nixos-container root-login metin2 -- bash -c "proxychains4 -f /etc/proxychains4.conf curl -s ifconfig.me"`
Expected: prints the proxy's IP, not the host's real public IP.

- [ ] **Step 5: Confirm HWID persistence**

Run: `sudo nixos-container stop metin2 && sudo nixos-container start metin2`
Then re-launch the client and confirm the server still recognizes it as the same machine (the Wine prefix at `/var/lib/wine-prefix` survives because `ephemeral=false`).

- [ ] **Step 6: No commit**

This task produces no code changes. If any fixes were needed during smoke test, commit those fixes with clear messages before finishing.

---

## Self-Review

**Spec coverage check:**
- "single hardcoded containers.metin2 (no options)" → Task 1 creates exactly this.
- "nested Weston X11 backend" → Task 1 launcher uses `weston --backend=x11-backend.so`.
- "Wine + proxychains, SOCKS5" → Task 1 installs both; `proxychains4 -f /etc/proxychains4.conf wine /game/metin2.exe` in launcher.
- "distinct HWID via /var/lib/wine-prefix, ephemeral=false" → Task 1 sets `WINEPREFIX` + `ephemeral=false` + activation script mkdirs the prefix.
- "GPU via /run/opengl-driver bind-mount, hardware.graphics.enable" → Task 1 bindMounts + container config.
- "Audio via PipeWire Pulse compat" → Task 1 bind-mounts `/run/user/1000` and sets `PULSE_SERVER=unix:/run/user/1000/pulse/native` (corrected from spec's `pipewire-socket` to the real Pulse compat socket).
- "manual start (autoStart=false)" → Task 1.
- "xhost permission on host" → Task 3.
- "wire into hosts/nixos/imports.nix" → Task 2.
- "build + lint verification" → Tasks 2 and 3.
- "smoke test" → Task 4.

**Placeholder scan:** The proxy IP `203.0.113.12:1080` and game path `/opt/metin2` are example values that the user must overwrite — these are flagged in Task 4's Prerequisites, not hidden TODOs. No TBD/TODO/"implement later" in code steps.

**Type/name consistency:** `containers.metin2` used consistently. Launcher path `/etc/metin2-launcher` consistent across Task 1 and Task 4. `WINEPREFIX=/var/lib/wine-prefix` consistent. `XDG_RUNTIME_DIR=/run/user/0` consistent.

**Corrections made during review:**
- Spec said bind-mount `/run/user/1000/pipewire-socket`; real host has PipeWire Pulse compat at `/run/user/1000/pulse/native`. Plan bind-mounts the whole `/run/user/1000` dir and points `PULSE_SERVER` at the correct socket.
- Added Task 3 (xhost) which the spec mentioned only briefly; promoted to its own task because it's a distinct testable unit (container can't display without it).