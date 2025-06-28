{ pkgs-stable, ... }: {

  environment.systemPackages = with pkgs-stable; [
normcap
pokerth
rpcs3
  ];
}
