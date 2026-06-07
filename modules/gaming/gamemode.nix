{
  flake.modules.nixos.gamemode =
    { username, ... }:
    {
      programs.gamemode.enable = true;
      users.users.${username}.extraGroups = [ "gamemode" ];
    };
}
