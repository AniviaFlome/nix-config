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

  environment.systemPackages = with pkgs; [
    docker-compose
  ];

  users.users.${username}.extraGroups = [ "docker" ];
}
