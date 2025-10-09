{ pkgs, username, ... }:

{
  virtualisation.podman = {
    enable = true;
    dockerCompat = false;
    defaultNetwork.settings.dns_enabled = true;
    extraPackages = with pkgs; [ podman-compose ];
  };

  users.users.${username}.extraGroups = [ "podman" ];
}
