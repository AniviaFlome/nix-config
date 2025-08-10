{ username, ... }:

{
  virtualisation.podman = {
    enable = false;
    defaultNetwork.settings = {
      dns_enabled = true;
    };
  };

  users.users.${username}.extraGroups = [ "podman" ];
}
