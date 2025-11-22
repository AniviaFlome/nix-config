{ inputs, ... }:
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
          "com.pot_app.pot"
          "com.stremio.Stremio"
          "com.rustdesk.RustDesk"
          "com.usebottles.bottles"
          "io.github.astralvixen.geforce-infinity"
          "io.github.giantpinkrobots.flatsweep"
          "io.github.giantpinkrobots.varia"
          "io.github.Soundux"
          "org.vinegarhq.Sober"
          "sh.fhs.ksre"
        ];
    overrides = {
      global = {
        Context = {
          filesystems = [ "xdg-run/discord-ipc-0" ];
          sockets = [
            "wayland"
            "!x11"
            "!fallback-x11"
          ];
        };
        Environment = {
          XCURSOR_PATH = "/run/host/user-share/icons:/run/host/share/icons";
        };
      };
      "com.usebottles.bottles".Context = {
        filesystems = [
          "xdg-data/Steam:rw"
          "/home/aniviaflome/Games:rw"
          "/mnt/hdd/Games:rw"
          "/mnt/hdd/Native:rw"
          "/mnt/hdd2/Games:rw"
        ];
      };
      "org.vinegarhq.Sober".Context = {
        devices = [ "input" ];
      };
    };
  };
}
