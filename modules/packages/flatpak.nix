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
}

