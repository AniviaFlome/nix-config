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
      {
        name = "cordial";
        location = "https://luohoa97.github.io/cordial/cordial.flatpakrepo";
      }
    ];
    packages =
      (
        [
          # keep-sorted start case=no
          "com.github.tchx84.Flatseal"
          "com.pokemmo.PokeMMO"
          "com.pot_app.pot"
          "com.rustdesk.RustDesk"
          "com.stremio.Stremio"
          "io.github.giantpinkrobots.flatsweep"
          "io.github.Soundux"
          "io.github.tanaybhomia.Whisp"
          "org.vinegarhq.Sober"
          "sh.fhs.ksre"
          "space.bigrat.mocktail"
          # keep-sorted end
        ]
        |> map (id: {
          appId = id;
          origin = "flathub";
        })
      )
      ++ [
        {
          appId = "io.github.luohoa97.Cordial";
          origin = "cordial";
        }
      ];
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
