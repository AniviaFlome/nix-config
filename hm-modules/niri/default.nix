{ imports, ... }:

{
  imports = [ ./quickshell.nix ];

  xdg.configFile."niri" = {
    enable = true;
    source = ./niri;
    recursive = true;
  };
}
