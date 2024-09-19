{ config, pkgs, ... }:

let
  scripts = [
    "winboot"
  ];
in

{
  home.packages = with pkgs; map (script: writeShellScriptBin script (builtins.readFile ./${script}.sh)) scripts;
}
