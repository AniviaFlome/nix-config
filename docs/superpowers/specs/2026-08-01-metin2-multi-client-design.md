# Metin2 NixOS Container (nested Weston)

**Date:** 2026-08-01
**Status:** Approved design (revised — container only, no options)
**Target host:** `nixos` (NVIDIA laptop, Xorg + Hyprland/Plasma/Niri, PipeWire, user `aniviaflome`)

## Goal

Run 1 Metin2 private-server client inside a single NixOS declarative container
(`systemd-nspawn`) with **nested Weston** (X11 backend) for display isolation,
routed through a SOCKS5 proxy for a distinct public IP.

The host's own clients (if any) are handled outside Nix config — not in scope.
The module is a single hardcoded `containers.metin2` definition, no `options`.

## Constraints & assumptions

- No anticheat on the target server (confirmed by user). Wine is safe.
- IP limit is public-IP based; the container's traffic goes through one SOCKS5
  proxy via `proxychains-ng`.
- HWID check (if any) is satisfied by a dedicated Wine prefix inside the
  container.
- GPU: host NVIDIA (modesetting, `hardware.nvidia-container-toolkit` already
  enabled). For nspawn we bind-mount `/run/opengl-driver` rather than use the
  OCI toolkit.
- Display: host runs Xorg (XWayland available). Weston uses the **X11 backend**
  inside the container to render onto the host X server, avoiding
  NVIDIA-on-nested-Wayland fragility.
- Audio: host PipeWire; container connects via the PipeWire socket.
- Container starts manually (no autoStart).

## Architecture

```
HOST (nixos)
└── containers.metin2 (systemd-nspawn, privateNetwork=false, manual start)
    ├── Nested Weston (x11-backend) → renders as one X window on host
    └── Metin2: wine prefix + proxychains(proxy) → inside Weston
```

