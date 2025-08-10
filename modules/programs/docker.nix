{ username, ... }:

{
  virtualisation.docker = {
    enable = false;
  };

  users.users.${username}.extraGroups = [ "docker" ];
}
