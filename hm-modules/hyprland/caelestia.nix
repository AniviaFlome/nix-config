{ inputs, ... }:

{
  imports = [ inputs.caelestia-shell.homeManagerModules.default ];

  programs.quickshell = {
    enable = true;
    package = (inputs.caelestia-shell.packages.${pkgs.system}.default.override { withCli = true; });
    systemd.enable = false;
  };
}
