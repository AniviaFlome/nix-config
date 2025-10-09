{ pkgs, ... }:

let
  scripts = [
    "hyscript"
    "winboot"
    "stats"
  ];
in

{
  home.packages = with pkgs; map (script: writeShellScriptBin script (builtins.readFile ./${script})) scripts;
}
