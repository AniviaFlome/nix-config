{
  inputs,
  pkgs,
  ...
}:
{
  home.packages = (import ./ai-common.nix { inherit inputs pkgs; }).packages;
}
