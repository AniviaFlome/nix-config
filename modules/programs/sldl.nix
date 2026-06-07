{
  flake.modules.homeManager.sldl =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        slsk-batchdl
        sldl-tui
      ];

      xdg.configFile."sldl/sldl.conf" = {
        recursive = true;
        text = ''
          [default]
          interactive = true

          [lossless]
          format = flac,alac,wav,aiff,ape

          [pref-lossless]
          pref-format = flac,alac,wav,aiff,ape

          [opus]
          format = opus

          [pref-opus]
          pref-format = opus
        '';
      };
    };
}
