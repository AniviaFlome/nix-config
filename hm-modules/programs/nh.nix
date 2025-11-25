{
  config,
  ...
}:
{
  programs.nh = {
    enable = true;
    flake = "${config.home.homeDirectory}/nix-config";
  };
}
