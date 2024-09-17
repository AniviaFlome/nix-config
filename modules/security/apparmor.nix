{ pkgs, ... }:

{
  security.apparmor = {
    enable = true;
    packages = with pkgs; [ pkgs.roddhjav-apparmor-rules ];
  };
}
