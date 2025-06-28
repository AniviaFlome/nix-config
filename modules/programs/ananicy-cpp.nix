{ pkgs, ... }:

{
  services.ananicy = {
    enable = true;
    package = with pkgs; ananicy-cpp;
    rulesProvider = with pkgs; ananicy-rules-cachyos;
  };
}
