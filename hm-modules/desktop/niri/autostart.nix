{
  programs.niri.settings = {
    spawn-at-startup = [
      { command = ["noctalia-shell"]; }
      { command = ["niriswitcher"]; }
      { command = ["steam" "-silent"]; }
      { command = [ "vesktop" "-no-startup-id" "--start-minimized"]; }
    ];
  };
}
