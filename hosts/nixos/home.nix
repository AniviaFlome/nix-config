{
  username,
  ...
}:
{
  imports = [ ./hm-imports.nix ];

  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "23.05";
  };
}
