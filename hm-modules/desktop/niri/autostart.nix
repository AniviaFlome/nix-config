{
  programs.niri.settings = {
    spawn-at-startup = [
      { command = [ "noctalia-shell" ]; }
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
    ];
  };
}
