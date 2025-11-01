{
  inputs,
  system,
  ...
}:
{
  imports = [ inputs.caelestia-shell.homeManagerModules.default ];

  programs.quickshell = {
    enable = true;
    package = inputs.caelestia-shell.packages.${system}.default.override {
      withCli = true;
    };
    systemd.enable = false;
  };
}
