{ username, ... }:
{
  networking = {
    networkmanager.enable = true;
  };

  users.users.${username}.extraGroups = [ "networkmanager" ];
}
