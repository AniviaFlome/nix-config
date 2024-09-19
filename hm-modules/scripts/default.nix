{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    (pkgs.writeShellScriptBin "winboot" (builtins.readFile ./winboot.sh))
  ];
}
