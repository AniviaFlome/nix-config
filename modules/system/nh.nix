{
  self,
  ...
}:
{
  programs.nh = {
    enable = true;
    flake = toString self;
    clean = {
      enable = true;
      dates = "weekly";
      extraArgs = "--keep 5 --keep-since 7d";
    };
  };
}
