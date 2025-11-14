{
  inputs,
  pkgs,
  ...
}:
{
  imports = [ inputs.caelestia-shell.homeManagerModules.default ];

  programs.quickshell = {
    enable = true;
    package = inputs.caelestia-shell.packages.${pkgs.stdenv.hostPlatform.system}.default.override {
      withCli = true;
    };
    systemd.enable = false;
  };
}
