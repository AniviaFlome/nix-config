{
  config,
  inputs,
  username,
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
      [
        "com.github.tchx84.Flatseal"
        "com.pokemmo.PokeMMO"
        "com.pot_app.pot"
        "com.rustdesk.RustDesk"
        "com.stremio.Stremio"
        "io.github.giantpinkrobots.flatsweep"
        "io.github.Soundux"
        "org.vinegarhq.Sober"
        "sh.fhs.ksre"
      ]
      |> map (id: {
        appId = id;
        origin = "flathub";
      });
    overrides = {
      global = {
        Context = {
          filesystems = [
            "xdg-run/discord-ipc-0"
            "xdg-data/icons:ro"
            "xdg-data/themes:ro"
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
          "${config.users.users.${username}.home}/Games:rw"
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
