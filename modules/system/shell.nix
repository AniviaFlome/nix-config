{ pkgs, ... }:

{
  programs.fish.enable = true;
  users.defaultUserShell = with pkgs; fish;
}
