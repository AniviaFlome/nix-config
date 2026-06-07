{
  flake.modules.nixos.ananicy-cpp =
    { pkgs, ... }:
    {
      services.ananicy = {
        enable = true;
        package = pkgs.ananicy-cpp;
        rulesProvider = pkgs.ananicy-rules-cachyos;
      };
    };
}
