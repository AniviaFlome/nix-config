{ pkgs-stable, ... }:

{
  environment.systemPackages = [
    (pkgs-stable.ffmpeg-full.override { withUnfree = true; })
  ];
}
