{
  # Nix helper
  programs.nh = {
    enable = true;
    flake = "/home/aniviaflome/nix-config";
    clean = {
      enable = true;
      dates = "weekly";
      extraArgs = "--keep 5 --keep-since 7d";
    };
  };
}
