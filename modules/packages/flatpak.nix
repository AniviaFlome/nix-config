{ pkgs, config, inputs, ... }:

{
  imports = [ inputs.nix-flatpak.nixosModules.nix-flatpak ];

  services.flatpak = {
    enable = true;
    uninstallUnmanaged = true;
    update.onActivation = true;
    remotes = [
      { name = "flathub"; location = "https://dl.flathub.org/repo/flathub.flatpakrepo"; }
    ];
    packages = map (id: { appId = id; origin = "flathub"; }) [
      "com.github.tchx84.Flatseal"
      "com.heroicgameslauncher.hgl"
      "com.usebottles.bottles"
      "com.pokemmo.PokeMMO"
      "com.pot_app.pot"
      "com.stremio.Stremio"
      "com.rustdesk.RustDesk"
      "io.github.giantpinkrobots.flatsweep"
      "io.github.giantpinkrobots.varia"
      "org.vinegarhq.Sober"
    ];
    overrides = {
      global = {
        Context.sockets = ["wayland" "!x11" "!fallback-x11"];
        Environment = {
          XCURSOR_PATH = "/run/host/user-share/icons:/run/host/share/icons";
          GTK_THEME = "Adwaita:dark";
        };
      };
      "com.usebottles.bottles".Context = {
        filesystems = [
          "xdg-data/Steam:ro"
          "/mnt/hdd/Games:ro"
          "/mnt/hdd/Native:ro"
          "/mnt/hdd2/Games:ro"
        ];
      };
    };
  };
}

