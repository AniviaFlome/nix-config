{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    slsk-batchdl
    sldl-tui
  ];

  xdg.configFile."sldl/sldl.conf" = {
    text = ''
      [default]
      interactive = true

      [lossless]
      format = flac
      sort = bitrate

      [pref-lossless]
      pref-format = flac
      sort = bitrate

      [opus]
      format = opus

      [pref-opus]
      pref-format = opus
    '';
  };
}
