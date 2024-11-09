{
  # Nix-flatpak
  services.flatpak = {
    enable = true;
    uninstallUnmanaged = true;
    update.onActivation = false;
  };

  services.flatpak.remotes = [{
    name = "flathub"; location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
  }];

  services.flatpak.packages = [
    { appId = "com.adamcake.Bolt"; origin = "flathub";  }
"com.adamcake.Bolt"
"com.github.tchx84.Flatseal"
"com.jeffser.Alpaca"
"com.pokemmo.PokeMMO"
"io.github.zen_browser.zen"
"io.github.giantpinkrobots.flatsweep"
"com.stremio.Stremio"
"dev.goats.xivlauncher"
"com.rustdesk.RustDesk"
"fr.romainvigier.MetadataCleaner"
  ];

  services.flatpak.overrides = {
    global = {
      Context.sockets = ["wayland" "!x11" "!fallback-x11"]; # Force Wayland by default
      Environment = {
        XCURSOR_PATH = "/run/host/user-share/icons:/run/host/share/icons"; # Fix un-themed cursor in some Wayland apps
        GTK_THEME = "catppuccin-mocha-mauve-standard"; # Force correct theme for some GTK apps
      };
    };
  };
}

