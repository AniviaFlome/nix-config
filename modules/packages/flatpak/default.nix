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
    "com.heroicgameslauncher.hgl"
    "com.jeffser.Alpaca"
    "com.pokemmo.PokeMMO"
    "com.stremio.Stremio"
    "com.usebottles.bottles"
    "io.github.amit9838.mousam"
    "io.github.zen_browser.zen"
    "io.gitlab.librewolf-community"
    "io.github.antimicrox.antimicrox"
    "io.github.dvlv.boxbuddyrs"
    "io.github.giantpinkrobots.flatsweep"
    "io.github.thetumultuousunicornofdarkness.cpu-x"
    "net.davidotek.pupgui2"
    "org.libretro.RetroArch"
    "fr.romainvigier.MetadataCleaner"
    "io.github.giantpinkrobots.varia"
    "com.github.dynobo.normcap"
    "net.sapples.LiveCaptions"
    "org.nicotine_plus.Nicotine"
    ];
}
