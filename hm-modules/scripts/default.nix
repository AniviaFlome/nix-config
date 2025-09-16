{ config, pkgs, ... }:

let
  scripts = [
    "hyscript"
    "winboot"
    "qute-pip"
  ];
in

{
  home.packages = with pkgs; map (script: writeShellScriptBin script (builtins.readFile ./${script}.sh)) scripts;
}
