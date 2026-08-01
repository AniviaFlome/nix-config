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