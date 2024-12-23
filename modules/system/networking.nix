{username, ... }:

{
  networking = {
    networkmanager.enable = true;
    nameservers = ["9.9.9.9"];
  };
  users.users.${username}.extraGroups = [ "networkmanager" ];

  services.resolved = {
    enable = true;
    dnssec = "true";
    dnsovertls = "true";
  };
}
