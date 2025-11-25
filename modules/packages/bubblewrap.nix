{
  pkgs,
  ...
}:
{
  environment.systemPackages = [
    (pkgs.mkBwrapper {
      app = {
        package = with pkgs; youtube-music;
      };
      mounts = {
        readWrite = [
          "$XDG_CACHE_HOME"
          "$XDG_CONFIG_HOME"
          "$XDG_DATA_HOME"
        ];
      };
    })
    (pkgs.mkBwrapper {
      app = {
        package = with pkgs; qwen-code;
      };
      fhsenv.skipExtraInstallCmds = true;
      flatpak.enable = false;
      dbus.enable = false;
      sockets = {
        x11 = false;
        wayland = false;
        pipewire = false;
        pulseaudio = false;
      };
      mounts = {
        readWrite = [
          "$XDG_CACHE_HOME"
          "$XDG_CONFIG_HOME"
          "$XDG_DATA_HOME"
          "$HOME/.qwen"
          "$HOME/Random/dev"
          "$HOME/nix-config"
        ];
      };
    })
  ];
}
