{ pkgs, inputs, system, ... }:

{
  home.packages = with pkgs; [
    niriswitcher
  ];

  programs.quickshell = {
    enable = true;
    package = inputs.noctalia.packages.${system}.default;
    systemd.enable = false;
  };
}
