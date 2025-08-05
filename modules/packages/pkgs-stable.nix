{ pkgs-stable, ... }: {

  environment.systemPackages = with pkgs-stable; [
gimp
grsync
normcap
pokerth
rpcs3
  ];
}
