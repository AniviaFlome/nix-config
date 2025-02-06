{ username, ... }:

{
  virtualisation.podman = {
    enable = true;
    defaultNetwork.settings = {
      dns_enabled = true;
    };
  };

  users.users.${username}.extraGroups = [ "podman" ];
}
