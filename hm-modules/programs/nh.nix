{
  username,
  ...
}:
{
  programs.nh = {
    enable = true;
    flake = "/home/${username}/nix-config";
  };
}
