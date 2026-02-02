{
  inputs,
  ...
}:
{
  imports = [ inputs.nix-flatpak.nixosModules.nix-flatpak ];

  services.flatpak = {
    enable = true;
    uninstallUnmanaged = true;
    update = {
      onActivation = true;
      auto = {
        enable = true;
        onCalendar = "weekly";
      };
    };
    remotes = [
      {
        name = "flathub";
        location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      }
    ];
    packages =
      map
        (id: {
          appId = id;
          origin = "flathub";
        })
        [
          "com.github.tchx84.Flatseal"
          "com.pokemmo.PokeMMO"
          "com.stremio.Stremio"
          "com.rustdesk.RustDesk"
          "com.usebottles.bottles"
          "io.github.chidiwilliams.Buzz"
          "io.github.giantpinkrobots.flatsweep"
          "io.github.giantpinkrobots.varia"
          "io.github.Soundux"
          "org.vinegarhq.Sober"
          "sh.fhs.ksre"
          "tw.ddnet.ddnet"
        ]
      ++ [
        (
          let
            sha256 = "1v153k3vns64axybkd08r63jrcj8csqks5777bncyw1rpn6rflpn";
          in
          {
            appId = "com.hypixel.HytaleLauncher";
            inherit sha256;
            bundle = builtins.fetchurl {
              url = "https://launcher.hytale.com/builds/release/linux/amd64/hytale-launcher-latest.flatpak";
              inherit sha256;
            };
          }
        )
      ];
    overrides = {
      global = {
        Context = {
          filesystems = [
            "xdg-run/discord-ipc-0"
            "xdg-data/themes:ro"
            "xdg-data/icons:ro"
            "$HOME/.local/share/fonts:ro"
            "/run/current-system/sw/share/themes:ro"
            "/run/current-system/sw/share/icons:ro"
            "/nix/store:ro"
          ];
          sockets = [
            "wayland"
            "!x11"
            "!fallback-x11"
          ];
        };
        Environment = {
          GTK_THEME = "catppuccin-mocha-mauve-standard";
          XCURSOR_PATH = "/run/host/user-share/icons:/run/host/share/icons";
        };
      };
      "com.usebottles.bottles".Context = {
        filesystems = [
          "xdg-data/Steam:rw"
          "/home/aniviaflome/Games:rw"
          "/mnt/windows/Games:rw"
        ];
      };
      "org.vinegarhq.Sober".Context = {
        devices = [
          "input"
        ];
      };
    };
  };
}
