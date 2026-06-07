{ inputs, ... }:
{
  flake.modules.nixos.nix-mineral = {
    imports = [ inputs.nix-mineral.nixosModules.nix-mineral ];
    nix-mineral.enable = true;
  };
}