### IP isolation
Container shares the host network namespace (`privateNetwork = false`). Its
Wine traffic is forced through a SOCKS5 proxy via `proxychains-ng`
(LD_PRELOAD hook on Wine's socket calls). Proxy address is hardcoded in the
container's `/etc/proxychains4.conf`.

### HWID isolation
A dedicated Wine prefix at `/var/lib/wine-prefix` inside the container
(persistent via `ephemeral = false`) gives a distinct `MachineGuid`, volume
serials, etc. from any host-side Wine prefixes.

### Display isolation
The container runs nested Weston (`weston --backend=x11-backend.so`) which
presents as a single X window on the host. Inside the container, Wine sees only
Weston's Wayland (`WAYLAND_DISPLAY=wayland-0`) — a separate display stack,
input seat, and clipboard from the host.

## Module: `modules/server/metin2.nix`

A single file that defines `containers.metin2` directly (plus any host-side
support needed for the container to function — e.g. xhost permission). No
`options.services.metin2` interface. Values (proxy, game path) are hardcoded
inline; edit the file to change them.

Imported via `hosts/nixos/imports.nix` under the `# Server` section.

### Container definition

```nix
{ pkgs, ... }:
{
  containers.metin2 = {
    autoStart = false;          # manual: nixos-container start metin2
    ephemeral = false;          # keep Wine prefix → stable HWID
    privateNetwork = false;     # share host netns; proxy handles IP
    bindMounts = {
      "/game" = {
        hostPath = "/opt/metin2";  # hardcoded; edit to point at your client
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
      "/run/user/1000/pipewire-socket" = {
        hostPath = "/run/user/1000/pipewire-socket";
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
        PULSE_SERVER = "unix:/run/user/1000/pipewire-socket";
      };
      system.activationScripts.wine-init = ''
        mkdir -p /var/lib/wine-prefix
        cat > /etc/proxychains4.conf <<EOF
        strict_chain
        proxy_dns
        [ProxyList]
        socks5 203.0.113.12:1080
        EOF
      '';
      # Launcher script (see below)
    };
  };
}
```

### Launcher

A script inside the container (installed via
`environment.etc."metin2-launcher"` or a small package) that:

1. Starts Weston in the background:
   `weston --backend=x11-backend.so --idle-time=0 &`
2. Waits briefly for `wayland-0` to appear (short sleep loop on
   `$XDG_RUNTIME_DIR/wayland-0`). Exact runtime-dir handling (running Weston
   as a non-root user inside the container, or as root with an explicit
   `XDG_RUNTIME_DIR=/run/user/0`) is pinned down in the implementation plan.
3. Exports `WAYLAND_DISPLAY=wayland-0` and the Weston runtime dir.
4. Runs `proxychains4 -f /etc/proxychains4.conf wine /game/metin2.exe`.

If Weston fails to start, the launcher exits with a clear message rather than
running Wine without a display.

### Host-side support

- Allow the container to reach the host X server:
  `services.xserver.displayManager.sessionCommands` or a small systemd unit
  that runs `xhost +local:` (or the stricter `xhost +SI:localuser:root`).
  NixOS containers run as root by default, so `localuser:root` is the relevant
  principal.
- No Wine/DXVK installed on the host by this module — host clients are out of
  scope.

## Wiring into the flake

- Add `../../modules/server/metin2.nix` to `hosts/nixos/imports.nix` under the
  `# Server` section.
- No host-level enable file needed — the module is unconditional (always
  defines the container). If conditional enable is wanted later, wrap in
  `lib.mkIf` against a plain boolean; no `options` interface per the user's
  instruction.

## GPU access (NVIDIA)

- Host already has `hardware.nvidia` + `hardware.nvidia-container-toolkit`.
  The toolkit is for OCI containers; for nspawn we instead bind-mount
  `/run/opengl-driver`, which on NixOS+NVIDIA contains the userspace
  `libGL.so`, `libvulkan.so`, and `nvidia_*` libs.
- Container's `hardware.graphics.enable` sets `LD_LIBRARY_PATH` to find them.
- DXVK (installed in container) translates Metin2's DX9 → Vulkan, running
  against the NVIDIA Vulkan ICD via the bind-mounted libs.
- Weston's X11 backend composites using GLX on the host X server, which is
  already NVIDIA-accelerated — no separate GPU passthrough needed.

## Audio

- Host PipeWire exposes a socket at `/run/user/1000/pipewire-socket`.
- Bind-mounted into the container at the same path.
- `PULSE_SERVER=unix:/run/user/1000/pipewire-socket` makes Wine's PulseAudio
  backend reach the host PipeWire server (PipeWire's PulseAudio compatibility).
- Host user 1000 owns the socket; the container runs as root by default, which
  can access it. If Weston is run as a non-root user inside the container with a
  different UID, a chmod/chown on the bind-mounted socket may be required —
  handled in implementation.

## Error handling / robustness

- `proxychains-ng` fails loudly if the proxy is unreachable (connection
  refused). No silent fallback — preferable (better a client that won't start
  than one that leaks the real IP).
- Wine prefix init is idempotent (`wineboot --init` on an existing prefix is a
  no-op-ish refresh).
- Container is `ephemeral = false`, so `nixos-container restart metin2`
  preserves the Wine prefix and HWID.

## Testing / verification

- **Build:** `nix build .#nixosConfigurations.nixos.config.system.build.toplevel`
  (must evaluate; container config is part of the system eval).
- **Lint:** `nix fmt` then `just code` (statix + deadnix).
- **Container smoke test:**
  1. `nixos-container start metin2`
  2. `nixos-container root-login metin2 -- metin2-launcher`
  3. Confirm a Weston X window appears on the host screen.
  4. Confirm Metin2 launches inside it and connects through the proxy.
- **IP check:** the client should show the proxy's outbound IP (verify via an
  IP-echo site in the in-game browser or the server's online list).

## Out of scope

- Host-side clients (run manually outside Nix config if desired).
- Proxy credential management via sops (proxy is a plain `host:port`).
- macvlan/LAN-IP isolation (proxy-only per user choice).
- Auto-start of the container (manual per user choice).
- An `options` interface (hardcoded per user instruction).