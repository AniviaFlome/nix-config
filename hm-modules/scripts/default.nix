{ config, pkgs, ... }:

let
  scripts = [
    "hyprland-monitor"
    "hyscript"
    "winboot"
    "qute-pip"
  ];
in

{
  home.packages = with pkgs; map (script: writeShellScriptBin script (builtins.readFile ./${script}.sh)) scripts;
}
