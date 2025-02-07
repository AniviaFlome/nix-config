{ inputs, ... }:

{
  imports = [ inputs.nix-flatpak.nixosModules.nix-flatpak ];

  services.flatpak = {
    enable = true;
    uninstallUnmanaged = true;
    update.onActivation = false;
    remotes = [
      { name = "flathub"; location = "https://dl.flathub.org/repo/flathub.flatpakrepo"; }
    ];
    packages = map (id: { appId = id; origin = "flathub"; }) [
      "app.zen_browser.zen"
      "com.github.tchx84.Flatseal"
      "com.heroicgameslauncher.hgl"
      "com.pokemmo.PokeMMO"
      "io.github.giantpinkrobots.flatsweep"
      "com.stremio.Stremio"
      "com.rustdesk.RustDesk"
      "fr.romainvigier.MetadataCleaner"
      "io.github.giantpinkrobots.varia"
    ]
    ++ [ { flatpakref = "https://sober.vinegarhq.org/sober.flatpakref"; sha256 = "1pj8y1xhiwgbnhrr3yr3ybpfis9slrl73i0b1lc9q89vhip6ym2l"; } ];
  };
}

