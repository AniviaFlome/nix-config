{
  inputs,
  ...
}:
{
  imports = [ inputs.nix-mineral.nixosModules.nix-mineral ];

  nix-mineral = {
    enable = true;
  };
}
