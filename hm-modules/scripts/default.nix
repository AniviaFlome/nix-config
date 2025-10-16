{ pkgs, ... }:

let
  scripts = [
    "hyscript"
    "winboot"
    "stats"
  ];
in

{
  home.packages = with pkgs; 
    (map (script: writeShellScriptBin script (builtins.readFile ./${script})) scripts) ++ 
  [
    alsa-utils    
    bat
    gawk
    lm_sensors
    sysstat
  ];
}
