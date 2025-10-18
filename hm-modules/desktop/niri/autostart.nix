{ pkgs, ... }:

{
  programs.niri.settings = {
    spawn-at-startup = [
      { command = [ "noctalia-shell" ]; }
      { command = [ "niriswitcher" ]; }
      {
        command = [
          "steam"
          "-silent"
        ];
      }
      {
        command = [
          "vesktop"
          "--start-minimized"
        ];
      }
      { command = [ "${pkgs.kdePackages.kwallet-pam}/bin/pam_kwallet_init" ]; }
    ];
  };
}
