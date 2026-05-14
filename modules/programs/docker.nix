{
  pkgs,
  username,
  ...
}:
{
  virtualisation.docker = {
    enable = true;
    extraPackages = with pkgs; [
      docker-compose
    ];
  };

  users.users.${username}.extraGroups = [ "docker" ];
}
