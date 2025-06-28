{ username, ... }:

{
  programs.adb.enable = true;

  users.users.${username}.extraGroups = [ "adbusers" ];
}
