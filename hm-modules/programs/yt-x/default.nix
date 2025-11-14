{
  inputs,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    inputs.yt-x.packages."${stdenv.hostPlatform.system}".default
  ];

  xdg.configFile."yt-x" = {
    source = ./yt-x;
    recursive = true;
    force = true;
  };
}
